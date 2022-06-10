Feature: The Parallel type can filter input by using InputPath

  Scenario: The Parallel type can end the execution
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
            "InputPath": "$.Foo",
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
    And the step result data path "$" is a list
    And the step result data is
      """
      ["123 Unit Test Street", {"number": 8675309}]
      """
    And branches were called with
      """
      "Bar"
      """
