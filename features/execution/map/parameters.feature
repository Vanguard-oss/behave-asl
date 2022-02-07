Feature: The Map state supports the Parameters phase

Scenario: The Map type can use an Parameters
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Map",
                "InputPath": "$.detail",
                "ItemsPath": "$.shipped",
                "Parameters": {
                    "parcel.$": "$$.Map.Item.Value",
                    "courier.$": "$.delivery-partner"
                },
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
    And the map state "FirstState" will return "blue" for input:
    """
    {
        "parcel": {
            "prod": "R31",
            "dest-code": 9511,
            "quantity": 1344
        },
        "courier": "UQS"
    }
    """
    And the map state "FirstState" will return "green" for input:
    """
    {
        "parcel": {
            "prod": "S39",
            "dest-code": 9511,
            "quantity": 40
        },
        "courier": "UQS"
    }
    """
    And the map state "FirstState" will return "red" for input:
    """
    {
        "parcel": {
            "prod": "R31",
            "dest-code": 9833,
            "quantity": 12
        },
        "courier": "UQS"
    }
    """
    And the map state "FirstState" will return "unknown" when invoked with any unknown parameters
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