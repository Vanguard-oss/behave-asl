Feature: The Fail state type is supported with JSONata

  Scenario: The Fail type can terminate the machine and mark the execution as a failure
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "QueryLanguage": "JSONata"
              }
          }
      }
      """
    When the state machine executes
    Then the execution failed
    And the execution ended
    And the execution error was null
    And the execution error cause was null

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

  Scenario: The Fail type can provide a custom error name
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "Error": "CustomError",
                  "QueryLanguage": "JSONata"
              }
          }
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the execution error was "CustomError"
    And the execution error cause was null

  Scenario: The Fail type can provide a custom error name with JSONata
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "Error": "{% 'CustomError' %}",
                  "QueryLanguage": "JSONata"
              }
          }
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the execution error was "CustomError"
    And the execution error cause was null

  Scenario: The Fail type can provide a custom failure string
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "Cause": "I am designed to fail",
                  "QueryLanguage": "JSONata"
              }
          }
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the execution error was null
    And the execution error cause was "I am designed to fail"

  Scenario: The Fail type can provide a custom failure string using JSONata
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Fail",
                  "Cause": "{% 'I am designed to fail' %}",
                  "QueryLanguage": "JSONata"
              }
          }
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the execution error was null
    And the execution error cause was "I am designed to fail"

