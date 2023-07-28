Feature: The Task state supports the Credentials field
  As a developer, I would like to validate the Task state can use the Credentials field
  
  Scenario: The Task can use static credentials
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
    And the resource "Lambda" will be called with any parameters using role "arn:aws:iam::123456789012:role/MyRole" and return:
      """
      {
      }
      """
    When the state machine executes
    Then the next state is "EndState"

  Scenario: The Task can use JsonPath credentials
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Credentials": {
                      "RoleArn.$": "$.RoleArn"
                  },
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
    And the resource "Lambda" will be called with any parameters using role "arn:aws:iam::123456789012:role/MyRole" and return:
      """
      {
      }
      """
    And the current state data is:
      """
      {
          "RoleArn": "arn:aws:iam::123456789012:role/MyRole"
      }
      """
    When the state machine executes
    Then the next state is "EndState"