Feature: The Pass type can filter results by using OutputPath

  Scenario: The Pass type can use '$' in the OutputPath to copy everything
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Result": {
                      "StringField": "ABC",
                      "IntField": 123
                  },
                  "ResultPath": "$.output",
                  "OutputPath": "$"
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
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.StringField" is a string
    And the step result data path "$.output.StringField" matches "ABC"
    And the step result data path "$.output.IntField" is an int
    And the step result data path "$.output.IntField" matches "123"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: When the ResultPath and OutputPath match, the Result replaces the State Input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Result": {
                      "StringField": "ABC",
                      "IntField": 123
                  },
                  "ResultPath": "$.output",
                  "OutputPath": "$.output"
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
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.StringField" is a string
    And the step result data path "$.StringField" matches "ABC"
    And the step result data path "$.IntField" is an int
    And the step result data path "$.IntField" matches "123"
    And the step result data path "$.Existing" does not exist

  Scenario: The OutputPath can use values from the Context object
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Result": {
                      "StringField": "ABC",
                      "IntField": 123
                  },
                  "OutputPath": "$$.Execution.Input.Existing"
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              }
          }
      }
      """
    And the execution input is:
      """
      {
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the step result data is:
      """
      "Value"
      """

  Scenario: OutputPath cannot be used with JSONata
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Next": "EndState",
                  "Result": {
                      "StringField": "ABC",
                      "IntField": 123
                  },
                  "ResultPath": "$.output",
                  "OutputPath": "$"
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
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the state machine failed to compile