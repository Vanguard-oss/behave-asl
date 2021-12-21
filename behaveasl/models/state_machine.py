from .abstract_state import AbstractStateModel


class StateMachineModel:
    """The model for a State Machine"""

    def __init__(self, definition: dict):
        self._definition = definition
        self._states = {}

    def get_initial_state_name(self) -> str:
        """Get the name of the initial state"""
        return self._definition.get("StartAt", None)

    def get_state(self, name) -> AbstractStateModel:
        """Get a state by name"""
        return self._states[name]
