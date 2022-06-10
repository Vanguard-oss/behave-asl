import re
from datetime import datetime

from behaveasl.models.exceptions import StatesRuntimeException
from behaveasl.models.state_phases import Path


class Choice:
    """Base class for a Choice type"""

    def evaluate(self, state_input, phase_input, sr, execution) -> bool:
        return False


class AndChoice(Choice):
    """Choice that returns True if all the child choices return True"""

    def __init__(self, choices: list):
        """Constructor

        Args:
            choices (list): List of Choice objects
        """
        self._choices = map(lambda x: create_choice(x), choices)

    def evaluate(self, state_input, phase_input, sr, execution) -> bool:
        for choice in self._choices:
            # Call evaluate on the choice instance, which will return True or False
            if (
                choice.evaluate(
                    state_input=state_input,
                    phase_input=phase_input,
                    sr=sr,
                    execution=execution,
                )
                == False
            ):
                return False
        return True


class OrChoice(Choice):
    """Choice that returns True if any of the child choices return True"""

    def __init__(self, choices: list):
        """Constructor

        Args:
            choices (list): List of Choice objects
        """
        self._choices = map(lambda x: create_choice(x), choices)

    def evaluate(self, state_input, phase_input, sr, execution) -> bool:
        for choice in self._choices:
            # Call evaluate on the choice instance, which will return True or False
            if (
                choice.evaluate(
                    state_input=state_input,
                    phase_input=phase_input,
                    sr=sr,
                    execution=execution,
                )
                == True
            ):
                return True
        return False


class NotChoice(Choice):
    """Choice that returns the opposite of what the single child Choice returned"""

    def __init__(self, child: Choice):
        """Constructor

        Args:
            child (Choice): The child choice
        """
        self._child = child

    def evaluate(self, state_input, phase_input, sr, execution) -> bool:
        return not self._child.evaluate(
            state_input=state_input,
            phase_input=phase_input,
            sr=sr,
            execution=execution,
        )


