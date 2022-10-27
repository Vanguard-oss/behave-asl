import base64
import hashlib
import json
import random
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


def states_array_partition(args):
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

    if type(input) != list:
        raise StatesRuntimeException(
            f"States.ArrayPartition can only accept a list as the first input"
        )
    if type(max) != int:
        raise StatesRuntimeException(
            f"States.ArrayPartition can only accept an int as the second input"
        )

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

    if type(haystack) != list:
        raise StatesRuntimeException(
            f"States.ArrayContains can only accept a list as the first input"
        )

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

    if type(input) != list:
        raise StatesRuntimeException(
            f"States.ArrayGetItem can only accept a list as the first input"
        )
    if type(index) != int:
        raise StatesRuntimeException(
            f"States.ArrayGetItem can only accept an int as the second input"
        )

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

    input = args.pop(0)

    if type(input) != list:
        raise StatesRuntimeException(f"States.ArrayUnique can only accept list inputs")

    return len(input)


def states_array_unique(args):
    """Implementation of States.ArrayUnique

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-arrays

    Args:
        args (list): A single item, that is a list

    Returns:
        list: a new list with only unique items in it
    """

    items = args.pop(0)

    if type(items) != list:
        raise StatesRuntimeException(f"States.ArrayUnique can only accept list inputs")

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


def states_base64_encode(args):
    """Implementation of States.Base64Encode

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-data-encode-decode

    Args:
        args (list): A single item, that is a string

    Returns:
        str: a string with the encoded contents
    """
    input = args.pop(0)

    if type(input) != str:
        raise StatesRuntimeException(
            f"States.Base64Encode can only accept string inputs"
        )

    if len(input) > 10000:
        raise StatesRuntimeException(
            f"States.Base64Encode can only accept 10,000 characters"
        )

    return base64.b64encode(input.encode("UTF-8")).decode("UTF-8")


def states_base64_decode(args):
    """Implementation of States.Base64Decode

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-data-encode-decode

    Args:
        args (list): A single item, that is a base64 encoded string

    Returns:
        str: a string with the decoded contents
    """

    input = args.pop(0)

    if type(input) != str:
        raise StatesRuntimeException(
            f"States.Base64Decode can only accept string inputs"
        )

    if len(input) > 10000:
        raise StatesRuntimeException(
            f"States.Base64Decode can only accept 10,000 characters"
        )

    return base64.b64decode(input.encode("UTF-8")).decode("UTF-8")


def states_hash(args):
    """Implementation of States.Hash

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-hash-calc

    Args:
        args (list): The value to hash and the algorithm to hash with

    Returns:
        str: a string with hex hashed contents
    """

    input = args.pop(0)
    algo = args.pop(0)

    if type(input) != str:
        raise StatesRuntimeException(
            f"States.Hash can only accept a string as the first input"
        )

    algos = {
        "MD5": hashlib.md5,
        "SHA-1": hashlib.sha1,
        "SHA-256": hashlib.sha256,
        "SHA-384": hashlib.sha384,
        "SHA-512": hashlib.sha512,
    }

    m = algos[algo]()
    m.update(input.encode("UTF-8"))
    return m.hexdigest()


def states_json_merge(args):
    """Implementation of States.JsonMerge

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-hash-calc

    Args:
        args (list): Two objects to merge and a boolean of if the merge should be deep or not

    Returns:
        str: a string with hex hashed contents
    """
    input1 = args.pop(0)
    input2 = args.pop(0)
    deep = args.pop(0)

    if deep:
        raise StatesRuntimeException(f"States.JsonMerge deep mode is not supported yet")
    else:
        resp = {}
        resp.update(input1)
        resp.update(input2)
        return resp


def states_math_add(args):
    """Implementation of States.MathAdd

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-math-operation

    Args:
        args (list): Two numbers to add

    Returns:
        int|float: the sum of the two numbers
    """

    input1 = args.pop(0)
    input2 = args.pop(0)

    return input1 + input2


def states_math_random(args):
    """Implementation of States.MathRandom

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-math-operation

    Args:
        args (list): The min and max values

    Returns:
        int: random int between the inputs
    """

    # Input validation
    # You must specify integer values for the start number and end number arguments.
    # If you specify a non-integer value for the start number or end number argument, Step Functions will round it off to the nearest integer.

    input1 = int(args.pop(0))
    input2 = int(args.pop(0))

    return random.randint(input1, input2)


def states_string_split(args):
    """Implementation of States.StringSplit

    https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-intrinsic-functions.html#asl-intrsc-func-string-operation

    Args:
        args (list): The string to split and the delimiter

    Returns:
        list: list of values
    """

    input = args.pop(0)
    splitter = args.pop(0)

    return input.split(splitter)


STATES_INTRINSICS = {
    "States.Format": states_format,
    "States.StringToJson": states_string_to_json,
    "States.JsonToString": states_json_to_string,
    "States.Array": states_array,
    "States.ArrayContains": states_array_contains,
    "States.ArrayGetItem": states_array_get_item,
    "States.ArrayLength": states_array_length,
    "States.ArrayPartition": states_array_partition,
    "States.ArrayRange": states_array_range,
    "States.ArrayUnique": states_array_unique,
    "States.Base64Decode": states_base64_decode,
    "States.Base64Encode": states_base64_encode,
    "States.Hash": states_hash,
    "States.JsonMerge": states_json_merge,
    "States.MathAdd": states_math_add,
    "States.MathRandom": states_math_random,
    "States.StringSplit": states_string_split,
    "States.UUID": states_uuid,
}
