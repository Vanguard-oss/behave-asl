Feature: The States.StringToJson intrinsic can be used with static strings

  Scenario: The Pass type can use States.StringToJson to return a string
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.StringToJson('\"Hello World\"')"
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
        "Param": "Hello World"
    }
    """

  Scenario: The Pass type can use States.StringToJson to return a list
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.StringToJson('[\"A\", \"B\", \"C\"]')"
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
        "Param": ["A", "B", "C"]
    }
    """
