Feature: The Pass type can filter results by using Output

  Scenario: The Output can use values from the Context object
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Output": "{% $states.context.Execution.Input.Existing %}"
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the execution input is:
      """
      {
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the step result data is:
      """
      "Value"
      """

  Scenario: The Output can use values from the state input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Output": "{% $states.input.Existing %}"
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the execution input is:
      """
      {
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the step result data is:
      """
      "Value"
      """

  Scenario: The Output cannot be used with JSONPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONPath",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Output": "{% $states.context.Execution.Input.Existing %}"
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the execution input is:
      """
      {
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the state machine failed to compile