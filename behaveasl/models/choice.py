class Choice:
    def __init__(self, variable, evaluation_type, evaluation_value, next_state):
        self.variable = variable
        self.evaluation_type = evaluation_type
        self.evaluation_value = evaluation_value
        self.next_state = next_state

    def evaluate(self, state_input: dict):
        # TODO: before calling the method, if the comparator ends in "Path", do the replacement
        # TODO: depending on the value of the Choice's comparator, call the right method
        pass

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
        pass

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
