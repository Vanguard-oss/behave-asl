Feature: The Wait type can use TimestampPath

  Scenario: The Wait type can use TimestampPath to pull a value from the state input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Next": "EndState",
                  "TimestampPath": "$.Timestamp",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Timestamp": "2022-01-10T12:00:02+00:00"
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state waited until "2022-01-10T12:00:02+00:00"
