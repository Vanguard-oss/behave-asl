from behaveasl.models.choice import Choice

class ChoiceRule:
    def __init__(self, choice:Choice, state_input: dict):
        # TODO: consider whether to assign the Choice's attributes to the ChoiceRule
        pass
    
    def evaluate(self):
        # TODO: before callling the method, if the comparator ends in "Path", do the replacement
        # TODO: depending on the value of the Choice's comparator, call the right method
        pass

    # Follow the order of comparators here: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html
    def and_comparator(self): # And is a reserved word in Python
        pass

    def boolean_equals(self):
        pass

    def is_boolean(self):
        pass

    def is_null(self):
        pass

    def is_numeric(self):
        pass

    def is_present(self):
        pass

    def is_string(self):
        pass

    def is_timestamp(self):
        pass

    def not_comparator(self): # Not is a reserved word in Python
        pass

    def numeric_equals(self):
        pass

    def numeric_greater_than(self):
        pass

    def numeric_greater_than_equals(self):
        pass

    def numeric_less_than(self):
        pass

    def numeric_less_than_equals(self):
        pass

    def or_comparator(self):
        pass

    def string_equals(self):
        pass

    def string_greater_than(self):
        pass

    def string_greater_than_equals(self):
        pass

    def string_less_than(self):
        pass

    def string_less_than_equals(self):
        pass

    def string_matches(self):
        pass

    def timestamp_equals(self):
        pass

    def timestamp_equals(self):
        pass

    def timestamp_greater_than(self):
        pass

    def timestamp_greater_than_equals(self):
        pass

    def timestamp_less_than(self):
        pass

    def timestamp_less_than_equals(self):
        pass

