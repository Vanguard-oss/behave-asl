Feature: The Wait state type can assign variables

  Scenario: The Wait type can set the next state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Wait",
                  "Seconds": 1,
                  "Next": "EndState",
                  "Assign": {
                    "A": "B"
                  }
              },
              "EndState": {
                  "Type": "Wait",
                  "Seconds": 1,
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the variable path "A" matches "B"