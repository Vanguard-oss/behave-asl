from abc import ABC, abstractmethod

from .step_result import StepResult


class AbstractStateModel(ABC):
    """Base class for the various state types"""

    @abstractmethod
    def execute(self, input, execution) -> StepResult:
        """Execute the step and return the result"""
        raise NotImplementedError
