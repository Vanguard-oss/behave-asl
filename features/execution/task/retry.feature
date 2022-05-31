Feature: The Task can retry a failed state

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

  Scenario Outline: A Retry will match an error
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
                        "ErrorEquals": ["<matcher>"]
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
    And the resource "Lambda" will be called with any parameters and fail with error "<thrown>"
    When the state machine executes
    Then the next state is "FirstState"
    And the context path "$.State.RetryCount" matches "1"

    Examples: States.ALL
      | matcher    | thrown                    |
      | States.ALL | States.DataLimitExceeded  |
      | States.ALL | States.Permissions        |
      | States.ALL | States.TaskFailed         |
      | States.ALL | States.Timeout            |
      | States.ALL | Lambda.ServiceException   |
      | States.ALL | Lambda.SdkClientException |

    Examples: States.TaskFailed
      | matcher           | thrown                    |
      | States.TaskFailed | States.DataLimitExceeded  |
      | States.TaskFailed | States.Permissions        |
      | States.TaskFailed | States.TaskFailed         |
      | States.TaskFailed | States.TaskFailed         |
      | States.TaskFailed | Lambda.ServiceException   |
      | States.TaskFailed | Lambda.SdkClientException |

    Examples: Exact matches
      | matcher                   | thrown                    |
      | States.DataLimitExceeded  | States.DataLimitExceeded  |
      | Lambda.ServiceException   | Lambda.ServiceException   |
      | Lambda.SdkClientException | Lambda.SdkClientException |

  Scenario Outline: Executions will fail if they don't match
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
                        "ErrorEquals": ["<matcher>"]
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
    And the resource "Lambda" will be called with any parameters and fail with error "<thrown>"
    When the state machine executes
    Then the execution ended
    And the execution failed

    Examples:
      | matcher                  | thrown             |
      | States.TaskFailed        | States.Timeout     |
      | States.TaskFailed        | States.Runtime     |
      | States.ALL               | States.Runtime     |
      | States.DataLimitExceeded | States.Permissions |
