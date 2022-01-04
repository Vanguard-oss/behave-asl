Feature: The Succeed type can filter results by using OutputPath

  Scenario: The Succeed type can use '$' in the OutputPath to copy everything
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Succeed",
                "OutputPath": "$"
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
    Then the execution succeeded
    And the execution ended
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"
