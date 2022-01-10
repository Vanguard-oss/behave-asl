from dataclasses import dataclass


@dataclass
class StepResult:
    """Data Class storing information about the result of a step execution"""

    next_state: str = None
    result_data: object = None
    end_execution: bool = False
    failed: bool = False
    cause: str = None
    error: str = None
