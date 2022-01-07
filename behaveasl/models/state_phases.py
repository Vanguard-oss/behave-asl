import copy

from behaveasl import expr_eval, jsonpath
from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.step_result import StepResult


class ResultPathPhase(AbstractPhase):
    def __init__(self, result_path: str = "$", **kwargs):
        super(ResultPathPhase, self).__init__(**kwargs)
        self._path = result_path
        self._expr = jsonpath.get_instance(result_path)

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        # jsonpath-ng doesn't seem to handle the '$' copy the same way AWS does
        if self._path == "$":
            phase_output = phase_input
        else:
            phase_output = copy.deepcopy(state_input)
            self._expr.update_or_create(phase_output, phase_input)
        print(
            f"ResultPathPhase: Replaced '{state_input}' with '{phase_output}', path='{self._path}', input='{phase_input}'"
        )
        return phase_output


class ParametersPhase(AbstractPhase):
    def __init__(self, parameters, **kwargs):
        super(ParametersPhase, self).__init__(**kwargs)
        self._parameters = parameters

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
            print(
                f"ParametersPhase: Replaced '{phase_input}' with '{phase_output}', params='{self._parameters}'"
            )
        return phase_output


class OutputPathPhase(AbstractPhase):
    def __init__(self, output_path: str = "$", **kwargs):
        super(OutputPathPhase, self).__init__(**kwargs)
        self._path = output_path

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = expr_eval.replace_expression(
            expr=self._path, input=phase_input, context=execution.context
        )
        print(
            f"OutputPathPhase: Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
        )
        return phase_output


class InputPathPhase(AbstractPhase):
    def __init__(self, input_path: str = "$", **kwargs):
        super(InputPathPhase, self).__init__(**kwargs)
        self._path = input_path

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        phase_output = expr_eval.replace_expression(
            expr=self._path, input=phase_input, context=execution.context
        )
        print(
            f"InputPathPhase: Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
        )
        return phase_output
