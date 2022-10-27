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

  Scenario: The Pass type can get an item from an array
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayGetItem($.Input, 3)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input": [5,6,7,8,9]
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data path "Param" matches "8"

  Scenario: Execution fails if you try to get an item that doesn't exist
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayGetItem($.Input, 10)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input": [5,6,7,8,9]
      }
      """
    When the state machine executes
    Then the execution failed

  Scenario Outline: ArrayRange is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayRange(<a>, <b>, <c>)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And  the step result data is
      """
      {
        "Param": <result>
      }
      """

    Examples: Array Ranges
      | a    | b     | c    | result         |
      | 1    | 9     | 2    | [1,3,5,7,9]    |
      | 1    | 9     | 5    | [1,6,9]        |
      | 1.1  | 9     | 2    | [1,3,5,7,9]    |

  Scenario: ArrayRange cannot return more than 1000 items
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayRange(1, 2000, 1)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution failed

  Scenario Outline: ArrayLength is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayLength($.Input)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input": <input>
      }
      """
    When the state machine executes
    Then the execution succeeded
    And  the step result data is
      """
      {
        "Param": <length>
      }
      """

    Examples: Test Cases
      | input         | length |
      | []            | 0      |
      | [1]           | 1      |
      | [1,2,3,4]     | 4      |


  Scenario Outline: ArrayUnique is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.ArrayUnique($.Input)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input": <input>
      }
      """
    When the state machine executes
    Then the execution succeeded
    And  the step result data is
      """
      {
        "Param": <result>
      }
      """

    Examples: Arrays
      | input         | result         |
      | []            | []             |
      | [1,2,3]       | [1,2,3]        |
      | [1,1,2,2,3,3] | [1,2,3]        |
      | [1,2,3,1,2,3] | [1,2,3]        |
      | [1,"1",1.0]   | [1,"1",1.0]    |
