import json
import uuid


def states_format(args):
    """Implementation of States.Format

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html

    Args:
        args (list): List of arguments for the intrinsic function

    Returns:
        str: The formatted string
    """
    fmt = args.pop(0)
    return fmt.format(*args)


def states_string_to_json(args):
    """Implementation of States.StringToJson

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html

    Args:
        args (list): List of arguments for the intrinsic function

    Returns:
        str: Json object
    """
    input = args.pop(0)
    return json.loads(input)


def states_json_to_string(args):
    """Implementation of States.StringToJson

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html

    Args:
        args (list): List of arguments for the intrinsic function

    Returns:
        str: json string
    """
    input = args.pop(0)

    # AWS does not put a space after the separator, so we have to tell Python
    # to do the same
    separators = (",", ":")

    return json.dumps(input, separators=separators)


def states_array(args):
    """Implementation of States.Array

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html

    Args:
        args (list): List of arguments for the intrinsic function

    Returns:
        list: array of values
    """
    return args


def states_uuid(args):
    """Implementation of States.UUID

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-uuid-generate

    Args:
        args (list): empty list

    Returns:
        str: The hex value of the UUID
    """
    return str(uuid.uuid4())


def states_array_parition(args):
    """Implementation of States.ArrayPartition

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): Two items, an array and a count

    Returns:
        list: list of lists partitioned based on the passed in amount
    """

    resp = []
    input = args.pop(0)
    max = args.pop(0)
    while len(input) > 0:
        resp.append(input[0:max])
        input = input[max:]
    return resp


STATES_INTRINSICS = {
    "States.Format": states_format,
    "States.StringToJson": states_string_to_json,
    "States.JsonToString": states_json_to_string,
    "States.Array": states_array,
    "States.ArrayPartition": states_array_parition,
    "States.UUID": states_uuid,
}
