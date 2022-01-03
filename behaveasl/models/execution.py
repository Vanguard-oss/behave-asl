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
        current_state_obj = self._state_machine.get_state(self._current_state)
        self._last_step_result = current_state_obj.execute(self._current_state_data)
        if self._last_step_result.next_state is not None:
            self._current_state = self._last_step_result.next_state

    def set_current_state_data(self, data):
        self._current_state_data = data

    def set_current_state_name(self, name: str):
        self._current_state = name

    @property
    def last_step_result(self):
        return self._last_step_result
