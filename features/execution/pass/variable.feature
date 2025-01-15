Feature: The Pass state supports writing variables

  Scenario: The Pass type can assign a variable using a constant
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

  Scenario: The Pass type can assign a variable using a JSONPath reading from the Parameters
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

  Scenario: The Pass type can assign a variable using a JSONata reading from the state input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "QueryLanguage": "JSONata",
                  "Assign": {
                    "Var2": "{% $states.input.Param1 %}"
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

  Scenario: The Pass type can assign a variable with JSONata as the default query language reading from the state input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Assign": {
                    "Var2": "{% $states.input.Param1 %}"
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


  Scenario: The Pass type can use a variable from a previous state using JSONata
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Output": {
                    "A": "{% $B %}"
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
    And the current variables are:
      """
      {
          "B": "C"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.A" matches "C"

  Scenario: The Pass type can use a variable from a previous state using JSONPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                    "MyParam.$": "$$MyVar"
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
    And the current variables are:
      """
      {
          "MyVar": "Value2"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.MyParam" matches "Value2"

  Scenario: The Pass type can use a variable path from a previous state using JSONPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                    "MyParam.$": "$$MyVar.Level2"
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
    And the current variables are:
      """
      {
          "MyVar": {
            "Level2": "Value2"
          }
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.MyParam" matches "Value2"

  Scenario: The Pass type can use a variable array from a previous state using JSONPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Parameters": {
                    "MyParam.$": "$$MyVar[0]"
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
    And the current variables are:
      """
      {
          "MyVar": ["Value2"],
          "MyVar2": ["Value2"]
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.MyParam" matches "Value2"