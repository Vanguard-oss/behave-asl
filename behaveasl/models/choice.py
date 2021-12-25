class Choice:
    def __init__(self, variable, evaluation_type, evaluation_value, next_state):
        self.variable = variable
        self.evaluation_type = evaluation_type
        self.evaluation_value = evaluation_value
        self.next_state = next_state