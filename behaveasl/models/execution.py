import copy
import datetime
import logging

from behaveasl.models.exceptions import (
    StatesCatchableException,
    StatesException,
)
from behaveasl.models.state_machine import StateMachineModel
from behaveasl.models.state_phases import ResultPathPhase
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
        if "Map" in str(self._state_machine.get_state(self._current_state)):
            self._context_obj["Map"] = {}
            self._context_obj["Map"]["Item"] = {"Index": "", "Value": ""}
        self._log = logging.getLogger("behaveasl.Execution")

    def execute(self):
        """Execute a single step"""
        current_state_obj = self._state_machine.get_state(self._current_state)
        self._context_obj["State"]["Name"] = self._current_state
        self._context_obj["State"]["EnteredTime"] = datetime.datetime.now().isoformat()

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
                self._context_obj["State"]["RetryCount"] = 0
        except StatesCatchableException as e:
            self._log.exception(
                f"Error executing state {self._current_state}, error={e.error}, cause={e.cause}"
            )

            try:
                self._handle_retries(current_state_obj, e)
            except StatesCatchableException as e2:
                self._handle_catches(current_state_obj, e2)

        except StatesException as e:
            self._log.exception(
                f"Failed to execute state {self._current_state}, error={e.error}, cause={e.cause}"
            )
            self._last_step_result.end_execution = True
            self._last_step_result.failed = True
            self._last_step_result.error = e.error
            self._last_step_result.cause = e.cause

    def _handle_retries(self, current_state_obj, e):
        retry = self._find_matching_retry(current_state_obj._retry_list, e.error)
        if retry is None:
            self._log.info(f"No matching Retry found, bubbling up exception")
            self._context_obj["State"]["RetryCount"] = 0
            raise e
        else:
            self._log.info(f"Found a matching Retry configuration")
            self._context_obj["State"]["RetryCount"] = (
                self._context_obj["State"]["RetryCount"] + 1
            )

            current_retry_count = self._context_obj["State"]["RetryCount"]

            if current_retry_count < retry.max_attempts:
                self._log.info(
                    f"Retry count {current_retry_count} < {retry.max_attempts}, trying again"
                )
                self._last_step_result.next_state = self._current_state
            else:
                self._log.info(
                    f"Retry count {current_retry_count} >= {retry.max_attempts}, not trying again"
                )
                raise e

    def _handle_catches(self, current_state_obj, e):
        catch = self._find_matching_catch(current_state_obj._catch_list, e.error)
        self._last_step_result = StepResult()
        if catch is None:
            self._log.info(f"No matching Catch found, failing execution")
            self._last_step_result.end_execution = True
            self._last_step_result.failed = True
            self._last_step_result.error = e.error
            self._last_step_result.cause = e.cause
        else:
            self._log.info(f"Found a matching Catch configuration")
            self._last_step_result.next_state = catch.next

            error_data = {"Cause": e.cause}

            rpp = ResultPathPhase(result_path=catch.result_path)

            self._last_step_result.result_data = rpp.execute(
                self._current_state_data,
                error_data,
                self._last_step_result,
                self,
            )

    def _find_matching_retry(self, retry_list, error):
        for r in retry_list:
            if (
                error in r.error_list
                or ("States.ALL" in r.error_list and error not in ["States.Runtime"])
                or (
                    error not in ["States.Timeout", "States.Runtime"]
                    and "States.TaskFailed" in r.error_list
                )
            ):
                return r
        return None

    def _find_matching_catch(self, catch_list, error):
        for c in catch_list:
            if (
                error in c.error_list
                or ("States.ALL" in c.error_list and error not in ["States.Runtime"])
                or (
                    error not in ["States.Timeout", "States.Runtime"]
                    and "States.TaskFailed" in c.error_list
                )
            ):
                return c
        return None

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

    def set_retry_count(self, count: int):
        self._context_obj["State"]["RetryCount"] = count

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
