Feature: The Map state type can assign variables using JSONata

  Scenario: The Map type can assign a variable
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
                  "Assign": {
                    "A": "{% $states.result[0] %}"
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
    And the variable path "A" matches "unknown"
