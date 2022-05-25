Feature: Thas Task can retry a failed state

  Scenario: Errors that can be retried are retried
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Retry": [
                      "ErrorEquals": ["States.Timeout"]
                  ]
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
      """
    And the resource "Lambda" will be called with any parameters fail with error "States.Timeout"
    When the state machine executes
    Then the next state is "FirstState"

  Scenario: Retry for all errors will retry when any error is thrown
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Retry": [
                      "ErrorEquals": ["States.ALL"]
                  ]
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
      """
    And the resource "Lambda" will be called with any parameters fail with error "States.Timeout"
    When the state machine executes
    Then the next state is "FirstState"


  Scenario: Errors that can't be retried fail the execution
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Retry": [
                      "ErrorEquals": ["States.Other"]
                  ]
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
      """
    And the resource "Lambda" will be called with any parameters fail with error "States.Timeout"
    When the state machine executes
    Then the execution ended
    And the execution failed
