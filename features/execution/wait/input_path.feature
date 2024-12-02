Feature: The Wait type can use SecondsPath

  Scenario: The Wait type can use SecondsPath to pull a value from a filtered state input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Next": "EndState",
                  "InputPath": "$.Container",
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
            "Seconds": 1
          }
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state waited for "1" seconds
