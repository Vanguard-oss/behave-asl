import json

import yaml

from behaveasl.models.state_machine import StateMachineModel


def parse_text(input: str) -> dict:
    """Parse the string into a dict"""

    try:
        return json.loads(input)
    except json.decoder.JSONDecodeError:
        return yaml.safe_load(input)


def create_state_machine(input: dict) -> StateMachineModel:
    """Create a state machine based on the input dictionary"""
    return StateMachineModel(definition=input)
