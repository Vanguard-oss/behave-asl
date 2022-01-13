Feature: The Map state type is supported
  As a developer, I would like to validate the Map state type.
  
  These scenarios are a basic regression test that a minimal Map state can be
  executed.  Only the minimum required fields are used.

  Scenario: The Map type can set the next state
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Map",
                "Iterator": {
                    "StartAt": "CallLambda",
                    "States": {
                        "CallLambda": {
                            "Type": "Task",
                            "Resource": "Lambda",
                            "End": true
                        }
                    }
                },
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "End": true
            }
        }
    }
    """
    And the resource "Lambda" will be called with any parameters and return:
    """
    {
    }
    """
    And the execution input is:
    """
    [
        {
            "who": "bob"
        },
        {
            "who": "meg"
        },
        {
            "who": "joe"
        }
    ]
    """
    When the state machine executes
    Then the next state is "EndState"

  Scenario: The Map type can end the execution
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Map",
                "Iterator": {
                    "StartAt": "CallLambda",
                    "States": {
                        "CallLambda": {
                            "Type": "Task",
                            "Resource": "Lambda",
                            "End": true
                        }
                    }
                },
                "End": true
            }
        }
    }
    """
    And the resource "Lambda" will be called with any parameters and return:
    """
    {
    }
    """
    And the execution input is:
    """
    [
        {
            "who": "bob"
        },
        {
            "who": "meg"
        },
        {
            "who": "joe"
        }
    ]
    """
    And the state machine is current at the state "FirstState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded
