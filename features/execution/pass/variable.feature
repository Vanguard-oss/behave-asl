Feature: The Pass state supports writing variables

  Scenario: The Pass type can assing a variable using a constant
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                      "Param": "Value1"
                  },
                  "Assign": {
                    "Var2": "Value2"
                  }
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the variable path "Var2" matches "Value2"

  Scenario: The Pass type can assing a variable using a JSONPath reading from the Parameters
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                      "Param": "Value1"
                  },
                  "Assign": {
                    "Var2.$": "$.Param"
                  }
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the variable path "Var2" matches "Value1"

  Scenario: The Pass type can assing a variable using a JSONata reading from the state input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                      "Param": "Value1"
                  },
                  "QueryLanguage": "JSONata",
                  "Assign": {
                    "Var2": "{% states.input.Param1 %}"
                  }
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Param1": "Value1"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the variable path "Var2" matches "Value1"

