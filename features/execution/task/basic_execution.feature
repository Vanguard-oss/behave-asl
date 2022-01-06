Feature: The Task state type is supported

  Scenario: The Task type can set the next state
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"

  Scenario: The Task type can end the execution
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    And the state machine is current at the state "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Task Type works with multiple steps
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded
