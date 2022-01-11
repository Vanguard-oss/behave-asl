import copy

from behaveasl import expr_eval, jsonpath
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

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        execution.resource_expectations.execute(self._resource, phase_input)
        resp = execution.resource_response_mocks.execute(self._resource, phase_input)
        print(f"TaskMockPhase: '{self._resource}' returned '{resp}'")
        return resp


class TaskState(AbstractStateModel):
    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._phases = []
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
    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self.state_name = state_name
        self._choices = []
        # The set of Choices can also have a "Default" (if nothing matches) but is not required
        self._default_next_state=state_details.get("Default", None)

        # For choice in choice_list, create an instance of Choice and add it to the list
        for choice in state_details["Choices"]:
            # Each Choice *must* have a "Next" field
            if 'Next' not in choice.keys():
                raise StatesCompileException("Each Choice requires an associated Next field.")

            # TODO: deal with Boolean Choices like Or/And where there will be multiple conditions
            # They will be recognizable either by the "And"/"Or"/etc or by their list type
            # If we have one of those, we need sub-Choices (recurse)
            
            # To get the evaluation type, we need to find the key that isn't 'Variable' or 'Next'
            # the remaining key should be the evaluation type and value
            evaluation_type=list(filter(lambda x: x not in ['Variable', 'Next'], choice.keys()))[0]

            self._choices.append(Choice(variable=choice["Variable"], evaluation_type=evaluation_type,
            evaluation_value=choice[evaluation_type], next_state=choice['Next']))
        
    def execute(self, state_input, execution):
        # TODO: implement
        self._state_input = state_input
        sr = StepResult()
        current_data = copy.deepcopy(state_input) # TODO: determine if the data input to a Choice continues on
        # Given the state input, we need to try to find matching Choice(s)
        # matching_choices = filter(self.apply_rules, self._choices) # Can probably do this with a filter ultimately
        matching_rules = []
        for choice in self._choices:
            # Call evaluate on the choice instance, which will return True or False
            if choice.evaluate(state_input=self._state_input) == True:
                matching_rules.append(Choice)
        # TODO: what happens if 2+ choices match?!?
        # If we only have 1 matching Choice, set the next_state from the choice.next_state property
        if len(matching_rules) == 1:
            self._next_state = choice.next_state
        # If we have NO matching Choices, throw an error, set StepResult w/failed + cause + error

        if self._next_state is not None:
            sr.next_state = self._next_state
            
        return sr

class WaitState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input, execution):
        """The fail state will always raise an error with a cause"""
        # TODO: implement
        pass


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
        self._error = state_details.get("Error", None)
        self._cause = state_details.get("Cause", None)

    def execute(self, state_input, execution):
        """The fail state will optionally raise an error with a cause"""
        res = StepResult()
        res.end_execution = True
        res.failed = True
        res.error = self._error
        res.cause = self._cause
        res.result_data = None

        return res


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


class MapState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input, execution):
        """The fail state will always raise an error with a cause"""
        # TODO: implement
        pass
