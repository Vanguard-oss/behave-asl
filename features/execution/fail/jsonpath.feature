Feature: The Fail state type is supported with JSONPath

  Scenario: The Fail type works with multiple steps
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "FailState"
              },
              "FailState": {
                  "Type": "Fail",
                  "QueryLanguage": "JSONata"
              }
          }
      }
      """
    When the state machine executes
    Then the next state is "FailState"
    When the state machine executes
    Then the execution ended
    And the execution failed

  Scenario: The Fail type can provide a custom error name using JSONPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "ErrorPath": "$.Error"
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Error": "CustomError"
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the execution error was "CustomError"
    And the execution error cause was null


  Scenario: The Fail type can provide a custom failure string using JSONata
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "CausePath": "$.Cause"
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Cause": "I am designed to fail"
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the execution error was null
    And the execution error cause was "I am designed to fail"

