from .state_machine import StateMachineModel


class Execution:
    """Logic for a State Machine execution"""

    def __init__(self, *, state_machine: StateMachineModel):
        self._state_machine = state_machine
        self._current_state = state_machine.get_initial_state_name()
        self._current_state_data = {}

    def execute(self, behave_context):
        """Execute a single step"""
        pass
