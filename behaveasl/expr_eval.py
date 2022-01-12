import logging

from behaveasl import jsonpath
from behaveasl.models.exceptions import StatesRuntimeException


LOG = logging.getLogger("behaveasl.expression_evaluation")


def replace_expression(*, expr: str, input, context: dict):
    if expr.startswith("$$"):
        context_expr = expr[1:]
        jpexpr = jsonpath.get_instance(context_expr)
        results = jpexpr.find(context)
        if len(results) == 1:
            new_value = results[0].value
            LOG.debug(
                f"Replacing '{expr}' [from Context] with '{new_value}', context='{context}'"
            )
            return new_value
        raise StatesRuntimeException(f"Invalid path {expr}: No results")
    elif expr.startswith("$"):
        jpexpr = jsonpath.get_instance(expr)
        results = jpexpr.find(input)
        if len(results) == 1:
            new_value = results[0].value
            LOG.debug(f"Replacing '{expr}' [from Input] with '{new_value}'")
            return new_value
        raise StatesRuntimeException(f"Invalid path {expr}: No results")
    raise StatesRuntimeException(f"Invalid expression {expr}: Nonsense")
