Feature: The Parallel type can change the output using JSONata

  Scenario: The Parallel type can change the output using JSONata
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "QueryLanguage": "JSONata",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
            "End": true,
            "Assign": {
                "res": "{% $states.result %}"
            },
            "Output": {
                "Key": "Value"
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
        "Key": "Value"
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
