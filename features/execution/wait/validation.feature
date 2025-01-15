Feature: Validation for the Wait state

  Scenario: The Wait type can use JSONata to get the Timestamp to wait until
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Next": "EndState",
                  "QueryLanguage": "JSONata",
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
    Then the state machine failed to compile