Feature: Base64 encoding and decoding

  Scenario Outline: Encode Base64
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.Base64Encode(<input>)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": <output>
      }
      """

    Examples: Strings
      | input         | output          |
      | ''            | ""              |
      | 'ABC'         | "QUJD"          |

  Scenario Outline: Decode Base64
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.Base64Decode(<input>)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": <output>
      }
      """

    Examples: Strings
      | input         | output          |
      | ''            | ""              |
      | 'QUJD'         | "ABC"          |
