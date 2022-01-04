import copy

import jsonpath_ng

from behaveasl.models.abstract_state import AbstractStateModel
from behaveasl.models.choice import Choice
from behaveasl.models.retry import Retry
from behaveasl.models.step_result import StepResult


# Order of classes follows: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-common-fields.html
class PassState(AbstractStateModel):
    def __init__(self, state_name, state_details, **kwargs):
        self._parameters = state_details.get("Parameters", None)
        self._result = state_details.get("Result", None)
        self._result_path = state_details.get("ResultPath", None)
        self._next_state = state_details.get("Next", None)
        self._is_end = state_details.get("End", False)

    def execute(self, state_input):
        """Either set the next state or end the execution"""
        output = copy.deepcopy(state_input)
        input = {}

        if self._result is not None:
            # If the Result was specified, then use that as the Input
            input = self._result

        elif self._parameters is not None:
            # If Parameters were specified, then create the input based on the
            # Parameters
            for k, v in self._parameters.items():
                # If 'v' is a JsonPath, then eval it against the state_input
                if k.endswith(".$"):
                    jpexpr = jsonpath_ng.parse(v)
                    results = jpexpr.find(state_input)
                    if len(results) == 1:
                        input[k[0:-2]] = results[0].value
                else:
                    input[k] = v

        res = StepResult()
        if self._next_state is not None:
            res.next_state = self._next_state
        res.end_execution = self._is_end

        if self._result_path is not None:
            jpexpr = jsonpath_ng.parse(self._result_path)
            jpexpr.update_or_create(output, input)
        elif type(input) == dict:
            output.update(input)
        else:
            output = input

        res.result_data = output

        return res


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

    def execute(self, state_input):
        # TODO: implement
        pass


class WaitState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        """The fail state will always raise an error with a cause"""
        # TODO: implement
        pass


class SucceedState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        # TODO: implement
        pass


class FailState(AbstractStateModel):
    """The Fail state terminates the machine and marks it as a failure"""

    def __init__(self, state_name, state_details, **kwargs):
        self._error = state_details.get("Error", None)
        self._cause = state_details.get("Cause", None)

    def execute(self, state_input):
        """The fail state will optionally raise an error with a cause"""
        res = StepResult()
        res.end_execution = True
        res.failed = True

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

    def execute(self, state_input):
        """The fail state will always raise an error with a cause"""
        # TODO: implement
        pass


class MapState(AbstractStateModel):
    def __init__(self, *args, **kwargs):

        pass

    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        """The fail state will always raise an error with a cause"""
        # TODO: implement
        pass
