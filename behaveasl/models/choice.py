class Choice:
    def __init__(self, variable, evaluation_type, evaluation_value, next_state):
        self._variable = variable
        self._evaluation_type = evaluation_type
        self._evaluation_value = evaluation_value
        self._next_state = next_state
        self._choices = None # If this is set, we are using an "And"/"Or"/"Not" comparator
    

    def evaluate(self, state_input: dict):
        # TODO: before calling the method, if the comparator ends in "Path", do the replacement
        # need to use jsonpath-ng to extract choice.variable from self._state_input
        actual_value = self.parse_variable_value_from_input(state_input=state_input)
        # TODO: If self._actual_value is None, raise a StatesRuntimeException (no value could be located)
        # TODO: depending on the value of the Choice's comparator, call the right method - compare actual_value with evaluation_value
        function_map = {
            'BooleanEquals': self._boolean_equals,
            'BooleanEqualsPath': self._boolean_equals,
            'IsBoolean': self._is_boolean,
            'IsNull': self._is_null,
            'IsPresent': self._is_present,
            'IsString': self._is_string,
            'IsTimestamp': self._is_timestamp,
            'NumericEquals': self._numeric_equals,
            'NumericEqualsPath': self._numeric_equals,
            'NumericGreaterThan': self._numeric_greater_than,
            'NumericGreaterThanPath': self._numeric_greater_than,
            'NumericLessThan': self._numeric_less_than,
            'NumericLessthanPath': self._numeric_less_than,
            'StringEquals': self._string_equals,
            'StringEqualsPath': self._string_equals,
            'StringGreaterThan': self._string_greater_than,
            'StringGreaterThanPath': self._string_greater_than,
            'StringLessThan': self._string_less_than,
            'StringLessThanPath': self._string_less_than,
            'StringMatches': self._string_matches,
            'TimestampEquals': self._timestamp_equals,
            'TimestampEqualsPath': self._timestamp_equals,
            'TimestampGreaterThan': self._timestamp_greater_than,
            'TimestampGreaterThanPath': self._timestamp_greater_than,
            'TimestampGreaterThanEquals': self._timestamp_greater_than_equals,
            'TimestampGreaterThanEqualsPath': self._timestamp_greater_than_equals,
            'TimestampLessThan': self._timestamp_less_than,
            'TimestampLessThanPath': self._timestamp_less_than,
            'TimestampLessThanEquals': self._timestamp_less_than_equals,
            'TimestampLessThanEqualsPath': self._timestamp_greater_than_equals,
        }
        return function_map[self._evaluation_type](actual_value=actual_value)

    def parse_variable_value_from_input(self, state_input):
        from behaveasl import jsonpath
        from behaveasl.models.exceptions import StatesRuntimeException
        # TODO: parse other versions of this
        if self._variable.startswith("$"):
            jpexpr = jsonpath.get_instance(self._variable)
            results = jpexpr.find(state_input)
            if len(results) == 1:
                new_value = results[0].value
                print(f"Matched '{self._variable}' [from state_input] with '{new_value}'")
                return new_value
            else:
                return None        

    # Follow the order of comparators here: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html
    def _and_comparator(self, actual_value): # And is a reserved word in Python
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
        # self._evaluation_value determines  whether we want the type or not
        if self._evaluation_value is True and actual_value is not None:
            return False
        elif self._evaluation_value is False and actual_value is None:
            return False
        else:
            return True

    def _is_numeric(self, actual_value):
        # self._evaluation_value determines whether we want the type or not
        if self._evaluation_value is True and type(actual_value) not in [float, int]:
            return False
        elif self._evaluation_value is False and type(actual_value) in [float, int]:
            return False
        else:
            return True

    def _is_present(self, actual_value):
        # TODO: this is a hard one to implement, because if you input JSON Path it
        # upsets some of the existing logic, hmm
        # self._evaluation_value determines  whether we want the type or not
        pass

    def _is_string(self, actual_value):
        # self._evaluation_value determines  whether we want the type or not
        if self._evaluation_value is True and type(actual_value) is not str:
            return False
        elif self._evaluation_value is False and type(actual_value) is str:
            return False
        return True

    def _is_timestamp(self, actual_value):
        # TODO: Timestamps must conform to ISO 8601, include an uppercase "T" to separate date and time, 
        # and have an uppercase "Z" to denote that a numeric time zone isn't present
        # self._evaluation_value determines  whether we want the type or not
        # TODO: we are going to need a really, really fancy regex here, I'm afraid - 
        pass

    def _not_comparator(self, actual_value): # Not is a reserved word in Python
        pass

    def _numeric_equals(self, actual_value):
        pass

    def _numeric_greater_than(self, actual_value):
        pass

    def _numeric_greater_than_equals(self, actual_value):
        pass

    def _numeric_less_than(self, actual_value):
        pass

    def _numeric_less_than_equals(self, actual_value):
        pass

    def _or_comparator(self, actual_value):
        pass

    def _string_equals(self, actual_value):
        # TODO: check type first
        return actual_value == self._evaluation_value

    def _string_greater_than(self, actual_value):
        pass

    def _string_greater_than_equals(self, actual_value):
        pass

    def _string_less_than(self, actual_value):
        pass

    def _string_less_than_equals(self, actual_value):
        pass

    def _string_matches(self, actual_value):
        # TODO: wildcard logic
        # String comparison against patterns with one or more wildcards (“*”) can be performed with the StringMatches comparison operator. The wildcard character is escaped by using the standard \\ (Ex: “\\*”). No characters other than “*” have any special meaning during matching.
        pass

    def _timestamp_equals(self, actual_value):
        pass

    def _timestamp_equals(self, actual_value):
        pass

    def _timestamp_greater_than(self, actual_value):
        pass

    def _timestamp_greater_than_equals(self, actual_value):
        pass

    def _timestamp_less_than(self, actual_value):
        pass

    def _timestamp_less_than_equals(self, actual_value):
        pass
