Feature: The Pass state type is supported
  As a developer, I would like to validate the Pass state type.
  
  These scenarios are a basic regression test that a minimal Pass state can be
  executed.  Only the minimum required fields are used.

  Scenario: The Pass type can set the next state
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"

  Scenario: The Pass type can end the execution
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the state machine is current at the state "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Pass Type works with multiple steps
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
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
