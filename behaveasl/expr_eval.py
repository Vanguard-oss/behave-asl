import ast
import logging
import traceback

from behaveasl import intrinsics, jsonpath
from behaveasl.models.exceptions import StatesRuntimeException


LOG = logging.getLogger("behaveasl.expression_evaluation")


def _tokenize_expression(expr: str):
    """Parse an expression and return an array of token strings

    Args:
        expr (str): The expression to tokenize

    Returns:
        list: The list of tokens
    """

    args_str = expr
    args = []
    # Tokenize the intrinsic expression
    while len(args_str) > 0:
        if args_str[0] == "$":
            # AWS doesn't seem to support JsonPaths with a comma
            # If this is a JsonPath, then we can assume that it ends at the next comma or the end of the string
            if "," in args_str:
                # This JsonPath goes to the next comma
                new_parts = args_str.split(",", 1)
                next_token = new_parts[0]
                args_str = new_parts[1]
                args.append(next_token)
                LOG.debug(f"Found next JsonPath token: [{next_token}]")
            else:
                # This JsonPath goes to the end of the expression
                args.append(args_str)
                args_str = ""
                LOG.debug(f"Found final JsonPath token: [{args_str}]")
        elif args_str[0] == " ":
            # Skip any spaces that are not part of the string literal
            args_str = args_str[1:]
        elif args_str[0] == ",":
            # If we get here, then we are between arguments
            # We can skip the comma so we can get to the start of the next argument
            args_str = args_str[1:]
        elif args_str.startswith("false,") or args_str == "false":
            args.append(args_str)
            args_str = args_str[len("false") :]
        elif args_str.startswith("true,") or args_str == "true":
            args.append(args_str)
            args_str = args_str[len("true") :]
        elif args_str[0].isdigit() or args_str[0] == "-":
            next_token = ""
            # while len(args_str)>0 and args_str[0].isnumeric():
            while len(args_str) > 0 and (
                args_str[0].isdecimal() or args_str[0] == "." or args_str[0] == "-"
            ):
                next_token = next_token + args_str[0]
                args_str = args_str[1:]
            args.append(next_token)
            LOG.debug(
                f"Found next number literal token: [{next_token}], remainder=[{args_str}]"
            )
        elif args_str[0] == "'":
            # we have to find the next comma that is not inside of a string literal
            next_token = ""
            tmp = args_str[1:]
            while len(tmp) > 0:
                # AWS uses \\' as the single quote literal
                if tmp.startswith("\\'"):
                    next_token = next_token + tmp[0:2]
                    tmp = tmp[2:]
                elif tmp[0] == "'":
                    # This is the end quote for this particular literal
                    args_str = tmp[1:]
                    LOG.debug(
                        f"Found next string literal token: [{next_token}], remainder=[{args_str}]"
                    )
                    args.append(f"'{next_token}'")
                    tmp = ""
                else:
                    # Save the character
                    next_token = next_token + tmp[0]
                    tmp = tmp[1:]
        else:
            raise StatesRuntimeException(
                f"Invalid path {expr}: Unparsable section: [{args_str}]"
            )
    return args


def _replace_jsonpath_expressions(*, args, input, context):
    """Replace any JsonPath expressions from any of the arguments

    Args:
        args (list): List of arguments

    Returns:
        list: List of transformed arguments
    """
    new_args = []
    for arg in args:
        if arg.startswith("$"):
            # Is it a JsonPath expression
            # If it is, just use the existing function to replace it
            new_args.append(replace_expression(expr=arg, input=input, context=context))
        elif arg.startswith("'") and arg.endswith("'"):
            # If it is surounded by quotes, try to replace backslashes the way AWS does
            arg = arg.replace("\n", "\\n")
            new_args.append(ast.literal_eval(arg).replace("'", "\\'"))
        elif (arg[0].isdigit() or arg[0] == "-") and "." in arg:
            new_args.append(float(arg))
        elif arg[0].isdigit() or arg[0] == "-":
            new_args.append(int(arg))
        elif arg == "true":
            new_args.append(True)
        elif arg == "false":
            new_args.append(False)
        else:
            raise StatesRuntimeException(f"Unparsable argument: {arg}")
    return new_args


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
    elif expr.startswith("States.") and expr.endswith(")"):
        parts = expr[0:-1].split("(")
        func_name = parts[0]
        args_str = parts[1]

        args = _tokenize_expression(args_str)
        args = _replace_jsonpath_expressions(args=args, input=input, context=context)

        if func_name in intrinsics.STATES_INTRINSICS:
            func = intrinsics.STATES_INTRINSICS[func_name]
            try:
                new_value = func(args)
            except Exception as e:
                traceback.print_exc()
                raise StatesRuntimeException(f"Failed expression {expr}: " + str(e))
            LOG.info(f"Replacing '{expr}' with '{new_value}'")
            return new_value
    raise StatesRuntimeException(f"Invalid expression {expr}: Nonsense")
