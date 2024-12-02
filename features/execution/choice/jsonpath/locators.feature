Feature: The Choice state type supports complex path operators

  Scenario Outline: The Choice type supports nested operators for both Variable and Path
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.first.thing",
                          "BooleanEqualsPath": "$.second.mybool",
                          "Next": "MatchState"
                      }
                  ],
                  "Default": "DefaultState"
              },
              "MatchState": {
                  "Type": "Pass",
                  "End": true
              },
              "DefaultState": {
                  "Type": "Pass",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "first": {
              "thing": <value_1>
          },
          "second": {
              "mybool": <value_2>
          }

      }
      """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1      | value_2 | matched_state |
      | true         | true    | MatchState    |
      | false        | false   | MatchState    |
      | true         | false   | DefaultState  |
      | false        | true    | DefaultState  |
      | "not_a_bool" | false   | DefaultState  |
      | "true"       | true    | DefaultState  |

  Scenario Outline: The Choice type supports json arrays
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Variable": "$.first.thing",
                          "BooleanEqualsPath": "$.second.mybool",
                          "Next": "MatchState"
                      }
                  ],
                  "Default": "DefaultState"
              },
              "MatchState": {
                  "Type": "Pass",
                  "End": true
              },
              "DefaultState": {
                  "Type": "Pass",
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "first": {
              "thing": <value_1>
          },
          "second": {
              "mybool": <value_2>
          }

      }
      """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1      | value_2 | matched_state |
      | true         | true    | MatchState    |
      | false        | false   | MatchState    |
      | true         | false   | DefaultState  |
      | false        | true    | DefaultState  |
      | "not_a_bool" | false   | DefaultState  |
      | "true"       | true    | DefaultState  |
