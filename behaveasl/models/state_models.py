import copy
import json
import logging

from behaveasl.expr_eval import replace_expression
from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.abstract_state import AbstractStateModel
from behaveasl.models.catch import Catch
from behaveasl.models.choice import create_choice
from behaveasl.models.exceptions import StatesCompileException
from behaveasl.models.retry import Retry
from behaveasl.models.state_phases import (
    InputPathPhase,
    OutputPathPhase,
    ParametersPhase,
    ResultPathPhase,
    ResultSelectorPhase,
)
from behaveasl.models.step_result import StepResult


class PassResultPhase(AbstractPhase):
    def __init__(self, state_details: dict):
        self._next_state = state_details.get("Next", None)
        self._is_end = state_details.get("End", False)
        self._result = state_details.get("Result", None)
        self._comment = state_details.get("Comment", None)

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        if self._next_state is not None:
            sr.next_state = self._next_state
        sr.end_execution = self._is_end

        if self._result is None:
            return phase_input
        return self._result


# Order of classes follows: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-common-fields.html
class PassState(AbstractStateModel):
    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        if "Parameters" in state_details:
            self._phases.append(ParametersPhase(state_details["Parameters"]))
        self._phases.append(PassResultPhase(state_details))
        self._phases.append(ResultPathPhase(state_details.get("ResultPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

    def execute(self, state_input, execution):
        # This logic may be able to move into the base class
        sr = StepResult()
        current_data = copy.deepcopy(state_input)
        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data
        return sr


class TaskMockPhase(AbstractPhase):
    def __init__(self, state_details: dict):
        self._resource = state_details["Resource"]
        self._log = logging.getLogger("behaveasl.TaskMockPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        execution.resource_expectations.execute(self._resource, phase_input)
        resp = execution.resource_response_mocks.execute(self._resource, phase_input)
        self._log.debug(f"'{self._resource}' returned '{resp}'")
        return resp


class TaskState(AbstractStateModel):
    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        if "Parameters" in state_details:
            self._phases.append(ParametersPhase(state_details["Parameters"]))
        self._phases.append(TaskMockPhase(state_details))
        if "ResultSelector" in state_details:
            self._phases.append(
                ResultSelectorPhase(state_details.get("ResultSelector", "$"))
            )
        self._phases.append(ResultPathPhase(state_details.get("ResultPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

        self._next_state = state_details.get("Next", None)
        self._is_end = state_details.get("End", False)
        self._comment = state_details.get("Comment", None)
        self._resource = state_details.get("Resource", None)
        self._retry = state_details.get("Retry", None)
        self._catch = state_details.get("Catch", None)
        self._timeout_seconds = state_details.get("TimeoutSeconds", None)
        self._timeout_seconds_path = state_details.get("TimeoutSecondsPath", None)
        self._heartbeat_seconds = state_details.get("HeartbeatSeconds", None)
        self._heartbeat_seconds_path = state_details.get("HeartbeatSecondsPath", None)

        if self._resource is None:
            raise StatesCompileException("A Resource field must be provided.")

        if self._timeout_seconds and self._timeout_seconds_path:
            raise StatesCompileException(
                "Only one of TimeoutSeconds and TimeoutSecondsPath can be set."
            )

        if self._heartbeat_seconds and self._heartbeat_seconds_path:
            raise StatesCompileException(
                "Only one of HeartbeatSeconds and HeartbeatSecondsPath can be set."
            )

        self._retry_list = []
        if self._retry:
            for r in self._retry:
                self._retry_list.append(Retry(r))

        self._catch_list = []
        if self._catch:
            for c in self._catch:
                self._catch_list.append(Catch(c))

    def execute(self, state_input, execution):
        sr = StepResult()
        current_data = copy.deepcopy(state_input)
        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data

        if self._next_state is not None:
            sr.next_state = self._next_state
        sr.end_execution = self._is_end

        return sr


class ChoiceSelectionPhase(AbstractPhase):
    def __init__(self, state_details: dict):
        self._next_state = None
        # The set of Choices can also have a "Default" (if nothing matches) but is not required
        self._default_next_state = state_details.get("Default", None)
        self._choices = []
        # For choice in choice_list, create an instance of Choice and add it to the list
        for choice in state_details["Choices"]:
            # Each Choice *must* have a "Next" field
            if "Next" not in choice.keys():
                raise StatesCompileException(
                    "Each Choice requires an associated Next field."
                )

            self._choices.append((create_choice(choice), choice["Next"]))

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        # Given the state input, we need to try to find matching Choice(s)
        # matching_choices = filter(self.apply_rules, self._choices) # Can probably do this with a filter ultimately
        for choice_tuple in self._choices:
            choice = choice_tuple[0]
            choice_next = choice_tuple[1]
            # Call evaluate on the choice instance, which will return True or False
            if (
                choice.evaluate(
                    state_input=state_input,
                    phase_input=phase_input,
                    sr=sr,
                    execution=execution,
                )
                == True
            ):
                # If 2 choices match, we choose the first one
                sr.next_state = choice_next
                # Choice does not modify phase input currently
                return phase_input
        # If we still have not found a matching choice, and we have a default, use it
        if self._next_state is None:
            if self._default_next_state is not None:
                sr.next_state = self._default_next_state
                # Choice does not modify phase input currently
                return phase_input
                # If we have NO matching Choices and no Default, throw an error, set StepResult w/failed + cause + error
            else:
                # Execution does not end because Choice states can't end an execution on their own
                sr.failed = True
                # TODO: set error and cause correctly
                sr.error = "No match found"
                sr.cause = "No match found"
                sr.next_state = None
                # Choice does not modify phase input currently
                return phase_input


class ChoiceState(AbstractStateModel):
    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        if "Parameters" in state_details:
            self._phases.append(ParametersPhase(state_details["Parameters"]))
        self._phases.append(ChoiceSelectionPhase(state_details))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))
        self.state_name = state_name

    def execute(self, state_input, execution):
        # TODO: implement
        sr = StepResult()
        current_data = copy.deepcopy(state_input)

        # Phase processing
        for phase in self._phases:
            current_data = phase.execute(
                state_input=state_input,
                phase_input=current_data,
                sr=sr,
                execution=execution,
            )
            # Note this is not the same way the other States do this
        sr.result_data = current_data

        # sr.next_state gets set in the execute phase for ChoiceSelection
        if sr.next_state is not None:
            self._next_state = sr.next_state

        return sr


class WaitState(AbstractStateModel):
    def __init__(self, state_name: str, state_details):
        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

        self._next_state = state_details.get("Next", None)
        self._is_end = state_details.get("End", False)
        self._comment = state_details.get("Comment", None)

        self._seconds = state_details.get("Seconds", None)
        self._timestamp = state_details.get("Timestamp", None)
        self._seconds_path = state_details.get("SecondsPath", None)
        self._timestamp_path = state_details.get("TimestampPath", None)

        if (
            not sum(
                bool(x)
                for x in [
                    self._seconds,
                    self._timestamp,
                    self._seconds_path,
                    self._timestamp_path,
                ]
            )
            == 1
        ):
            raise StatesCompileException(
                "Only one of Seconds, Timestamp, SecondsPath or TimestampPath may be set."
            )

    def execute(self, state_input, execution):
        """The wait state delays the state machine from continuing for a specified time"""
        sr = StepResult()
        current_data = copy.deepcopy(state_input)
        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data

        if self._next_state is not None:
            sr.next_state = self._next_state
        sr.end_execution = self._is_end

        if self._seconds:
            sr.waited_seconds = self._seconds
        elif self._timestamp:
            sr.waited_until_timestamp = self._timestamp
        elif self._seconds_path:
            parsed_seconds = replace_expression(
                expr=self._seconds_path, input=state_input, context=execution.context
            )
            sr.waited_seconds = parsed_seconds
        elif self._timestamp_path:
            parsed_timestamp = replace_expression(
                expr=self._timestamp_path, input=state_input, context=execution.context
            )
            sr.waited_until_timestamp = parsed_timestamp

        return sr


class SucceedState(AbstractStateModel):
    """The Succeed state terminates that machine and marks it as a success"""

    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

    def execute(self, state_input, execution):
        sr = StepResult()
        sr.end_execution = True
        current_data = copy.deepcopy(state_input)
        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data

        return sr


class FailState(AbstractStateModel):
    """The Fail state terminates the machine and marks it as a failure"""

    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

        self._error = state_details.get("Error", None)
        self._cause = state_details.get("Cause", None)

    def execute(self, state_input, execution):
        """The fail state will optionally raise an error with a cause"""
        sr = StepResult()
        sr.end_execution = True
        sr.failed = True
        sr.error = self._error
        sr.cause = self._cause

        current_data = copy.deepcopy(state_input)
        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data

        return sr


class ParallelMockPhase(AbstractPhase):
    def __init__(self, state_name, state_details: dict):
        self._log = logging.getLogger("behaveasl.ParallelMockPhase")
        self._parallel_state_machines = state_details["Branches"]

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        output = []
        idx = -1
        sr.branch_input = copy.deepcopy(phase_input)
        for machine in self._parallel_state_machines:
            idx = idx + 1
            resp = execution.resource_response_mocks.execute(idx, phase_input)
            output.append(resp)
        return output


class ParallelState(AbstractStateModel):
    def __init__(self, state_name, state_details, **kwargs):
        self._branches = state_details.get("Branches", None)
        if self._branches is None:
            raise StatesCompileException("An Branches field must be provided.")

        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        if "Parameters" in state_details:
            self._phases.append(ParametersPhase(state_details["Parameters"]))
        self._phases.append(ParallelMockPhase(state_name, state_details))
        if "ResultSelector" in state_details:
            self._phases.append(
                ResultSelectorPhase(state_details.get("ResultSelector", "$"))
            )
        self._phases.append(ResultPathPhase(state_details.get("ResultPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

        self._next_state = state_details.get("Next", None)
        self._is_end = state_details.get("End", False)
        self._comment = state_details.get("Comment", None)

        self._retry = state_details.get("Retry", None)
        self._catch = state_details.get("Catch", None)

        if self._retry:
            self._retry_list = []
            for r in self._retry:
                self._retry_list.append(Retry(r))

        if self._catch:
            self._catch_list = []
            for c in self._catch:
                self._catch_list.append(Catch(c))

    def execute(self, state_input, execution):
        """The parallel state can be used to create parallel branches of
        execution in a state machine"""
        sr = StepResult()
        current_data = copy.deepcopy(state_input)

        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data

        if self._next_state is not None:
            sr.next_state = self._next_state
        sr.end_execution = self._is_end

        return sr


class ItemsPathPhase(AbstractPhase):
    def __init__(self, state_details: dict):
        self._items_path = state_details.get("ItemsPath", "$")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = replace_expression(
            expr=self._items_path, input=phase_input, context=execution.context
        )
        return phase_output


class MapMockPhase(AbstractPhase):
    def __init__(self, state_name, state_details: dict):
        self._log = logging.getLogger("behaveasl.MapMockPhase")
        self._state_name = state_name
        self._state_details = state_details

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        self._state_input = state_input
        self._phase_input = phase_input
        self._sr = sr
        self._execution = execution
        return list(map(self.execute_single, enumerate(phase_input)))

    def execute_single(self, input):
        # https://docs.aws.amazon.com/step-functions/latest/dg/input-output-contextobject.html#contextobject-map
        self._execution.context["Map"]["Item"]["Index"] = input[0]
        self._execution.context["Map"]["Item"]["Value"] = input[1]
        iteration_value = input[1]

        if "Parameters" in self._state_details:
            inp = InputPathPhase(self._state_details.get("InputPath", "$"))
            inp_phase_output = inp.execute(
                self._state_input, self._state_input, self._sr, self._execution
            )

            param = ParametersPhase(self._state_details["Parameters"])

            iteration_value = param.execute(
                self._state_input, inp_phase_output, self._sr, self._execution
            )

        if isinstance(iteration_value, dict):
            mock_value = json.dumps(iteration_value, sort_keys=True)
        else:
            mock_value = iteration_value

        shared_key = ""
        for k in list(self._execution.resource_expectations._map.keys()):
            exec_result = self._execution.resource_expectations.execute(
                k, self._phase_input
            )
            try:
                sorted = json.dumps(json.loads(exec_result), sort_keys=True)
                if sorted == mock_value:
                    shared_key = k
                    break
            except:
                if exec_result == mock_value:
                    shared_key = k
                    break

        if shared_key:
            return self._execution.resource_response_mocks.execute(
                shared_key, self._phase_input
            )
        elif "unknown" in self._execution.resource_response_mocks._map.keys():
            return self._execution.resource_response_mocks._map["unknown"].execute(
                "unknown", ""
            )
        else:
            raise KeyError


class MapState(AbstractStateModel):
    def __init__(self, state_name, state_details, **kwargs):
        self._iterator = state_details.get("Iterator", None)
        if self._iterator is None:
            raise StatesCompileException("An Iterator field must be provided.")

        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        self._phases.append(ItemsPathPhase(state_details))
        self._phases.append(MapMockPhase(state_name, state_details))
        if "ResultSelector" in state_details:
            self._phases.append(
                ResultSelectorPhase(state_details.get("ResultSelector", "$"))
            )
        self._phases.append(ResultPathPhase(state_details.get("ResultPath", "$")))
        self._phases.append(OutputPathPhase(state_details.get("OutputPath", "$")))

        self._next_state = state_details.get("Next", None)
        self._is_end = state_details.get("End", False)
        self._comment = state_details.get("Comment", None)

        self._max_concurrency = state_details.get("MaxConcurrency", None)
        self._retry = state_details.get("Retry", None)
        self._catch = state_details.get("Catch", None)

        if self._retry:
            self._retry_list = []
            for r in self._retry:
                self._retry_list.append(Retry(r))

        if self._catch:
            self._catch_list = []
            for c in self._catch:
                self._catch_list.append(Catch(c))

    def execute(self, state_input, execution):
        """The map state can be used to run a set of steps for each element of an input array"""
        sr = StepResult()
        current_data = copy.deepcopy(state_input)

        for phase in self._phases:
            current_data = phase.execute(state_input, current_data, sr, execution)
        sr.result_data = current_data

        if self._next_state is not None:
            sr.next_state = self._next_state
        sr.end_execution = self._is_end

        return sr
