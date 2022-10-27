import json
import uuid

from behaveasl.models.exceptions import StatesRuntimeException


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


def states_array_contains(args):
    """Implementation of States.ArrayContains

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): Two items, an array and a value to search for

    Returns:
        bool: true if the item is in the array
    """

    haystack = args.pop(0)
    needle = args.pop(0)

    return needle in haystack


def states_array_get_item(args):
    """Implementation of States.ArrayGetItem

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): Two items, an array and an index to get from

    Returns:
        any: the value at the given index
    """

    input = args.pop(0)
    index = args.pop(0)

    return input[index]


def states_array_range(args):
    """Implementation of States.ArrayRanges

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): Three items, the start, end and step

    Returns:
        list: list of generated values
    """

    # Input validation (from AWS docs)
    # You must specify integer values for all of the arguments.
    # If you specify a non-integer value for any of the arguments, Step Functions will round it off to the nearest integer.
    # You must specify a non-zero value for the third argument.
    # The newly generated array can't contain more than 1000 items.

    start = int(args.pop(0))
    stop = int(args.pop(0))
    step = int(args.pop(0))

    i = start
    resp = [start]
    while i < stop:
        i = i + step
        if i < stop:
            resp.append(i)
        else:
            resp.append(stop)

    if stop not in resp:
        resp.append(stop)

    if len(resp) > 1000:
        raise StatesRuntimeException(
            f"States.ArrayRange response cannot contain more than 1000 items"
        )

    return resp


def states_array_length(args):
    """Implementation of States.ArrayLength

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): A single item, that is a list

    Returns:
        int: length of the list
    """

    return len(args[0])


def states_array_unique(args):
    """Implementation of States.ArrayUnique

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): A single item, that is a list

    Returns:
        list: a new list with only unique items in it
    """

    items = args.pop(0)
    resp = []

    for item in items:
        found = False

        # In Python, 1==1.0 returns True
        # therefore, we don't use 'item in resp'
        for x in resp:
            if x == item and type(x) == type(item):
                found = True
        if not found:
            resp.append(item)

    return resp


STATES_INTRINSICS = {
    "States.Format": states_format,
    "States.StringToJson": states_string_to_json,
    "States.JsonToString": states_json_to_string,
    "States.Array": states_array,
    "States.ArrayContains": states_array_contains,
    "States.ArrayGetItem": states_array_get_item,
    "States.ArrayLength": states_array_length,
    "States.ArrayPartition": states_array_parition,
    "States.ArrayRange": states_array_range,
    "States.ArrayUnique": states_array_unique,
    "States.UUID": states_uuid,
}