class SingleOperationChoice(Choice):
    """Choice that runs a single operation"""

    def __init__(self, variable: str, evaluation_type: str, evaluation_value):
        """Constructor

        Args:
            variable (str): The variable path to evaluate against
            evaluation_type (str): The type of operation to execute
            evaluation_value: The value we are checking against
        """

        self._variable = variable
        self._evaluation_type = evaluation_type
        self._evaluation_value = evaluation_value

    def evaluate(self, state_input, phase_input, sr, execution) -> bool:
        # Shortcut evaluation for 'IsPresent' here
        if self._evaluation_type == "IsPresent":
            return self._is_present(
                state_input=state_input,
                phase_input=phase_input,
            )
        variable_path = Path(result_path=self._variable)
        if self._evaluation_type[-4:] == "Path":
            evaluation_path = Path(result_path=self._evaluation_value)
            actual_value = evaluation_path.execute(
                state_input=state_input,
                phase_input=phase_input,
                sr=sr,
                execution=execution,
            )
            self._evaluation_value = variable_path.execute(
                state_input=state_input,
                phase_input=phase_input,
                sr=sr,
                execution=execution,
            )
        else:
            actual_value = variable_path.execute(
                state_input=state_input,
                phase_input=phase_input,
                sr=sr,
                execution=execution,
            )
        # TODO: If self._actual_value is None, raise a StatesRuntimeException (no value could be located)
        # if actual_value is None:
        #     raise StatesRuntimeException("No value could be located.")
        function_map = {
            "BooleanEquals": self._boolean_equals,
            "BooleanEqualsPath": self._boolean_equals,
            "IsBoolean": self._is_boolean,
            "IsNull": self._is_null,
            "IsNumeric": self._is_numeric,
            "IsString": self._is_string,
            "IsTimestamp": self._is_timestamp,
            "NumericEquals": self._numeric_equals,
            "NumericEqualsPath": self._numeric_equals,
            "NumericGreaterThan": self._numeric_greater_than,
            "NumericGreaterThanPath": self._numeric_greater_than,
            "NumericGreaterThanEquals": self._numeric_greater_than_equals,
            "NumericGreaterThanEqualsPath": self._numeric_greater_than_equals,
            "NumericLessThan": self._numeric_less_than,
            "NumericLessThanPath": self._numeric_less_than,
            "NumericLessThanEquals": self._numeric_less_than_equals,
            "NumericLessThanEqualsPath": self._numeric_less_than_equals,
            "StringEquals": self._string_equals,
            "StringEqualsPath": self._string_equals,
            "StringGreaterThan": self._string_greater_than,
            "StringGreaterThanPath": self._string_greater_than,
            "StringGreaterThanEquals": self._string_greater_than_equals,
            "StringGreaterThanEqualsPath": self._string_greater_than_equals,
            "StringLessThan": self._string_less_than,
            "StringLessThanPath": self._string_less_than,
            "StringLessThanEquals": self._string_less_than_equals,
            "StringLessThanEqualsPath": self._string_less_than_equals,
            "StringMatches": self._string_matches,
            "TimestampEquals": self._timestamp_equals,
            "TimestampEqualsPath": self._timestamp_equals,
            "TimestampGreaterThan": self._timestamp_greater_than,
            "TimestampGreaterThanPath": self._timestamp_greater_than,
            "TimestampGreaterThanEquals": self._timestamp_greater_than_equals,
            "TimestampGreaterThanEqualsPath": self._timestamp_greater_than_equals,
            "TimestampLessThan": self._timestamp_less_than,
            "TimestampLessThanPath": self._timestamp_less_than,
            "TimestampLessThanEquals": self._timestamp_less_than_equals,
            "TimestampLessThanEqualsPath": self._timestamp_less_than_equals,
        }
        return function_map[self._evaluation_type](actual_value=actual_value)

    def _boolean_equals(self, actual_value):
        if type(actual_value) != bool:
            return False
        else:
            return actual_value == self._evaluation_value

    def _is_boolean(self, actual_value):
        # self._evaluation_value determines if we want a bool or not
        if self._evaluation_value is True and type(actual_value) != bool:
            return False
        elif self._evaluation_value is False and type(actual_value) == bool:
            return False
        else:
            return True

    def _is_null(self, actual_value):
        # self._evaluation_value determines whether we want the type or not
        if self._evaluation_value is True and actual_value is not None:
            return False
        elif self._evaluation_value is False and actual_value is None:
            return False
        else:
            return True

    def _check_type_is_numeric(self, value_to_check):
        """This helper function allows us to delegate this common check to a single spot"""
        if type(value_to_check) not in [float, int]:
            return False
        else:
            return True

    def _check_type_is_string(self, value_to_check):
        if type(value_to_check) is not str:
            return False
        else:
            return True

    def _convert_to_dt(self, value):
        ts_format_wo_ms = "%Y-%m-%dT%H:%M:%S%z"
        ts_format_with_ms = "%Y-%m-%dT%H:%M:%S.%f%z"
        try:
            ts = datetime.strptime(value, ts_format_wo_ms)
            return ts
        except ValueError:
            try:
                ts = datetime.strptime(value, ts_format_with_ms)
                return ts
            except ValueError:
                return None

    def _check_type_is_timestamp(self, value):
        # Timestamps must conform to RFC3339 ISO 8601, include an uppercase "T" to separate date and time,
        # and have an uppercase "Z" to denote that a numeric time zone isn't present
        # Example: 2001-01-01T12:00:00Z
        ts_format_wo_ms = "%Y-%m-%dT%H:%M:%S%z"
        ts_format_with_ms = "%Y-%m-%dT%H:%M:%S.%f%z"
        try:
            ts = datetime.strptime(value, ts_format_wo_ms)
        except ValueError:
            try:
                ts = datetime.strptime(value, ts_format_with_ms)
            except ValueError:
                return False
        return True

    def _is_numeric(self, actual_value):
        # self._evaluation_value determines whether we want the type or not
        if (
            self._evaluation_value is True
            and self._check_type_is_numeric(actual_value) == False
        ):
            return False
        elif (
            self._evaluation_value is False
            and self._check_type_is_numeric(actual_value) == True
        ):
            return False
        else:
            return True

    def _is_present(self, state_input, phase_input):
        # TODO: this is a hard one to implement, because if you input JSON Path it
        # upsets some of the existing logic, hmm
        # self._evaluation_value determines whether we want the type or not
        evaluation_path = Path(result_path=self._variable)
        is_present = evaluation_path.is_present(
            state_input=state_input,
            phase_input=phase_input,
        )
        if self._evaluation_value is True and is_present == False:
            return False
        elif self._evaluation_value is False and is_present == True:
            return False
        return True

    def _is_string(self, actual_value):
        # self._evaluation_value determines  whether we want the type or not
        if (
            self._evaluation_value is True
            and self._check_type_is_string(actual_value) == False
        ):
            return False
        elif (
            self._evaluation_value is False
            and self._check_type_is_string(actual_value) == True
        ):
            return False
        return True

    def _is_timestamp(self, actual_value):
        if (
            self._evaluation_value is True
            and self._check_type_is_timestamp(actual_value) == False
        ):
            return False
        elif (
            self._evaluation_value is False
            and self._check_type_is_timestamp(actual_value) == True
        ):
            return False
        return True

    def _numeric_equals(self, actual_value):
        # If either value is not a numeric type, return False
        if (
            self._check_type_is_numeric(value_to_check=actual_value) == False
            or self._check_type_is_numeric(value_to_check=self._evaluation_value)
            == False
        ):  # delegate to the existing function
            return False
        return self._evaluation_value == actual_value

    def _numeric_greater_than(self, actual_value):
        if (
            self._check_type_is_numeric(value_to_check=actual_value) == False
            or self._check_type_is_numeric(value_to_check=self._evaluation_value)
            == False
        ):  # delegate to the existing function
            return False
        return self._evaluation_value > actual_value

    def _numeric_greater_than_equals(self, actual_value):
        if (
            self._check_type_is_numeric(value_to_check=actual_value) == False
            or self._check_type_is_numeric(value_to_check=self._evaluation_value)
            == False
        ):  # delegate to the existing function
            return False
        return self._evaluation_value >= actual_value

    def _numeric_less_than(self, actual_value):
        if (
            self._check_type_is_numeric(value_to_check=actual_value) == False
            or self._check_type_is_numeric(value_to_check=self._evaluation_value)
            == False
        ):  # delegate to the existing function
            return False
        return self._evaluation_value < actual_value

    def _numeric_less_than_equals(self, actual_value):
        if (
            self._check_type_is_numeric(value_to_check=actual_value) == False
            or self._check_type_is_numeric(value_to_check=self._evaluation_value)
            == False
        ):  # delegate to the existing function
            return False
        return self._evaluation_value <= actual_value

    def _string_equals(self, actual_value):
        if (
            self._check_type_is_string(value_to_check=actual_value) == False
            or self._check_type_is_string(value_to_check=self._evaluation_value)
            == False
        ):
            return False
        return actual_value == self._evaluation_value

    def _compare_strings(self, compare_string, another_string) -> int:
        """
        If positive, string follows another string. If negative, string precedes another_string.
        Will compare 2 strings using the same logic as Java's compareTo method
        https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#compareTo-java.lang.String
        """
        # Determine which string is longer - we will iterate over the shorter string
        # If they are the same up to that point, the longer string is greater
        if compare_string == another_string:
            return 0
        # If the left hand part of the string is the same, the longer string comes
        # after the shorter
        min_length = (
            len(compare_string)
            if len(compare_string) < len(another_string)
            else len(another_string)
        )
        if compare_string[:min_length] == another_string[:min_length]:
            if len(compare_string) > len(another_string):
                return 1
            else:
                return -1

        for x in range(0, min_length):
            string_ord = ord(compare_string[x])
            another_string_ord = ord(another_string[x])
            if string_ord == another_string_ord:
                pass
            else:
                # If string follows another_string, result will be positive
                # If string precedes another_string, result will be negative
                return string_ord - another_string_ord

    def _string_greater_than(self, actual_value):
        if (
            self._check_type_is_string(value_to_check=actual_value) == False
            or self._check_type_is_string(value_to_check=self._evaluation_value)
            == False
        ):
            return False
        # If positive, actual_value is after (greater than) self._evaluation_value.
        # If negative, actual_value follows (is lesser than) self._evaluation_value
        if (
            self._compare_strings(
                compare_string=self._evaluation_value, another_string=actual_value
            )
            > 0
        ):
            return True
        else:
            return False

    def _string_greater_than_equals(self, actual_value):
        if (
            self._check_type_is_string(value_to_check=actual_value) == False
            or self._check_type_is_string(value_to_check=self._evaluation_value)
            == False
        ):
            return False
        # If positive, actual_value is after (greater than) self._evaluation_value.
        # If negative, actual_value follows (is lesser than) self._evaluation_value
        if (
            self._compare_strings(
                compare_string=self._evaluation_value, another_string=actual_value
            )
            >= 0
        ):
            return True
        else:
            return False

    def _string_less_than(self, actual_value):
        if (
            self._check_type_is_string(value_to_check=actual_value) == False
            or self._check_type_is_string(value_to_check=self._evaluation_value)
            == False
        ):
            return False
        # If positive, actual_value is after (greater than) self._evaluation_value.
        # If negative, actual_value follows (is lesser than) self._evaluation_value
        if (
            self._compare_strings(
                compare_string=self._evaluation_value, another_string=actual_value
            )
            < 0
        ):
            return True
        else:
            return False

    def _string_less_than_equals(self, actual_value):
        if (
            self._check_type_is_string(value_to_check=actual_value) == False
            or self._check_type_is_string(value_to_check=self._evaluation_value)
            == False
        ):
            return False
        # If positive, actual_value is after (greater than) self._evaluation_value.
        # If negative, actual_value follows (is lesser than) self._evaluation_value
        if (
            self._compare_strings(
                compare_string=self._evaluation_value, another_string=actual_value
            )
            <= 0
        ):
            return True
        else:
            return False

    def _string_matches(self, actual_value):
        # String comparison against patterns with one or more wildcards (“*”) can be performed with the StringMatches comparison operator. The wildcard character is escaped by using the standard \\ (Ex: “\\*”). No characters other than “*” have any special meaning during matching.
        if (
            self._check_type_is_string(value_to_check=actual_value) == False
            or self._check_type_is_string(value_to_check=self._evaluation_value)
            == False
        ):
            return False
        # Non-wildcard matching
        if "*" not in self._evaluation_value:
            return self._evaluation_value == actual_value
        # Wildcard matching
        else:
            # Replace any periods in self._evaluation_value with \. in the string (period literals)
            regex_string = self._evaluation_value.replace(".", r"\.")
            # Replace any * with . in the string
            regex_string = regex_string.replace("*", ".*")
            # Turn it into a regex pattern
            prog = re.compile(regex_string)
            # Look for a match
            match = prog.match(actual_value)
            if match is None:
                return False
            return True

    def _timestamp_equals(self, actual_value):
        if (
            self._check_type_is_timestamp(value=actual_value) == False
            or self._check_type_is_timestamp(value=self._evaluation_value) == False
        ):
            return False
        # Convert to dt
        evaluation_value_dt = self._convert_to_dt(value=self._evaluation_value)
        actual_value_dt = self._convert_to_dt(value=actual_value)
        return evaluation_value_dt == actual_value_dt

    def _timestamp_greater_than(self, actual_value):
        if (
            self._check_type_is_timestamp(value=actual_value) == False
            or self._check_type_is_timestamp(value=self._evaluation_value) == False
        ):
            return False
        # Convert to dt
        evaluation_value_dt = self._convert_to_dt(value=self._evaluation_value)
        actual_value_dt = self._convert_to_dt(value=actual_value)
        return evaluation_value_dt > actual_value_dt

    def _timestamp_greater_than_equals(self, actual_value):
        if (
            self._check_type_is_timestamp(value=actual_value) == False
            or self._check_type_is_timestamp(value=self._evaluation_value) == False
        ):
            return False
        # Convert to dt
        evaluation_value_dt = self._convert_to_dt(value=self._evaluation_value)
        actual_value_dt = self._convert_to_dt(value=actual_value)
        return evaluation_value_dt >= actual_value_dt

    def _timestamp_less_than(self, actual_value):
        if (
            self._check_type_is_timestamp(value=actual_value) == False
            or self._check_type_is_timestamp(value=self._evaluation_value) == False
        ):
            return False
        # Convert to dt
        evaluation_value_dt = self._convert_to_dt(value=self._evaluation_value)
        actual_value_dt = self._convert_to_dt(value=actual_value)
        return evaluation_value_dt < actual_value_dt

    def _timestamp_less_than_equals(self, actual_value):
        if (
            self._check_type_is_timestamp(value=actual_value) == False
            or self._check_type_is_timestamp(value=self._evaluation_value) == False
        ):
            return False
        # Convert to dt
        evaluation_value_dt = self._convert_to_dt(value=self._evaluation_value)
        actual_value_dt = self._convert_to_dt(value=actual_value)
        return evaluation_value_dt <= actual_value_dt


def create_choice(fields: dict) -> Choice:
    """Create a choice object based on on the fields that are passed in

    Args:
        fields (dict): dictionary decribing the choice object to create

    Returns:
        The Choice object
    """
    if "Variable" in fields:
        # To get the evaluation type, we need to find the key that isn't 'Variable' or 'Next'
        # the remaining key should be the evaluation type and value
        evaluation_type = list(
            filter(lambda x: x not in ["Variable", "Next"], fields.keys())
        )[0]

        return SingleOperationChoice(
            variable=fields["Variable"],
            evaluation_type=evaluation_type,
            evaluation_value=fields[evaluation_type],
        )
    elif "And" in fields:
        return AndChoice(choices=fields["And"])
    elif "Or" in fields:
        return OrChoice(choices=fields["Or"])
    elif "Not" in fields:
        return NotChoice(child=create_choice(fields["Not"]))

    raise StatesRuntimeException(f"Invalid choice configuration: {fields}")
