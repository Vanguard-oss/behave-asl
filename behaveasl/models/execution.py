import copy
import datetime
import logging

from behaveasl.models.exceptions import StatesException
from behaveasl.models.state_machine import StateMachineModel
from behaveasl.models.step_result import StepResult
from behaveasl.models.task_mock import ResourceMockMap


class Execution:
    """Logic for a State Machine execution"""

    def __init__(self, *, state_machine: StateMachineModel):
        self._state_machine: StateMachineModel = state_machine
        self._current_state: str = state_machine.get_initial_state_name()
        self._current_state_data: dict = {}
        self._last_step_result: StepResult = StepResult()
        self._context_obj: dict = {
            "Execution": {
                "Id": "123",
                "Input": {},
                "StartTime": datetime.datetime.now().isoformat(),
            },
            "State": {"EnteredTime": "", "Name": self._current_state, "RetryCount": 0},
            "StateMachine": {"Id": "unittest"},
            "Task": {"Token": "abc123"},
        }
        self._resource_response_mocks: ResourceMockMap = ResourceMockMap()
        self._resource_expectations: ResourceMockMap = ResourceMockMap()
        self._log = logging.getLogger("behaveasl.Execution")

    def execute(self):
        """Execute a single step"""
        current_state_obj = self._state_machine.get_state(self._current_state)
        self._context_obj["State"]["Name"] = self._current_state
        self._context_obj["State"]["EnteredTime"] = datetime.datetime.now().isoformat()
        self._context_obj["State"]["RetryCount"] = 0

        try:
            self._log.info(
                f"Executing '{self._current_state}' with input: '{self._current_state_data}'"
            )
            self._last_step_result = current_state_obj.execute(
                self._current_state_data, self
            )
            if self._last_step_result.next_state is not None:
                self._current_state = self._last_step_result.next_state
                self._current_state_data = self._last_step_result.result_data
        except StatesException as e:
            self._log.exception(
                f"Failed to execute state {self._current_state}, error={e.error}, cause={e.cause}"
            )
            self._last_step_result.end_execution = True
            self._last_step_result.failed = True
            self._last_step_result.error = e.error
            self._last_step_result.cause = e.cause

    def set_execution_input_data(self, data):
        """Set the initial input of the execution"""
        self._context_obj["Execution"]["Input"] = copy.deepcopy(data)
        if self._current_state == self._state_machine.get_initial_state_name():
            self._current_state_data = copy.deepcopy(data)

    def set_current_state_data(self, data):
        """Set the current state data that will be the input of the next state"""
        self._current_state_data = data

    def set_current_state_name(self, name: str):
        """Set the name of the current state of the execution"""
        self._current_state = name

    @property
    def last_step_result(self) -> StepResult:
        return self._last_step_result

    @property
    def context(self) -> dict:
        return self._context_obj

    @property
    def resource_response_mocks(self) -> ResourceMockMap:
        return self._resource_response_mocks

    @property
    def resource_expectations(self) -> ResourceMockMap:
        return self._resource_expectations
