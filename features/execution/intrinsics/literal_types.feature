Feature: Intrinsics support various data types

  Scenario Outline: The Pass type can return static array data
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.Array(<input>)"
                },
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
    """
    {
        "Param": <output>
    }
    """

    Examples: Static strings
      | input | output |
      | 'A'   | ["A"]  |
      | 2     | [2]    |
      | 2.2   | [2.2]  |
