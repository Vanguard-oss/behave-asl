Feature: Boolean Choice Rules are supported by the Choice state type (And/Not/Or)

  Scenario: The Choice type supports the And operator
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "And": [
                              {
                                  "Variable": "$.thing",
                                   "StringEquals": "blue"
                              },
                              {
                                  "Variable": "$.thing2",
                                   "StringEquals": "green"
                              }
                          ],
                          "Next": "EndState"
                      },
                      {
                          "Variable": "$.thing",
                          "StringEquals": "red",
                          "Next": "OtherState"
                      }
                  ]
              },
              "OtherState": {
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
          "thing": "blue",
          "thing2": "green"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Choice type supports the Or operator
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Or": [
                              {
                                  "Variable": "$.thing",
                                   "StringEquals": "blue"
                              },
                              {
                                  "Variable": "$.thing2",
                                   "StringEquals": "green"
                              }
                          ],
                          "Next": "EndState"
                      },
                      {
                          "Variable": "$.thing",
                          "StringEquals": "red",
                          "Next": "OtherState"
                      }
                  ]
              },
              "OtherState": {
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
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Choice type supports the Or operator
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Or": [
                              {
                                  "Variable": "$.thing",
                                   "StringEquals": "blue"
                              },
                              {
                                  "Variable": "$.thing2",
                                   "StringEquals": "green"
                              }
                          ],
                          "Next": "EndState"
                      },
                      {
                          "Variable": "$.thing",
                          "StringEquals": "red",
                          "Next": "OtherState"
                      }
                  ]
              },
              "OtherState": {
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
          "thing2": "green"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Choice type supports the Not operator
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Not": {
                              "Variable": "$.thing",
                              "StringEquals": "blue"
                          },
                          "Next": "EndState"
                      },
                      {
                          "Variable": "$.thing",
                          "StringEquals": "red",
                          "Next": "OtherState"
                      }
                  ]
              },
              "OtherState": {
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
          "thing": "green"
      }
      """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario Outline: Nested under a Not
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Choice",
                  "Choices": [
                      {
                          "Not": {
                              "<op>": [
                                  {
                                      "Variable": "$.thing",
                                      "StringEquals": "<color1>"
                                  },
                                  {
                                      "Variable": "$.thing2",
                                      "StringEquals": "<color2>"
                                  }
                              ]
                          },
                          "Next": "EndState"
                      }
                  ],
                  "Default": "OtherState"
              },
              "OtherState": {
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
          "thing": "<inputColor1>",
          "thing2": "<inputColor2>"
      }
      """
    When the state machine executes
    Then the next state is "<resultState>"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

    Examples: Examples
      | op  | color1 | color2 | inputColor1 | inputColor2 | resultState |
      | And | red    | blue   | red         | green       | EndState    |
      | And | red    | blue   | blue        | green       | EndState    |
      | And | red    | blue   | purple      | green       | EndState    |
      | And | red    | blue   | red         | blue        | OtherState  |
      | Or  | red    | blue   | red         | green       | OtherState  |
      | Or  | red    | blue   | blue        | green       | EndState    |
      | Or  | red    | blue   | red         | blue        | OtherState  |
      | Or  | red    | blue   | purple      | green       | EndState    |
