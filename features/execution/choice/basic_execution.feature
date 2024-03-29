Feature: The Choice state type is supported

  Scenario: The Choice type can set the next state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.thing",
                          "StringEquals": "blue",
                          "Next": "EndState"
                      }
                  ]
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
          "thing": "blue"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Choice type can use a default state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.thing",
                          "StringEquals": "blue",
                          "Next": "EndState"
                      }
                  ],
                  "Default": "EndState"
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
          "thing": "red"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  # The Choice state type cannot have End: true, so it cannot end the execution itself
  Scenario: The Choice type chooses the correct next step given multiple Choices
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.thing",
                          "StringEquals": "blue",
                          "Next": "BlueState"
                      },
                      {
                          "Variable": "$.thing",
                          "StringEquals": "red",
                          "Next": "RedState"
                      }
                  ],
                  "Default": "EndState"
              },
              "BlueState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              },
              "RedState": {
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
          "thing": "red"
      }
      """
    When the state machine executes
    Then the next state is "RedState"

  Scenario: The Choice type fails if there is no matching input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.thing",
                          "StringEquals": "blue",
                          "Next": "EndState"
                      }
                  ]
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
          "thing": "red"
      }
      """
    When the state machine executes
    Then the execution failed

  Scenario: The first matching Choice rule is returned if more than one match
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.thing",
                          "BooleanEquals": true,
                          "Next": "EndState"
                      },
                      {
                          "Variable": "$.thing",
                          "IsPresent": true,
                          "Next": "StateThatWontBeExecuted"
                      }
                  ]
              },
              "EndState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
              },
              "StateThatWontBeExecuted": {
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
          "thing": true
      }
      """
    When the state machine executes
    Then the next state is "EndState"
