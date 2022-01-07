Feature: The Task type can have parameters set

  Scenario: The Task type can set a hard coded parameter
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Next": "EndState",
                "Resource": "Lambda",
                "Parameters": {
                    "Static": "Value"
                },
                "ResultPath": "$.output"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "Existing": "Value"
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.Static" is a string
    And the step result data path "$.output.Static" matches "Value"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Task type can set a parameter that is a JsonPath selector of the input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Next": "EndState",
                "Resource": "Lambda",
                "Parameters": {
                    "Param.$": "$.Existing"
                },
                "ResultPath": "$.output"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "Existing": "Value"
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "Value"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Task type can set a parameter that looks like a JsonPath selector of the input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Next": "EndState",
                "Resource": "Lambda",
                "Parameters": {
                    "Param": "$.Existing"
                },
                "ResultPath": "$.output"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "Existing": "Value"
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "$.Existing"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"
