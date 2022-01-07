from behaveasl import jsonpath


def replace_expression(*, expr: str, input, context: dict):
    if expr.startswith("$$"):
        context_expr = expr[1:]
        jpexpr = jsonpath.get_instance(context_expr)
        results = jpexpr.find(context)
        if len(results) == 1:
            new_value = results[0].value
            print(
                f"Replacing '{expr}' [from Context] with '{new_value}', context='{context}'"
            )
            return new_value
    elif expr.startswith("$"):
        jpexpr = jsonpath.get_instance(expr)
        results = jpexpr.find(input)
        if len(results) == 1:
            new_value = results[0].value
            print(f"Replacing '{expr}' [from Input] with '{new_value}'")
            return new_value
    raise Exception(f"Failed to process: expr={expr}, context={context}")
