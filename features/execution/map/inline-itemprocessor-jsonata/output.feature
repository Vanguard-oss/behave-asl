Feature: The Map state type can set an Output

  Scenario: The Map type can set the next state
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "ItemProcessor": {
                      "StartAt": "SubState",
                      "ProcessorConfig": {
                          "Mode":"INLINE"
                      },
                      "States": {
                          "SubState": {
                              "Type": "Pass",
                              "End": true
                          }
                      }
                  },
                  "Next": "EndState",
                  "Output": {
                    "A": "B"
                  }
              },
              "EndState": {
                  "Type": "Pass",
                  "End": true
              }
          }
      }
      """
    And the execution input is:
      """
      [
          {
              "who": "bob"
          },
          {
              "who": "meg"
          },
          {
              "who": "joe"
          }
      ]
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the next state is "EndState"
    Then the JSON output of "FirstState" is
      """
      {
        "A": "B"
      }
      """