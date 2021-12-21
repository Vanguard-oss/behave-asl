from .state_machine import StateMachineModel
from .step_result import StepResult


class Execution:
    """Logic for a State Machine execution"""

    def __init__(self, *, state_machine: StateMachineModel):
        self._state_machine = state_machine
        self._current_state = state_machine.get_initial_state_name()
        self._current_state_data = {}
        self._last_step_result = StepResult()

    def execute(self):
        """Execute a single step"""
        pass

    @property
    def last_step_result(self):
        return self._last_step_result
