Feature: The Succeed state type is supported
  As a developer, I would like to validate the Succeed state type.
  
  These scenarios are a basic regression test that a minimal Succeed state can
  be executed.  Only the minimum required fields are used.

  Scenario: The Succeed type can terminate the machine and mark the execution as a success
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Succeed"
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the execution ended

  Scenario: The Succeed type works with multiple steps
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "SecondState"
              },
              "SecondState": {
                  "Type": "Succeed"
              }
          }
      }
      """
    When the state machine executes
    Then the next state is "SecondState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded
