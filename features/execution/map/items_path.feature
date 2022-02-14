Feature: The Map state supports the ItemsPath phase

Scenario: The Map type can use an ItemsPath to provide a list to the map state
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Map",
                "InputPath": "$.detail",
                "ItemsPath": "$.shipped",
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
    {
        "ship-date": "2016-03-14T01:59:00Z",
        "detail": {
            "delivery-partner": "UQS",
            "shipped": [
                { "prod": "R31", "dest-code": 9511, "quantity": 1344 },
                { "prod": "S39", "dest-code": 9511, "quantity": 40 },
                { "prod": "R31", "dest-code": 9833, "quantity": 12 },
                { "prod": "R40", "dest-code": 9860, "quantity": 887 },
                { "prod": "R40", "dest-code": 9511, "quantity": 1220 }
            ]
        }
    }
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