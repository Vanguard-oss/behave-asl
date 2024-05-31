Feature: The Map state supports the Parameters phase using the legacy Parameters key

  Scenario: The Map type can use Parameters
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
                  "ItemProcessor": {
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
    And for input "A", the state "FirstState" will be called with:
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
    And for input "A", the state "FirstState" will return:
      """
      blue
      """
    And for input "B", the state "FirstState" will be called with:
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
    And for input "B", the state "FirstState" will return:
      """
      green
      """
    And for input "C", the state "FirstState" will be called with:
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
    And for input "C", the state "FirstState" will return JSON:
      """
      {"color": "red"}
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the JSON output of "FirstState" is
      """
      [
        "blue",
        "green",
        {"color": "red"},
        "unknown",
        "unknown"
      ]
      """
