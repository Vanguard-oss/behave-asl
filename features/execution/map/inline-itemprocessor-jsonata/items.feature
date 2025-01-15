Feature: The Map state supports Items with JSONata

  Scenario: The Map type can use Items
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "Items": "{% $states.input.root %}",
                  "ItemProcessor": {
                    "Validate": {
                        "Type": "Pass",
                        "QueryLanguage": "JSONata",
                        "Output": {
                            "A": "B"
                        },
                        "End": true
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
      {"root": ["1","2","3"]}
      """
    And for input "A", the state "FirstState" will be called with:
      """
      1
      """
    And for input "A", the state "FirstState" will return:
      """
      blue
      """
    And for input "B", the state "FirstState" will be called with:
      """
      2
      """
    And for input "B", the state "FirstState" will return:
      """
      green
      """
    And for input "C", the state "FirstState" will be called with:
      """
      3
      """
    And for input "C", the state "FirstState" will return JSON:
      """
      {"color": "red"}
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the JSON output of "FirstState" is
      """
      [
        "blue",
        "green",
        {"color": "red"}
      ]
      """

  Scenario: The Map type can use Items and ItemSelector
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "QueryLanguage": "JSONata",
          "States": {
              "FirstState": {
                  "Type": "Map",
                  "Items": "{% $states.input.root %}",
                  "ItemSelector": {
                      "C": "D",
                      "E": "{% $states.context.Map.Item.Value %}"
                  },
                  "ItemProcessor": {
                    "Validate": {
                        "Type": "Pass",
                        "QueryLanguage": "JSONata",
                        "Output": {
                            "A": "B"
                        },
                        "End": true
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
      {"root": ["1","2","3"]}
      """
    And for input "A", the state "FirstState" will be called with:
      """
      {
          "C": "D",
          "E": "1"
      }
      """
    And for input "A", the state "FirstState" will return:
      """
      blue
      """
    And for input "B", the state "FirstState" will be called with:
      """
      {
          "C": "D",
          "E": "2"
      }
      """
    And for input "B", the state "FirstState" will return:
      """
      green
      """
    And for input "C", the state "FirstState" will be called with:
      """
      {
          "C": "D",
          "E": "3"
      }
      """
    And for input "C", the state "FirstState" will return JSON:
      """
      {"color": "red"}
      """
    And the state "FirstState" will return "unknown" when invoked with any unknown parameters
    When the state machine executes
    Then the JSON output of "FirstState" is
      """
      [
        "blue",
        "green",
        {"color": "red"}
      ]
      """
