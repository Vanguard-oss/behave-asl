Feature: Math support

  Scenario Outline: States.MathAdd is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.MathAdd(<a>, <b>)"
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

    Examples: Math Problems
      | a   | b    | output |
      | 0   | 0    | 0      |
      | 1   | 2    | 3      |
      | -1  | 1    | 0      |
      | 1   | -2   | -1     |
      | 1.2 | -2.5 | -1.3   |

  Scenario Outline: States.MathRandom is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.MathRandom(<a>, <b>)"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    
    Examples: Math Problems
      | a   | b    |
      | 1   | 5    |
      | 10  | 50   |
