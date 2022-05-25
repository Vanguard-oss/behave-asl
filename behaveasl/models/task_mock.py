from abc import ABC, abstractmethod

from behaveasl import assertions
from behaveasl.models.exceptions import StatesCatchableException


class AbstractMock(ABC):
    """Base mock class"""

    @abstractmethod
    def execute(self, resource_name: str, resource_input):
        """Mock the execution of a task resource"""
        raise NotImplementedError


class StaticResponse(AbstractMock):
    """Mock the return as a static response"""

    def __init__(self, response):
        self._response = response

    def execute(self, resource_name: str, resource_input):
        return self._response


class ErrorResponse(AbstractMock):
    """Mock the return as an error response"""

    def __init__(self, error):
        self._error = error

    def execute(self, resource_name: str, resource_input):
        raise StatesCatchableException(self._error)


class AssertParameters(AbstractMock):
    """Mock that verified the parameters"""

    def __init__(self, expected):
        self._expected = expected

    def execute(self, resource_name: str, resource_input):
        assertions.assert_json_matches(self._expected, resource_input)


class AnyParameters(AbstractMock):
    """Mock that skips parameter verification"""

    def execute(self, resource_name: str, resource_input):
        """Don't actually validate anything"""


class MockList(AbstractMock):
    """A list of mocks that are executed one at a time"""

    def __init__(self):
        self._list = []

    def execute(self, resource_name: str, resource_input):
        # TODO: dynamically set should_pop for error handling
        should_pop = False
        if should_pop:
            m = self._list.pop(0)
        else:
            m = self._list[0]
        return m.execute(resource_name, resource_input)

    def add_mock(self, obj):
        """Add a mock to the list of mocks"""
        self._list.append(obj)


class ResourceMockMap(AbstractMock):
    """A map of mocks specific to resources"""

    def __init__(self):
        self._map = {}

    def execute(self, resource_name: str, resource_input):
        return self._map[resource_name].execute(resource_name, resource_input)

    def add_mock(self, resource_name, obj):
        """Add a mock for a specific resource"""
        if resource_name not in self._map:
            self._map[resource_name] = MockList()

        self._map[resource_name].add_mock(obj)
