Feature: Parse json definitions
  As a developer, I want to be able to specify State Machines in JSON format.
  
  These scenarios verify that the json parser is working.

  Scenario: Correct Json
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

  Scenario: Incorrect Json
    Given an invalid state machine defined by:
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
    """
    When the parser runs
    Then the parser fails
