import copy
import logging
import json

from behaveasl.expr_eval import replace_expression
from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.abstract_state import AbstractStateModel
from behaveasl.models.catch import Catch
from behaveasl.models.choice import Choice
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

        if self._retry:
            self._retry_list = []
            for r in self._retry:
                self._retry_list.append(Retry(r))

        if self._catch:
            self._catch_list = []
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


class ChoiceState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     self.choice_list = None
    #     # TODO: for choice in choice_list, create an instance of Choice and add it to the list
    #     pass

    def execute(self, state_input, execution):
        # TODO: implement
        pass


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


class ParallelState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input, execution):
        """The fail state will always raise an error with a cause"""
        # TODO: implement
        pass


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

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        self._execution = execution
        return list(map(self.execute_single, phase_input))

    def execute_single(self, input, **kwargs):
        # Don't know what params go in, phase_input OR state_input
        # TODO: in context.execution.resource_response_mocks find the mathcing key for input
        # If key is not found, look for unknown
        # Return the value in the _map response
        # INPUT:
        # [
        #     { "prod": "R31", "dest-code": 9511, "quantity": 1344 },
        #     { "prod": "S39", "dest-code": 9511, "quantity": 40 },
        #     { "prod": "R31", "dest-code": 9833, "quantity": 12 },
        #     { "prod": "R40", "dest-code": 9860, "quantity": 887 },
        #     { "prod": "R40", "dest-code": 9511, "quantity": 1220 }
        # ]
        matched = False
        merged_output = input
        for k, v in self._execution.resource_response_mocks._map.items():
            if "{" in k:
                key_dict = json.loads(k)
            else:
                key_dict = k
            if input == key_dict:
                matched = True
                value_to_add = v._response

        if not matched:
            unknown_response = self._execution.resource_response_mocks._map.get(
                "unknown"
            )
            if unknown_response:
                value_to_add = unknown_response._response
            else:
                return merged_output

        merged_output["color"] = value_to_add

        return merged_output


class MapState(AbstractStateModel):
    def __init__(self, state_name, state_details, **kwargs):
        self._iterator = state_details.get("Iterator", None)
        if self._iterator is None:
            raise StatesCompileException("An Iterator field must be provided.")

        self._phases = []
        self._phases.append(InputPathPhase(state_details.get("InputPath", "$")))
        self._phases.append(ItemsPathPhase(state_details))
        if "Parameters" in state_details:
            self._phases.append(ParametersPhase(state_details["Parameters"]))
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
