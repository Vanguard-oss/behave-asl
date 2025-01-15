Feature: The Wait type can use SecondsPath

  Scenario: The Wait type can change the output
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Next": "EndState",
                  "InputPath": "$.Container",
                  "OutputPath": "$.Other",
                  "SecondsPath": "$.Seconds",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Container": {
            "Seconds": 1,
            "Other": {
                "A": "B"
            }
          }
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state waited for "1" seconds
    And the step result data path "$.A" matches "B"
