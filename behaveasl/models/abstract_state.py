from abc import ABC, abstractmethod

from .query_language import QueryLanguage, get_query_language
from .step_result import StepResult


class AbstractStateModel(ABC):
    """Base class for the various state types"""

    def __init__(self, state_machine, state_name: str, state_details: dict, **kwargs):
        self._state_name = state_name
        self._state_details = state_details
        self._query_language = QueryLanguage.JSONPATH
        self._state_machine = state_machine
        self._determine_query_language()

    @abstractmethod
    def execute(self, input, execution) -> StepResult:
        """Execute the step and return the result"""
        raise NotImplementedError

    def _determine_query_language(self):
        if "QueryLanguage" in self._state_details:
            self.query_language = get_query_language(
                self._state_details["QueryLanguage"]
            )
        else:
            self.query_language = self._state_machine.query_language

    @property
    def state_machine(self):
        return self._state_machine

    @property
    def state_name(self) -> str:
        return self._state_name

    @property
    def state_details(self) -> dict:
        return self._state_details

    @property
    def query_language(self) -> QueryLanguage:
        return self._query_language

    @query_language.setter
    def query_language(self, value: QueryLanguage):
        self._query_language = value
