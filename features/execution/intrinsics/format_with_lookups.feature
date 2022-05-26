Feature: The States.Format intrinsic can be used with lookups

  Scenario: The Pass type can return static formatted data
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.Format($$.Execution.Input.Template, 'World')"
                  },
                  "End": true
              }
          }
      }
      """
    And the execution input is:
      """
      {
          "Template": "Hello {}"
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": "Hello World"
      }
      """
