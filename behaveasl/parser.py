import json

import yaml


def parse_text(input: str) -> dict:
    """Parse the string into a dict"""

    try:
        return json.loads(input)
    except json.decoder.JSONDecodeError:
        return yaml.safe_load(input)
