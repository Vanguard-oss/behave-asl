Feature: Intrinsics support UUID

  Scenario: The Pass type can return a UUID
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.UUID()"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data path "Param" is a string
