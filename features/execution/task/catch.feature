Feature: The Task can catch an error and send to another state

  Scenario Outline: Errors that can be caught are caught
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Catch": [
                      {
                        "ErrorEquals": ["<matcher>"],
                        "Next": "ErrorState"
                      }
                  ]
              },
              "ErrorState": {
                "Type": "Pass",
                "Next": "EndState"
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
    Then the next state is "ErrorState"
    And the step result data path "$.Cause" is a string

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

  Scenario Outline: Errors that can't be caught fail the execution
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Catch": [
                      {
                        "ErrorEquals": ["<matcher>"],
                        "Next": "ErrorState"
                      }
                  ]
              },
              "ErrorState": {
                "Type": "Pass",
                "Next": "EndState"
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

  Scenario Outline: Errors that can be caught and not retried are caught
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
                        "ErrorEquals": ["<skip>"],
                        "Next": "ErrorState"
                      }
                  ],
                  "Catch": [
                      {
                        "ErrorEquals": ["<matcher>"],
                        "Next": "ErrorState"
                      }
                  ]
              },
              "ErrorState": {
                "Type": "Pass",
                "Next": "EndState"
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
    Then the next state is "ErrorState"

    Examples:
      | skip               | matcher                  | thrown                   |
      | States.Permissions | States.DataLimitExceeded | States.DataLimitExceeded |
      | States.TaskFailed  | States.ALL               | States.Timeout           |

  Scenario: The Task Catch can have a custom ResultPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Catch": [
                      {
                        "ErrorEquals": ["States.Permissions"],
                        "Next": "ErrorState",
                        "ResultPath": "$.MyError"
                      }
                  ]
              },
              "ErrorState": {
                "Type": "Pass",
                "Next": "EndState"
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "MyKey": "MyValue"
      }
      """
    And the resource "Lambda" will be called with any parameters and fail with error "States.Permissions"
    When the state machine executes
    Then the step result data path "$.MyError.Cause" is a string

  Scenario: The Task Catch can work with Credentials
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Credentials": {
                      "RoleArn": "arn:aws:iam::123456789012:role/MyRole"
                  },
                  "Next": "EndState",
                  "Catch": [
                      {
                        "ErrorEquals": ["States.Permissions"],
                        "Next": "ErrorState",
                        "ResultPath": "$.MyError"
                      }
                  ]
              },
              "ErrorState": {
                "Type": "Pass",
                "Next": "EndState"
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "MyKey": "MyValue"
      }
      """
    And the resource "Lambda" will be called with any parameters, with role "arn:aws:iam::123456789012:role/MyRole" and fail with error "States.Permissions"
    When the state machine executes
    Then the step result data path "$.MyError.Cause" is a string
