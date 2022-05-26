Feature: The States.JsonToString intrinsic can be used with lookups

  Scenario: The Pass type can use States.StringToJson and States.JsonToString as inverses to each other for lists
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.StringToJson('[\"A\", \"B\", \"C\"]')"
                  },
                  "Next": "SecondState"
              },
              "SecondState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonToString($.Param)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": "[\"A\",\"B\",\"C\"]"
      }
      """

  Scenario: The Pass type can use States.StringToJson and States.JsonToString as inverses to each other for maps
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.StringToJson('{\"A\": \"B\"}')"
                  },
                  "Next": "SecondState"
              },
              "SecondState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonToString($.Param)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": "{\"A\":\"B\"}"
      }
      """
