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
                    "StartAt": "SubState",
                    "States": {
                        "SubState": {
                            "Type": "Pass",
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
                    "StartAt": "SubState",
                    "States": {
                        "SubState": {
                            "Type": "Pass",
                            "End": true
                        }
                    }
                },
                "End": true
            }
        }
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

Scenario: The Map type can use a resource mock
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Map",
                "Iterator": {
                    "StartAt": "SubState",
                    "States": {
                        "SubState": {
                            "Type": "Pass",
                            "End": true
                        },
                        "SubState2": {
                            "Type": "Pass",
                            "End": true
                        }
                    }
                },
                "Next": "SecondState"
            },
            "SecondState": {
                "Type": "Map",
                "Iterator": {
                    "StartAt": "SubState",
                    "States": {
                        "SubState": {
                            "Type": "Pass",
                            "End": true
                        },
                        "SubState2": {
                            "Type": "Pass",
                            "End": true
                        }
                    }
                },
            "EndState": {
                "Type": "Pass",
                "End": true
            }
        }
    }
    """
    And the map state "FirstState" will be called with any parameters and return:
    """
    1
    """
    And the map state "SecondState" will be called with any parameters and return:
    """
    2
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
    Then the output of "FirstState" is "[1, 1, 1]"
    And the output of "SecondState" is "[2, 2, 2]"