import re
from datetime import datetime

from behaveasl.models.state_phases import Path
from behaveasl.models.exceptions import StatesRuntimeException


class Choice:
    def __init__(self, variable, evaluation_type, evaluation_value, next_state):
        self._variable = variable
        self._evaluation_type = evaluation_type
        self._evaluation_value = evaluation_value
        self._next_state = next_state
        self._choices = (
            None  # If this is set, we are using an "And"/"Or"/"Not" comparator
        )

    def evaluate(self, state_input, sr, execution):
        variable_path = Path(result_path=self._variable)
        # TODO: before calling the method, if the comparator ends in "Path", use the self._evaluation_value
        # as the Path to evalute against the state_input
        if self._evaluation_type[-4:] == "Path":
            evaluation_path = Path(result_path=self._evaluation_value)
            actual_value = evaluation_path.execute(
                state_input=state_input,
                phase_input=state_input,
                sr=sr,
                execution=execution,
            )
            self._evaluation_value = variable_path.execute(
                state_input=state_input,
                phase_input=state_input,
                sr=sr,
                execution=execution,
            )
        else:
            actual_value = variable_path.execute(
                state_input=state_input,
                phase_input=state_input,
                sr=sr,
                execution=execution,
            )
        # TODO: If self._actual_value is None, raise a StatesRuntimeException (no value could be located)
        # if actual_value is None:
        #     raise StatesRuntimeException("No value could be located.")
        # TODO: depending on the value of the Choice's comparator, call the right method - compare actual_value with evaluation_value
        function_map = {
            "BooleanEquals": self._boolean_equals,
            "BooleanEqualsPath": self._boolean_equals,
            "IsBoolean": self._is_boolean,
            "IsNull": self._is_null,
            "IsNumeric": self._is_numeric,
            "IsPresent": self._is_present,
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

    # Roughly follow the order of comparators here: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html
    def _and_comparator(self, actual_value):  # And is a reserved word in Python
        pass

    def _not_comparator(self, actual_value):  # Not is a reserved word in Python
        # self._evaluation_type will determine what function to call
        # return logical not
        pass

    def _or_comparator(self, actual_value):
        pass

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

    def _is_present(self, actual_value):
        # TODO: this is a hard one to implement, because if you input JSON Path it
        # upsets some of the existing logic, hmm
        # self._evaluation_value determines whether we want the type or not
        pass

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
