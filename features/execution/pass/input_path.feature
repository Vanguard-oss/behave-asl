Feature: The Pass type can have an input path that filters the input

  Scenario: The Pass type can set a parameter that is a JsonPath selector of the input path
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "InputPath": "$.Map",
                "Parameters": {
                    "Param.$": "$.Key"
                },
                "ResultPath": "$.output"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "Map": {
            "Key": "Value"
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "Value"
    And the step result data path "$.Map.Key" is a string
    And the step result data path "$.Map.Key" matches "Value"

  Scenario: The Pass type can set aan input path without a parameter
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "InputPath": "$.Map",
                "ResultPath": "$.output"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "Map": {
            "Key": "Value"
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.Key" is a string
    And the step result data path "$.output.Key" matches "Value"
    And the step result data path "$.Map.Key" is a string
    And the step result data path "$.Map.Key" matches "Value"


  Scenario: The Pass type can set an input path from the Context object
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "InputPath": "$$.Execution.Input.Map"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the execution input is:
    """
    {
        "Map": {
            "Key": "Value"
        }
    }
    """
    When the state machine executes
    Then the step result data is:
    """
    {
        "Key": "Value"
    }
    """
