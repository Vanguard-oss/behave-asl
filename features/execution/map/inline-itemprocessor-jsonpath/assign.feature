Feature: The Map state type can assign variables using JSONPath

  Scenario: The Map type can set a variable using JSONPath
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "ItemProcessor": {
                      "StartAt": "SubState",
                      "States": {
                          "SubState": {
                              "Type": "Pass",
                              "End": true
                          }
                      }
                  },
                  "Next": "EndState",
                  "Assign": {
                    "res.$": "$"
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
    And the variable path "res[0]" matches "unknown"