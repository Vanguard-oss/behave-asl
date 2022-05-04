import copy
import logging

from behaveasl import expr_eval, jsonpath
from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.step_result import StepResult


class Path(AbstractPhase):
    def __init__(self, result_path: str = "$", **kwargs):
        super(Path, self).__init__(**kwargs)
        self._path = result_path
        self._expr = jsonpath.get_instance(result_path)
        self._log = logging.getLogger("behaveasl.Path")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        if self._path.startswith("$."):
            jpexpr = jsonpath.get_instance(self._path)
            results = jpexpr.find(phase_input)
            if len(results) == 1:
                new_value = results[0].value
                print(f"Matched '{self._path}' [from phase_input] with '{new_value}'")
                return new_value
            else:
                return None
        # TODO: determine if we need to deal with nesting or if json-ng
        # can just handle this locator

    def is_present(self, state_input, phase_input):
        if self._path.startswith("$."):
            jpexpr = jsonpath.get_instance(self._path)
            results = jpexpr.find(phase_input)
            if len(results) == 1:
                new_value = results[0].value
                print(f"Matched '{self._path}' [from phase_input] with '{new_value}'")
                return True
            else:
                return False
        # TODO: determine if we need to deal with nesting or if json-ng
        # can just handle this locator


class ResultPathPhase(AbstractPhase):
    def __init__(self, result_path: str = "$", **kwargs):
        super(ResultPathPhase, self).__init__(**kwargs)
        self._path = result_path
        self._expr = None if result_path is None else jsonpath.get_instance(result_path)
        self._log = logging.getLogger("behaveasl.ResultPathPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        # jsonpath-ng doesn't seem to handle the '$' copy the same way AWS does
        if self._path == "$":
            phase_output = phase_input
        elif self._path is None:
            # If you set ResultPath to null, it will pass the original input to the output.
            # Using "ResultPath": null, the state's input payload will be copied directly
            # to the output, with no regard for the result.
            # https://docs.aws.amazon.com/step-functions/latest/dg/input-output-resultpath.html
            phase_output = copy.deepcopy(state_input)
        else:
            phase_output = copy.deepcopy(state_input)
            self._expr.update_or_create(phase_output, phase_input)
        self._log.debug(
            f"Replaced '{state_input}' with '{phase_output}', path='{self._path}', input='{phase_input}'"
        )
        return phase_output


class ParametersPhase(AbstractPhase):
    def __init__(self, parameters, **kwargs):
        super(ParametersPhase, self).__init__(**kwargs)
        self._parameters = parameters
        self._log = logging.getLogger("behaveasl.ParametersPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = {}
        phase_output = self.parse_phase_output(
            current_parameters=self._parameters,
            phase_input=phase_input,
            execution=execution,
        )
        return phase_output

    def parse_phase_output(
        self, *, current_parameters, phase_input, phase_output=None, execution
    ):
        if phase_output is None:
            phase_output = {}
        for k, v in current_parameters.items():
            # If 'v' is a dictionary, recurse - else:
            if type(v) == dict:
                new_dict = {}
                phase_output[k] = new_dict
                self.parse_phase_output(
                    current_parameters=v,
                    phase_input=phase_input,
                    phase_output=new_dict,
                    execution=execution,
                )
            else:
                # Base cases
                # If 'v' is a JsonPath, then eval it against the state_input
                if k.endswith(".$"):

                    new_value = expr_eval.replace_expression(
                        expr=v, input=phase_input, context=execution.context
                    )
                    phase_output[k[0:-2]] = new_value

                else:
                    phase_output[k] = v
            self._log.debug(
                f"ParametersPhase: Replaced '{phase_input}' with '{phase_output}', params='{self._parameters}'"
            )
        return phase_output


class OutputPathPhase(AbstractPhase):
    def __init__(self, output_path: str = "$", **kwargs):
        super(OutputPathPhase, self).__init__(**kwargs)
        self._path = output_path
        self._log = logging.getLogger("behaveasl.OutputPathPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = expr_eval.replace_expression(
            expr=self._path, input=phase_input, context=execution.context
        )
        self._log.debug(
            f"Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
        )
        return phase_output


class InputPathPhase(AbstractPhase):
    def __init__(self, input_path: str = "$", **kwargs):
        super(InputPathPhase, self).__init__(**kwargs)
        self._path = input_path
        self._log = logging.getLogger("behaveasl.InputPathPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = expr_eval.replace_expression(
            expr=self._path, input=phase_input, context=execution.context
        )
        self._log.debug(
            f"Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
        )
        return phase_output


class ResultSelectorPhase(AbstractPhase):
    def __init__(self, result_selector: dict):
        self._selector = result_selector
        self._log = logging.getLogger("behaveasl.ResultSelectorPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = {}
        phase_output = self.parse_phase_output(
            current_selector=self._selector,
            phase_input=phase_input,
            execution=execution,
        )
        return phase_output

    def parse_phase_output(
        self, *, current_selector, phase_input, phase_output=None, execution=None
    ):
        if phase_output is None:
            phase_output = {}
        for k, v in current_selector.items():
            # If 'v' is a dictionary, recurse - else:
            if type(v) == dict:
                new_dict = {}
                phase_output[k] = new_dict
                self.parse_phase_output(
                    current_selector=v,
                    phase_input=phase_input,
                    phase_output=new_dict,
                    execution=execution,
                )
            else:

                # Base cases
                # If 'v' is a JsonPath, then eval it against the state_input
                if k.endswith(".$"):
                    new_value = expr_eval.replace_expression(
                        expr=v, input=phase_input, context=execution.context
                    )
                    phase_output[k[0:-2]] = new_value
                else:
                    phase_output[k] = v
            self._log.debug(
                f"ResultSelectorPhase: Replaced '{phase_input}' with '{phase_output}', selector='{self._selector}'"
            )
        return phase_output
