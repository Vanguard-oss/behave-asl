class Choice:
    def __init__(self, variable, evaluation_type, evaluation_value, next_state):
        self._variable = variable
        self._evaluation_type = evaluation_type
        self._evaluation_value = evaluation_value
        self.next_state = next_state
        self._choices = None # If this is set, we are using an "And"/"Or"/"Not" comparator
    

    def evaluate(self, state_input: dict):
        self._state_input = state_input
        # TODO: before calling the method, if the comparator ends in "Path", do the replacement
        # need to use jsonpath-ng to extract choice.variable from self._state_input
        self._actual_value = self.parse_variable_value_from_input()
        # TODO: If self._actual_value is None, raise a StatesRuntimeException (no value could be located)
        # TODO: depending on the value of the Choice's comparator, call the right method - compare actual_value with evaluation_value
        function_map = {
            'StringEquals': self._string_equals
        }
        return function_map[self._evaluation_type]()

    def parse_variable_value_from_input(self):
        from behaveasl import jsonpath
        from behaveasl.models.exceptions import StatesRuntimeException
        # TODO: parse other versions of this
        if self._variable.startswith("$"):
            jpexpr = jsonpath.get_instance(self._variable)
            results = jpexpr.find(self._state_input)
            if len(results) == 1:
                new_value = results[0].value
                print(f"Matched '{self._variable}' [from state_input] with '{new_value}'")
                return new_value
            else:
                return None        

    # Follow the order of comparators here: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html
    def _and_comparator(self): # And is a reserved word in Python
        pass

    def _boolean_equals(self):
        pass

    def _is_boolean(self):
        pass

    def _is_null(self):
        pass

    def _is_numeric(self):
        pass

    def _is_present(self):
        pass

    def _is_string(self):
        pass

    def _is_timestamp(self):
        pass

    def _not_comparator(self): # Not is a reserved word in Python
        pass

    def _numeric_equals(self):
        pass

    def _numeric_greater_than(self):
        pass

    def _numeric_greater_than_equals(self):
        pass

    def _numeric_less_than(self):
        pass

    def _numeric_less_than_equals(self):
        pass

    def _or_comparator(self):
        pass

    def _string_equals(self):
        # TODO: check type first
        return self._actual_value == self._evaluation_value

    def _string_greater_than(self):
        pass

    def _string_greater_than_equals(self):
        pass

    def _string_less_than(self):
        pass

    def _string_less_than_equals(self):
        pass

    def _string_matches(self):
        pass

    def _timestamp_equals(self):
        pass

    def _timestamp_equals(self):
        pass

    def _timestamp_greater_than(self):
        pass

    def _timestamp_greater_than_equals(self):
        pass

    def _timestamp_less_than(self):
        pass

    def _timestamp_less_than_equals(self):
        pass
