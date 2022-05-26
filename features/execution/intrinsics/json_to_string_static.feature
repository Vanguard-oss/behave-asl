Feature: The States.JsonToString intrinsic can be used with static strings

  Scenario: The Pass type can use States.JsonToString to convert a string
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonToString('Hello World')"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": "\"Hello World\""
      }
      """
