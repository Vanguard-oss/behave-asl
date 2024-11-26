import jsonata
import logging

from behaveasl.models.step_result import StepResult


LOG = logging.getLogger("behaveasl.jsonata_eval")


def replace_jsonata(input: str, sr: StepResult, context: dict) -> str:
    """Replace JSONata expressions in the input string with their evaluated values"""

    if input.startswith("{%") and input.endswith("%}"):

        data = {"states": {"input": sr.state_input, "context": context}}

        expr = input[2:-2]
        new_value = jsonata.Jsonata(expr).evaluate(data)

        LOG.debug(f"Replacing '{expr}' with '{new_value}', context='{data}'")
        return new_value

    return input
