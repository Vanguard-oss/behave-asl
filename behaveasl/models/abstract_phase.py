from abc import ABC, abstractmethod

from .step_result import StepResult


class AbstractPhase(ABC):
    """Base class for the various state phases"""

    @abstractmethod
    def execute(self, state_input, phase_input, sr: StepResult):
        """Execute a single phase of a state"""
        raise NotImplementedError
