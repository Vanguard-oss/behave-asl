Feature: Validation when JSONPath expressions are used in JSONata mode

  Scenario: JSONata task with JSONPath variable key
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
                  "QueryLanguage": "JSONata",
                  "Assign": {
                    "Var2.$": "$.Param"
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