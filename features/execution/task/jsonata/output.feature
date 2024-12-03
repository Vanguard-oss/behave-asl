Feature: The Task type can send the output to a specific path

  Scenario: The Task type can append the output to a specific subpath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Arguments": {
                      "Static": "Value"
                  },
                  "Output": "{% $merge([$states.input, {'output': $states.result}]) %}"
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Existing": "Value"
      }
      """
    And the resource "Lambda" will be called with:
      """
      {
          "Static": "Value"
      }
      """
    And the resource "Lambda" will return:
      """
      {
          "StaticResponse": "Value"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data is:
      """
      {
          "Existing": "Value",
          "output": {
            "StaticResponse": "Value"
          }
      }
      """