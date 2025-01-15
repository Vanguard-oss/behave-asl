Feature: Difference choices can assign different variables

  Scenario: A choice can assign a variable
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
                          "Next": "MatchState",
                          "Assign": {
                            "A": "B"
                          }
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
    And the variable path "A" matches "B"

  Scenario: A choice that isn't picked doesn't assign a variable
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "QueryLanguage": "JSONata",
                  "Default": "EndState",
                  "Choices": [
                      {
                          "Condition": "{% false %}",
                          "Next": "MatchState",
                          "Assign": {
                            "A": "B"
                          }
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
    Then the next state is "EndState"
    And the variable path "A" does not exist


  Scenario: The default choice can assign a variable when no choice is picked
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "QueryLanguage": "JSONata",
                  "Default": "EndState",
                  "Choices": [
                      {
                          "Condition": "{% false %}",
                          "Next": "MatchState"
                      }
                  ],
                  "Assign": {
                    "C": "D"
                  }
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
    Then the next state is "EndState"
    And the variable path "A" does not exist
    And the variable path "C" matches "D"


  Scenario: The default assignment doesn't happen when a choice is picked
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "QueryLanguage": "JSONata",
                  "Default": "EndState",
                  "Choices": [
                      {
                          "Condition": "{% true %}",
                          "Next": "MatchState",
                          "Assign": {
                            "A": "B"
                          }
                      }
                  ],
                  "Assign": {
                    "C": "D"
                  }
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
    And the variable path "A" matches "B"
    And the variable path "C" does not exist
