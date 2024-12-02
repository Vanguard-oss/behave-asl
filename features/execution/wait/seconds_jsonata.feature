Feature: The Wait type can use SecondsPath

  Scenario: The Wait type can use JSONata in the Seconds field
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Next": "EndState",
                  "QueryLanguage": "JSONata",
                  "Seconds": "{% $states.input.Seconds %}",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Seconds": 1
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state waited for "1" seconds
