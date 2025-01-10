import copy
import logging

from behaveasl import expr_eval, jsonata_eval, jsonpath
from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.exceptions import StatesCompileException
from behaveasl.models.query_language import QueryLanguage
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
        if "ResultPath" in self.state.state_details and not self.is_using_jsonpath():
            raise StatesCompileException("ResultPath can only be used with JSONPath")
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

        if "Parameters" in self.state.state_details:
            if self.is_using_jsonpath():
                phase_output = {}
                phase_output = self.parse_phase_output(
                    current_parameters=self._parameters,
                    phase_input=phase_input,
                    execution=execution,
                )
                sr.parameters = copy.deepcopy(phase_output)
            else:
                # https://docs.aws.amazon.com/step-functions/latest/dg/state-pass.html
                # The docs say Parameters is only valid with JSONPath
                raise StatesCompileException(
                    "Parameters can only be used with JSONPath"
                )
        elif "ItemSelector" in self.state.state_details and self.is_using_jsonpath():
            phase_output = {}
            phase_output = self.parse_phase_output(
                current_parameters=self._parameters,
                phase_input=phase_input,
                execution=execution,
            )
            sr.parameters = copy.deepcopy(phase_output)
        else:
            phase_output = phase_input

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
                        expr=v,
                        input=phase_input,
                        context=execution.context,
                        variables=execution.get_current_variables(),
                    )
                    phase_output[k[0:-2]] = new_value

                else:
                    phase_output[k] = v
            self._log.debug(
                f"ParametersPhase: Replaced '{phase_input}' with '{phase_output}', params='{self._parameters}'"
            )
        return phase_output


