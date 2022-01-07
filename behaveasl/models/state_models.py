import copy

from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.abstract_state import AbstractStateModel
from behaveasl.models.choice import Choice
from behaveasl.models.retry import Retry
from behaveasl.models.state_phases import (
    InputPathPhase,
    OutputPathPhase,
    ParametersPhase,
    ResultPathPhase,
)
from behaveasl.models.step_result import StepResult


class PassResultPhase(AbstractPhase):
    def __init__(self, state_details):
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
    def __init__(self, state_name, state_details, **kwargs):
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


class TaskState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        pass
        # def __init__(self, state_name, state_details):
        # self.state_name = state_name
        # self.resource = None
        # self.next_state = None
        # self.retry_list = None
        # self.input = None # For a non-SDK call - note that input and parameters will both work for either SDK or non-SDK calls
        # self.parameters = None # For an SDK call - note that input and parameters will both work for either SDK or non-SDK calls
        # # TODO: for retry in retry_list, create an instance of Retry and add it to the list
        pass

    def execute(self, state_input):
        # TODO: implement
        pass


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

    def __init__(self, state_name, state_details, **kwargs):
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

    def __init__(self, state_name, state_details, **kwargs):
        self._error = state_details.get("Error", None)
        self._cause = state_details.get("Cause", None)

    def execute(self, state_input, execution):
        """The fail state will optionally raise an error with a cause"""
        res = StepResult()
        res.end_execution = True
        res.failed = True

        # TODO: figure out if error and cause go in result data or somewhere else
        res.result_data = {}
        res.result_data["Error"] = self._error
        res.result_data["Cause"] = self._cause

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
