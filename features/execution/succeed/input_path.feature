Feature: The Succeed type can filter input by using InputPath

  Scenario: The Succeed type can use '$' in the InputPath to copy everything
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Succeed",
                  "InputPath": "$"
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Existing": "Value"
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the execution ended
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Succeed type can use an InputPath to get a subset of the input
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Succeed",
                  "InputPath": "$.Map"
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Map": {
              "Existing": "Value"
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the execution ended
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"
