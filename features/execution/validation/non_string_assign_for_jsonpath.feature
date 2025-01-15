Feature: Validation that a non-string fails to compile when assigning a JSONPath variable

  Scenario: The Pass type can assing a variable using a JSONPath reading from the Parameters
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                      "Param": "Value1"
                  },
                  "QueryLanguage": "JSONPath",
                  "Assign": {
                    "Var2.$": 2
                  }
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
    Then the state machine failed to compile