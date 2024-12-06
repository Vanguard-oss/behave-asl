Feature: The Map state type can customize the MaxConcurrency using JSONata

  Scenario: The Map type can set the MaxConcurrency
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "MaxConcurrency": "{% 2 %}",
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
                  "Next": "EndState"
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
    And the states "MaxConcurrency" field was "2"