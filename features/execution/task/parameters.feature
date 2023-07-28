Feature: The Task type can have parameters set

  Scenario: The Task type can set a hard coded parameter
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Parameters": {
                      "Static": "Value"
                  },
                  "ResultPath": "$.output"
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
          "output": {
              "StaticResponse": "Value"
          },
          "Existing": "Value"
      }
      """

  Scenario: The Task type can set a parameter that is a JsonPath selector of the input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Parameters": {
                      "Param.$": "$.Existing"
                  },
                  "ResultPath": "$.output"
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
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "Value"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Task type can set a parameter that looks like a JsonPath selector of the input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Parameters": {
                      "Param": "$.Existing"
                  },
                  "ResultPath": "$.output"
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
          "Param": "$.Existing"
      }
      """
    And the resource "Lambda" will return:
      """
      {
          "Param": "$.Existing"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "$.Existing"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"


  Scenario: The Task type can set a hard coded parameter using a custom role
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Next": "EndState",
                  "Resource": "Lambda",
                  "Credentials": {
                      "RoleArn": "arn:aws:iam::123456789012:role/MyRole"
                  },
                  "Parameters": {
                      "Static": "Value"
                  },
                  "ResultPath": "$.output"
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
          "output": {
              "StaticResponse": "Value"
          },
          "Existing": "Value"
      }
      """