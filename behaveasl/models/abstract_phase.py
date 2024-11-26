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

            langs = {
                "JSONPath": QueryLanguage.JSONPATH,
                "JSONata": QueryLanguage.JSONATA,
            }

            self._query_language = langs[
                state.state_details.get("QueryLanguage", "JSONPath")
            ]
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
