Feature: The Map state type is supported using JSONata
  As a developer, I would like to validate the Map state type.
  
  These scenarios are a basic regression test that a minimal Map state can be
  executed.  Only the minimum required fields are used.

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

  Scenario: The Map type can end the execution
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
    And the state machine is current at the state "FirstState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

  Scenario: The Map type can use a map mock
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "ItemProcessor": {
                      "StartAt": "Validate",
                      "ProcessorConfig": {
                          "Mode":"INLINE"
                      },
                      "States": {
                          "Validate": {
                              "Type": "Task",
                              "Resource": "arn:aws:lambda:us-east-1:123456789012:function:ship-val",
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
        { "prod": "R31", "dest-code": 9511, "quantity": 1344 },
        { "prod": "S39", "dest-code": 9511, "quantity": 40 },
        { "prod": "R31", "dest-code": 9833, "quantity": 12 },
        { "prod": "R40", "dest-code": 9860, "quantity": 887 },
        { "prod": "R40", "dest-code": 9511, "quantity": 1220 },
        "yellow"
      ]
      """
    And for input "A", the state "FirstState" will be called with:
      """
      { "prod": "R31", "dest-code": 9511, "quantity": 1344 }
      """
    And for input "A", the state "FirstState" will return:
      """
      blue
      """
    And for input "B", the state "FirstState" will be called with:
      """
      { "prod": "S39", "dest-code": 9511, "quantity": 40 }
      """
    And for input "B", the state "FirstState" will return:
      """
      green
      """
    And for input "C", the state "FirstState" will be called with:
      """
      { "prod": "R31", "dest-code": 9833, "quantity": 12 }
      """
    And for input "C", the state "FirstState" will return:
      """
      red
      """
    And for input "D", the state "FirstState" will be called with:
      """
      yellow
      """
    And for input "D", the state "FirstState" will return:
      """
      orange
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the JSON output of "FirstState" is
      """
      [
        "blue",
        "green",
        "red",
        "unknown",
        "unknown",
        "orange"
      ]
      """

  Scenario: The Map type can set the max MaxConcurrency
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "MaxConcurrency": 2,
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
    And the state machine is current at the state "FirstState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the last state ran with a max of "2" concurrent executions