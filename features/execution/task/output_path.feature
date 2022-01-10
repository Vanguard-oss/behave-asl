Feature: The Task type can filter results by using OutputPath

  Scenario: The Task type can use '$' in the OutputPath to copy everything
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Next": "EndState",
                "Resource": "Lambda",
                "ResultPath": "$.output",
                "OutputPath": "$"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    And the resource "Lambda" will be called with any parameters and return:
    """
    {
        "New": "Data"
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
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"
