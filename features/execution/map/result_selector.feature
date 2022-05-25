Feature: The Map type can filter results by using ResultSelector

  Scenario: The Map type can use ResultSelector
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "InputPath": "$.detail",
                  "ItemsPath": "$.shipped",
                  "ResultSelector": {
                      "Partner": "FOO",
                      "Result.$": "$"
                  },
                  "ResultPath": "$.detail.result",
                  "OutputPath": "$.detail",
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
      { "prod": "R31", "dest-code": 9511, "quantity": 1344 }
      """
    And for input "A", the state "FirstState" will return:
      """
      blue
      """
    And for input "B", the state "FirstState" will be called with:
      """
      { "prod": "S39", "dest-code": 9511, "quantity": 40 }
      """
    And for input "B", the state "FirstState" will return:
      """
      green
      """
    And for input "C", the state "FirstState" will be called with:
      """
      { "prod": "R31", "dest-code": 9833, "quantity": 12 }
      """
    And for input "C", the state "FirstState" will return:
      """
      red
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.result.Partner" is a string
    And the step result data path "$.result.Partner" matches "FOO"
    And the step result data path "$.result.Result" is a list
    And the step result data path "$.result.Result" contains "unknown"
    And the step result data path "$.result.Result" contains "red"
    And the step result data path "$.result.Result" contains "blue"
    And the step result data path "$.result.Result" contains "green"
    And the JSON output of "FirstState" is
      """
      {
          "delivery-partner": "UQS",
          "shipped": [
              {"prod": "R31", "dest-code": 9511, "quantity": 1344},
              {"prod": "S39", "dest-code": 9511, "quantity": 40},
              {"prod": "R31", "dest-code": 9833, "quantity": 12},
              {"prod": "R40", "dest-code": 9860, "quantity": 887},
              {"prod": "R40", "dest-code": 9511, "quantity": 1220}
          ],
          "result": {
              "Partner": "FOO",
              "Result": ["blue", "green", "red", "unknown", "unknown"]
          }
      }
      """

  Scenario: The Map ResultSelector can pull data from the Context object
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "InputPath": "$.detail",
                  "ItemsPath": "$.shipped",
                  "ResultSelector": {
                      "Eid.$": "$$.Execution.Id"
                  },
                  "ResultPath": "$.detail.result",
                  "OutputPath": "$.detail",
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
      { "prod": "R31", "dest-code": 9511, "quantity": 1344 }
      """
    And for input "A", the state "FirstState" will return:
      """
      blue
      """
    And for input "B", the state "FirstState" will be called with:
      """
      { "prod": "S39", "dest-code": 9511, "quantity": 40 }
      """
    And for input "B", the state "FirstState" will return:
      """
      green
      """
    And for input "C", the state "FirstState" will be called with:
      """
      { "prod": "R31", "dest-code": 9833, "quantity": 12 }
      """
    And for input "C", the state "FirstState" will return:
      """
      red
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.result.Eid" is a string
    And the step result data path "$.result.Eid" matches "123"
    And the JSON output of "FirstState" is
      """
      {
          "delivery-partner": "UQS",
          "shipped": [
              {"prod": "R31", "dest-code": 9511, "quantity": 1344},
              {"prod": "S39", "dest-code": 9511, "quantity": 40},
              {"prod": "R31", "dest-code": 9833, "quantity": 12},
              {"prod": "R40", "dest-code": 9860, "quantity": 887},
              {"prod": "R40", "dest-code": 9511, "quantity": 1220}
          ],
          "result": {
              "Eid": "123"
          }
      }
      """
