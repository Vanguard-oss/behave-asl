Feature: The Choice state type supports JSONata

  Scenario: The Choice type can set the next state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "QueryLanguage": "JSONata",
                  "Choices": [
                      {
                          "Condition": "{% true %}",
                          "Next": "MatchState"
                      }
                  ]
              },
              "MatchState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
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
    Then the next state is "MatchState"

  Scenario: The Choice type can use a default state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "QueryLanguage": "JSONata",
                  "Choices": [
                      {
                          "Condition": "{% false %}",
                          "Next": "MatchState"
                      }
                  ],
                  "Default": "EndState"
              },
              "MatchState": {
                  "Type": "Pass",
                  "Result": "end",
                  "End": true
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