class JsonataResolverPhase(AbstractPhase):
    def __init__(self, data, **kwargs):
        super(JsonataResolverPhase, self).__init__(**kwargs)
        self._data = data
        self._log = logging.getLogger("behaveasl.JsonataResolverPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):

        phase_output = {}
        if self.is_using_jsonata():
            phase_output = self._process_data(self._data, sr, execution)
            sr.parameters = copy.deepcopy(phase_output)
        else:
            phase_output = phase_input

        return phase_output

    def _process_data(self, data, sr: StepResult, execution):
        if isinstance(data, dict):
            ret = {}
            for k, v in data.items():
                ret[k] = self._process_data(v, sr, execution)
            return ret
        elif isinstance(data, list):
            return [self._process_data(v, sr, execution) for v in data]
        elif isinstance(data, str):
            return jsonata_eval.replace_jsonata(
                data, sr, execution.context, execution.get_current_variables()
            )
        else:
            return data


class ArgumentsPhase(AbstractPhase):
    def __init__(self, arguments, **kwargs):
        super(ArgumentsPhase, self).__init__(**kwargs)
        self._arguments = arguments
        self._log = logging.getLogger("behaveasl.ArgumentsPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):

        phase_output = {}
        if self.is_using_jsonata():
            phase_output = self._process_data(self._arguments, sr, execution)
            sr.parameters = copy.deepcopy(phase_output)
        else:
            phase_output = phase_input

        return phase_output

    def _process_data(self, data, sr: StepResult, execution):
        if isinstance(data, dict):
            ret = {}
            for k, v in data.items():
                ret[k] = self._process_data(v, sr, execution)
            return ret
        elif isinstance(data, list):
            return [self._process_data(v, sr, execution) for v in data]
        elif isinstance(data, str):
            return jsonata_eval.replace_jsonata(
                data, sr, execution.context, execution.get_current_variables()
            )
        else:
            return data


class AssignPhase(AbstractPhase):
    def __init__(self, assign_input: dict = None, **kwargs):
        super(AssignPhase, self).__init__(**kwargs)
        self._input = assign_input or {}
        self._log = logging.getLogger("behaveasl.AssignPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        if self.is_using_jsonata():
            sr.result_data = phase_input

        sr.assigned_variables = self._process_data(
            self._input, phase_input, sr, execution
        )
        return phase_input

    def _process_data(self, data, input, sr: StepResult, execution):
        if isinstance(data, dict):
            ret = {}
            for k, v in data.items():
                if k.endswith(".$"):
                    if self._query_language != QueryLanguage.JSONPATH:
                        raise StatesCompileException(
                            f"State [{self._state_name}] cannot assign a JSONPath variable with a non-JSONPath query language"
                        )
                    if isinstance(v, str):
                        ret[k[0:-2]] = expr_eval.replace_expression(
                            expr=v,
                            input=input,
                            context=execution.context,
                            variables=execution.get_current_variables(),
                        )
                    else:
                        raise StatesCompileException(
                            f"State [{self._state_name}] cannot assign a non-string value to a JSONPath variable"
                        )
                else:
                    ret[k] = self._process_data(v, input, sr, execution)
            return ret
        elif isinstance(data, list):
            return [self._process_data(v, input, sr, execution) for v in data]
        elif isinstance(data, str):
            if self._query_language == QueryLanguage.JSONATA:
                return jsonata_eval.replace_jsonata(
                    data, sr, execution.context, execution.get_current_variables()
                )
            return data
        else:
            return data


class OutputPhase(AbstractPhase):
    def __init__(self, **kwargs):
        super(OutputPhase, self).__init__(**kwargs)
        self._log = logging.getLogger("behaveasl.OutputPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        if "Output" in self.state.state_details:
            if self.is_using_jsonata():
                sr.result_data = phase_input
                phase_output = self._process_data(
                    self.state.state_details["Output"], sr, execution
                )
                self._log.info(
                    f"Replaced '{phase_input}' with '{phase_output}', context='{execution.context}'"
                )
            else:
                # https://docs.aws.amazon.com/step-functions/latest/dg/statemachine-structure.html
                # The docs say Output is only valid with JSONata
                raise StatesCompileException("Output can only be used with JSONata")
        else:
            phase_output = phase_input

        return phase_output

    def _process_data(self, data, sr: StepResult, execution):
        if isinstance(data, dict):
            ret = {}
            for k, v in data.items():
                ret[k] = self._process_data(v, sr, execution)
            return ret
        elif isinstance(data, list):
            return [self._process_data(v, sr, execution) for v in data]
        elif isinstance(data, str):
            return jsonata_eval.replace_jsonata(
                data, sr, execution.context, execution.get_current_variables()
            )
        else:
            return data


class OutputPathPhase(AbstractPhase):
    def __init__(self, output_path: str = "$", **kwargs):
        super(OutputPathPhase, self).__init__(**kwargs)
        self._path = output_path
        self._log = logging.getLogger("behaveasl.OutputPathPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        if self.is_using_jsonpath():
            phase_output = expr_eval.replace_expression(
                expr=self._path,
                input=phase_input,
                context=execution.context,
                variables=execution.get_current_variables(),
            )
            self._log.debug(
                f"Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
            )
        elif "OutputPath" in self.state.state_details:
            # https://docs.aws.amazon.com/step-functions/latest/dg/statemachine-structure.html
            # The docs say OutputPath is only valid with JSONPath
            raise StatesCompileException("OutputPath can only be used with JSONPath")
        else:
            phase_output = phase_input

        return phase_output


class InputPathPhase(AbstractPhase):
    def __init__(self, input_path: str = "$", **kwargs):
        super(InputPathPhase, self).__init__(**kwargs)
        self._path = input_path
        self._log = logging.getLogger("behaveasl.InputPathPhase")

    def execute(self, state_input, phase_input, sr: StepResult, execution):
        sr.state_input = state_input

        if self.is_using_jsonpath():
            phase_output = expr_eval.replace_expression(
                expr=self._path,
                input=phase_input,
                context=execution.context,
                variables=execution.get_current_variables(),
            )
            self._log.debug(
                f"Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
            )
        elif "InputPath" in self.state.state_details:
            # https://docs.aws.amazon.com/step-functions/latest/dg/statemachine-structure.html
            # The docs say InputPath is only valid with JSONPath
            raise StatesCompileException("InputPath can only be used with JSONPath")
        else:
            phase_output = phase_input
        return phase_output


class ResultSelectorPhase(AbstractPhase):
    def __init__(self, result_selector: dict, **kwargs):
        super(ResultSelectorPhase, self).__init__(**kwargs)
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
                        expr=v,
                        input=phase_input,
                        context=execution.context,
                        variables=execution.get_current_variables(),
                    )
                    phase_output[k[0:-2]] = new_value
                else:
                    phase_output[k] = v
            self._log.debug(
                f"ResultSelectorPhase: Replaced '{phase_input}' with '{phase_output}', selector='{self._selector}'"
            )
        return phase_output
