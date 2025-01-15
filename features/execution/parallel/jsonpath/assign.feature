Feature: The Parallel type can assign variables using JSONPath

  Scenario: The Parallel type can assign variables using JSONPath
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
            "End": true,
            "ResultPath": "$.Res",
            "Assign": {
                "res.$": "$"
            },
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
    And the current state data is
      """
      {
          "Foo": "Bar"
      }
      """
    And branch 0 will return
      """
      "123 Unit Test Street"
      """
    And branch 1 will return
      """
      {
        "number": 8675309
      }
      """
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the step result data is
      """
      {
          "Foo": "Bar",
          "Res": ["123 Unit Test Street", {"number": 8675309}]
      }
      """
    And branches were called with
      """
      {
          "Foo": "Bar"
      }
      """
    And the variable path "res[0]" matches "123 Unit Test Street"
    And the variable path "res[1].number" matches "8675309"
