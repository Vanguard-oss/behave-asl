Feature: The Wait state type is supported

  Scenario: The Wait type can set the next state
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Wait",
                "Seconds": 1,
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Wait",
                "Seconds": 1,
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the last state waited for "1" seconds

  Scenario: The Wait type can end the execution
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Wait",
                "Seconds": 1,
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Wait",
                "Seconds": 1,
                "End": true
            }
        }
    }
    """
    And the state machine is current at the state "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state waited for "1" seconds

  Scenario: The Wait Type works with multiple steps
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Wait",
                "Seconds": 1,
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Wait",
                "Seconds": 1,
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the last state waited for "1" seconds
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state waited for "1" seconds
