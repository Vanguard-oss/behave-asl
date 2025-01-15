Feature: The Task type can have arguments set

  Scenario: The Task type can set a hard coded arguments
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Arguments": {
                      "Static": "Value"
                  }
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
          "Existing": "Value"
      }
      """
    And the resource "Lambda" will be called with:
      """
      {
          "Static": "Value"
      }
      """
    And the resource "Lambda" will return:
      """
      {
          "StaticResponse": "Value"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data is:
      """
      {
          "StaticResponse": "Value"
      }
      """

  Scenario: The Task type can set a argument that is a JSONata query of the input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Arguments": {
                      "Param": "{% $states.input.Existing %}"
                  }
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
          "Existing": "Value"
      }
      """
    And the resource "Lambda" will be called with:
      """
      {
          "Param": "Value"
      }
      """
    And the resource "Lambda" will return:
      """
      {
          "Param": "Value"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.Param" is a string
    And the step result data path "$.Param" matches "Value"


  Scenario: The Task type can set a hard coded parameter using a custom role
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Credentials": {
                      "RoleArn": "arn:aws:iam::123456789012:role/MyRole"
                  },
                  "Arguments": {
                      "Static": "Value"
                  }
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
          "Existing": "Value"
      }
      """
    And the resource "Lambda" will be called with role "arn:aws:iam::123456789012:role/MyRole" and parameters:
      """
      {
          "Static": "Value"
      }
      """
    And the resource "Lambda" will return:
      """
      {
          "StaticResponse": "Value"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data is:
      """
      {
          "StaticResponse": "Value"
      }
      """