from abc import ABC, abstractmethod

from behaveasl.models.abstract_state import AbstractStateModel

from .query_language import QueryLanguage
from .step_result import StepResult


class AbstractPhase(ABC):
    """Base class for the various state phases"""

    def __init__(self, *, state: AbstractStateModel = None):
        self._retry_list = []
        if state is not None:
            self._state = state
            self._state_name = state.state_name

            self._query_language = state.query_language
        else:
            self._state = None
            self._state_name = "unknown"
            self._query_language = QueryLanguage.JSONPATH

    @abstractmethod
    def execute(self, state_input, phase_input, sr: StepResult, execution):
        """Execute a single phase of a state"""
        raise NotImplementedError

    @property
    def retry_list(self) -> list:
        return self._retry_list

    @property
    def state(self) -> AbstractStateModel:
        return self._state

    def is_using_jsonpath(self):
        return self._query_language == QueryLanguage.JSONPATH

    def is_using_jsonata(self):
        return self._query_language == QueryLanguage.JSONATA
