from dataclasses import dataclass


@dataclass
class StepResult:
    """Data Class storing information about the result of a step execution"""

    next_state: str
    result_data: object
    end_execution: bool = False
