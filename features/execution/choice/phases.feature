Feature: The Choice type supports Input, Output, and Result Processing

  Scenario: The Choice type supports InputPath
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "InputPath": "$.dataset2",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringEquals": "red",
                        "Next": "EndState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass",
                "End": true
            },
            "DefaultState": {
                "Type": "Pass",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "dataset1": {
            "thing": "blue"
        },
        "dataset2": {
            "thing": "red"
        }
    }
    """
    When the state machine executes
    Then the next state is "MatchState"

  Scenario: The Choice type supports Parameters
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringEquals": "blue",
                        "Next": "EndState"
                    }
                ]
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
        "thing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Choice type supports OutputPath
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringEquals": "blue",
                        "Next": "EndState"
                    }
                ]
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
        "thing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded
