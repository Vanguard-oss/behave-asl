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
                      {
                        "ErrorEquals": ["States.Timeout"]
                      }
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
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    When the state machine executes
    Then the next state is "FirstState"
    And the context path "$.State.RetryCount" matches "1"

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
                      {
                        "ErrorEquals": ["States.ALL"]
                      }
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
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    When the state machine executes
    Then the next state is "FirstState"
    And the context path "$.State.RetryCount" matches "1"

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
                      {
                        "ErrorEquals": ["States.Other"]
                      }
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
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    When the state machine executes
    Then the execution ended
    And the execution failed
    And the context path "$.State.RetryCount" matches "0"

  Scenario: A second retry can occur
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
                      {
                        "MaxAttempts": 3,
                        "ErrorEquals": ["States.Timeout"]
                      }
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
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    And the retry count is "1"
    When the state machine executes
    Then the next state is "FirstState"
    And the context path "$.State.RetryCount" matches "2"

  Scenario: The system won't exceed the max retries
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
                      {
                        "MaxAttempts": 2,
                        "ErrorEquals": ["States.Timeout"]
                      }
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
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    And the retry count is "1"
    When the state machine executes
    Then the execution ended
    And the execution failed

  Scenario: The state machine will go to the next step after a successful retry
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
                      {
                        "MaxAttempts": 2,
                        "ErrorEquals": ["States.Timeout"]
                      }
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
    And the resource "Lambda" will be called with any parameters and return:
      """
      {
      }
      """
    And the retry count is "1"
    When the state machine executes
    Then the next state is "EndState"
