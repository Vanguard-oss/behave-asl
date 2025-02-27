import jsonata
import logging

from behaveasl.models.step_result import StepResult


LOG = logging.getLogger("behaveasl.jsonata_eval")


def replace_jsonata(input: str, sr: StepResult, context: dict, variables: dict) -> str:
    """Replace JSONata expressions in the input string with their evaluated values"""

    if input.startswith("{%") and input.endswith("%}"):

        state_data = {
            "input": sr.state_input,
            "context": context,
            "result": sr.result_data,
        }

        expr_str = input[2:-2].strip()
        expr = jsonata.Jsonata(expr_str)
        expr.assign("states", state_data)
        for k, v in variables.items():
            expr.assign(k, v)
        new_value = expr.evaluate({})

        LOG.debug(f"Replacing '{expr_str}' with '{new_value}', context='{state_data}'")
        return new_value

    return input


def evaluate_jsonata(input, sr: StepResult, context: dict, variables: dict) -> str:
    """Evaluate JSONata expression and return the result"""

    if not type(input) == str:
        return input
    if input.startswith("{%") and input.endswith("%}"):

        state_data = {
            "input": sr.state_input,
            "context": context,
            "result": sr.result_data,
        }

        expr_str = input[2:-2].strip()
        expr = jsonata.Jsonata(expr_str)
        expr.assign("states", state_data)
        for k, v in variables.items():
            expr.assign(k, v)
        new_value = expr.evaluate({})

        LOG.debug(f"Evaluating '{expr_str}' with '{new_value}', context='{state_data}'")
        return new_value

    return input
