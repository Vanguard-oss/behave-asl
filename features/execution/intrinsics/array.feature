Feature: Arrays can be parsed and changed

  Scenario: The Pass type can partion an array
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayPartition($.Input, 4)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input": [1,2,3,4,5,6,7,8,9]
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data path "Param" is a list
    And the step result data path "Param" has length "3"
    And  the step result data is
      """
      {
        "Param": [[1,2,3,4],[5,6,7,8],[9]]
      }
      """

  Scenario: The Pass type can partion an empty array
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayPartition($.Input, 4)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input": []
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data path "Param" is a list
    And the step result data path "Param" has length "0"

  Scenario Outline: The Pass type can check if an array contains a value
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayContains($.Haystack, $.Needle)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Needle": <needle>,
          "Haystack": <haystack>
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data path "Param" is <result>

    Examples: Static strings
      | needle    | haystack     | result |
      | "A"      | ["A"]         | true   |
      | "B"      | ["A"]         | false  |
      | "B"      | ["A", "B"]    | true   |
      | 1        | [1]           | true   |
      | 1        | ["1"]         | false  |
