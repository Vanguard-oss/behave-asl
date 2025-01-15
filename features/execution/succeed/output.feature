Feature: The Succeed type can filter results by using Output

  Scenario: The Succeed type can use '$' in the OutputPath to copy everything
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Succeed",
                  "QueryLanguage": "JSONata",
                  "Output": {
                    "A": "B"
                  }
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
    And the step result data path "$.A" is a string
    And the step result data path "$.A" matches "B"