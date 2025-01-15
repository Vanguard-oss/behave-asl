Feature: The Pass type can have a result path that selects the result

  Scenario: The Pass type can set a parameter that is a JsonPath selector of the input path
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "InputPath": "$.Map",
                  "Parameters": {
                      "Param.$": "$.Key"
                  },
                  "ResultPath": null
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Map": {
              "Key": "Value"
          }
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data is:
      """
      {
          "Map": {
              "Key": "Value"
          }
      }
      """


  Scenario: ResultPath cannot be used with JSONata
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "InputPath": "$.Map",
                  "ResultPath": "$.out"
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Map": {
              "Key": "Value"
          }
      }
      """
    When the state machine executes
    Then the state machine failed to compile