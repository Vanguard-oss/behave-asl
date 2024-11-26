from abc import ABC, abstractmethod

from .step_result import StepResult


class AbstractStateModel(ABC):
    """Base class for the various state types"""

    def __init__(self, state_name: str, state_details: dict, **kwargs):
        self._state_name = state_name
        self._state_details = state_details

    @abstractmethod
    def execute(self, input, execution) -> StepResult:
        """Execute the step and return the result"""
        raise NotImplementedError

    @property
    def state_name(self) -> str:
        return self._state_name

    @property
    def state_details(self) -> dict:
        return self._state_details
