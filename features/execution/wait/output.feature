Feature: The Wait state type can use JSONata to change the output

  Scenario: The Wait type can set the next state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Seconds": 1,
                  "QueryLanguage": "JSONata",
                  "Next": "EndState",
                  "Output": {
                    "A": "{% 'B' %}"
                  }
              },
              "EndState": {
                  "Type": "Wait",
                  "Seconds": 1,
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.A" matches "B"
