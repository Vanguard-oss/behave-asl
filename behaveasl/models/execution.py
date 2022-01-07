import copy
import datetime

from .state_machine import StateMachineModel
from .step_result import StepResult


class Execution:
    """Logic for a State Machine execution"""

    def __init__(self, *, state_machine: StateMachineModel):
        self._state_machine = state_machine
        self._current_state = state_machine.get_initial_state_name()
        self._current_state_data = {}
        self._last_step_result = StepResult()
        self._context_obj = {
            "Execution": {
                "Id": "123",
                "Input": {},
                "StartTime": datetime.datetime.now().isoformat(),
            },
            "State": {"EnteredTime": "", "Name": self._current_state, "RetryCount": 0},
            "StateMachine": {"Id": "unittest"},
            "Task": {"Token": "abc123"},
        }

    def execute(self):
        """Execute a single step"""
        current_state_obj = self._state_machine.get_state(self._current_state)
        self._context_obj["State"]["Name"] = self._current_state
        self._context_obj["State"]["EnteredTime"] = datetime.datetime.now().isoformat()
        self._context_obj["State"]["RetryCount"] = 0
        self._last_step_result = current_state_obj.execute(
            self._current_state_data, self
        )
        if self._last_step_result.next_state is not None:
            self._current_state = self._last_step_result.next_state

    def set_execution_input_data(self, data):
        """Set the initial input of the execution"""
        self._context_obj["Execution"]["Input"] = copy.deepcopy(data)
        if self._current_state == self._state_machine.get_initial_state_name():
            self._current_state_data = copy.deepcopy(data)

    def set_current_state_data(self, data):
        """Set the current state data that will bed the input of the next state"""
        self._current_state_data = data

    def set_current_state_name(self, name: str):
        """Set the name of the current state of the execution"""
        self._current_state = name

    @property
    def last_step_result(self):
        return self._last_step_result

    @property
    def context(self):
        return self._context_obj
