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
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
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
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    And the state machine is current at the state "FirstState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

Scenario: The Map type can use a map mock
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Map",
                "Iterator": {
                    "StartAt": "Validate",
                    "States": {
                        "Validate": {
                            "Type": "Task",
	                        "Resource": "arn:aws:lambda:us-east-1:123456789012:function:ship-val",
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
      { "prod": "R31", "dest-code": 9511, "quantity": 1344 },
      { "prod": "S39", "dest-code": 9511, "quantity": 40 },
      { "prod": "R31", "dest-code": 9833, "quantity": 12 },
      { "prod": "R40", "dest-code": 9860, "quantity": 887 },
      { "prod": "R40", "dest-code": 9511, "quantity": 1220 }
    ]
    """
    And the state "FirstState" will return "blue" for input:
    """
    { "prod": "R31", "dest-code": 9511, "quantity": 1344 }
    """
    And the state "FirstState" will return "green" for input:
    """
    { "prod": "S39", "dest-code": 9511, "quantity": 40 }
    """
    And the state "FirstState" will return "red" for input:
    """
    { "prod": "R31", "dest-code": 9833, "quantity": 12 }
    """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the json output of "FirstState" is
    """
    [
      "blue",
      "green",
      "red",
      "unknown",
      "unknown"
    ]
    """

