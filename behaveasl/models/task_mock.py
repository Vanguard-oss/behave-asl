from abc import ABC, abstractmethod

from behaveasl import assertions


class AbstractMock(ABC):
    """Base mock class"""

    @abstractmethod
    def execute(self, resource_name: str, resource_input):
        """Mock the execution of a task resource"""
        raise NotImplementedError


class StaticResponse(AbstractMock):
    """Mock the returns a static response"""

    def __init__(self, response):
        self._response = response

    def execute(self, resource_name: str, resource_input):
        return self._response


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
        m = self._list.pop(0)
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
            self._map[resource_name] = obj

    def add_mock_list(self, resource_name, obj):
        """Add a mock for a specific resource"""
        if resource_name not in self._map:
            self._map[resource_name] = MockList()

        self._map[resource_name].add_mock(obj)
