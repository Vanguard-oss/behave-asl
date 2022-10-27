Feature: String support

  Scenario Outline: States.Split is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.StringSplit(<input>, <splitter>)"
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
      | input   | splitter | output        |
      | '1,2,3' | ','      | ["1","2","3"] |
