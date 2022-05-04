from behaveasl.models.abstract_state import AbstractStateModel
from behaveasl.models.state_models import (
    ChoiceState,
    FailState,
    MapState,
    ParallelState,
    PassState,
    SucceedState,
    TaskState,
    WaitState,
)


class StateMachineModel:
    """The model for a State Machine"""

    def __init__(self, definition: dict):
        self._definition = definition
        # For state in _definition, create an instance of the correct state model based on the type of state
        self._states = self._populate_states_from_definition()

    def get_initial_state_name(self) -> str:
        """Get the name of the initial state"""
        return self._definition.get("StartAt", None)

    def get_state(self, name) -> AbstractStateModel:
        """Get a state by name"""
        return self._states[name]

    def _populate_states_from_definition(self) -> dict:
        """From the state machine definition, create models of each state type
        and load them into a dictionary"""
        state_dictionary = {}
        for state_name, state_details in self._definition["States"].items():
            new_state = self._create_state_model(
                state_name=state_name,
                state_type=state_details["Type"],
                state_details=state_details,
            )
            state_dictionary[state_name] = new_state
        return state_dictionary

    def _create_state_model(
        self, state_name: str, state_type: str, state_details: dict
    ) -> AbstractStateModel:
        """Create an instance of a specific state model"""
        type_to_class = {
            "Task": TaskState,
            "Choice": ChoiceState,
            "Pass": PassState,
            "Wait": WaitState,
            "Parallel": ParallelState,
            "Map": MapState,
            "Succeed": SucceedState,
            "Fail": FailState,
        }
        return type_to_class[state_type](state_name, state_details)
