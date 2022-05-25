from abc import ABC, abstractmethod

from .step_result import StepResult


class AbstractPhase(ABC):
    """Base class for the various state phases"""

    def __init__(self):
        self._retry_list = []

    @abstractmethod
    def execute(self, state_input, phase_input, sr: StepResult, execution):
        """Execute a single phase of a state"""
        raise NotImplementedError

    @property
    def retry_list(self) -> list:
        return self._retry_list
