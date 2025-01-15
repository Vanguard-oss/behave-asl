Feature: The Parallel type can filter results by using ResultSelector

  Scenario: The Parallel type can use ResultSelector
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
            "OutputPath": "$",
            "ResultPath": "$.parallel",
            "ResultSelector": {
              "Fake": "Address",
              "Real.$": "$"
            },
            "End": true,
            "Branches": [
              {
                "StartAt": "LookupAddress",
                "States": {
                  "LookupAddress": {
                    "Type": "Pass",
                    "End": true
                  }
                }
              },
              {
                "StartAt": "LookupPhone",
                "States": {
                  "LookupPhone": {
                    "Type": "Pass",
                    "End": true
                  }
                }
              }
            ]
          }
        }
      }
      """
    And the execution input is
      """
      {
        "Hello": "There"
      }
      """
    And branch 0 will return
      """
      "123 Unit Test Street"
      """
    And branch 1 will return
      """
      "8675309"
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the step result data path "$.parallel.Fake" is a string
    And the step result data path "$.parallel.Fake" matches "Address"
    And the step result data path "$.parallel.Real" is a list
    And the step result data path "$.parallel.Real" contains "8675309"
    And the step result data path "$.parallel.Real" contains "123 Unit Test Street"
    And the step result data path "$.Hello" is a string
    And the step result data path "$.Hello" matches "There"

  Scenario: The Parallel ResultSelector can pull data from the Context object
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
            "OutputPath": "$",
            "ResultPath": "$.parallel",
            "ResultSelector": {
              "Eid.$": "$$.Execution.Id",
              "Real.$": "$"
            },
            "End": true,
            "Branches": [
              {
                "StartAt": "LookupAddress",
                "States": {
                  "LookupAddress": {
                    "Type": "Pass",
                    "End": true
                  }
                }
              },
              {
                "StartAt": "LookupPhone",
                "States": {
                  "LookupPhone": {
                    "Type": "Pass",
                    "End": true
                  }
                }
              }
            ]
          }
        }
      }
      """
    And the execution input is
      """
      {
        "Hello": "There"
      }
      """
    And branch 0 will return
      """
      "123 Unit Test Street"
      """
    And branch 1 will return
      """
      "8675309"
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the step result data path "$.parallel.Real" is a list
    And the step result data path "$.parallel.Real" contains "8675309"
    And the step result data path "$.parallel.Real" contains "123 Unit Test Street"
    And the step result data path "$.Hello" is a string
    And the step result data path "$.Hello" matches "There"
    And the step result data path "$.parallel.Eid" is a string
    And the step result data path "$.parallel.Eid" matches "123"
