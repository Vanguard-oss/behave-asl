Feature: The Parallel state type is supported
  As a developer, I would like to validate the Parallel state type.
  
  These scenarios are a basic regression test that a minimal Parallel state can be
  executed.  Only the minimum required fields are used.

  Scenario: The Parallel type can end the execution
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
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
    And for input "A", the state "LookupAddress" will be called with
      """
      {
        "StartAt": "LookupAddress",
        "States": {
          "LookupAddress": {
            "Type": "Pass",
            "End": true
          }
        }
      }
      """
    And for input "A", the state "LookupAddress" will return
      """
      123 Unit Test Street
      """
    And for input "B", the state "LookupPhone" will be called with
      """
      {
        "StartAt": "LookupPhone",
        "States": {
          "LookupPhone": {
            "Type": "Pass",
            "End": true
          }
        }
      }
      """
    And for input "B", the state "LookupPhone" will return JSON:
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

  Scenario: The Parallel type can set the next state
    Given a state machine defined by:
      """
      {
        "Comment": "Parallel Example.",
        "StartAt": "LookupCustomerInfo",
        "States": {
          "LookupCustomerInfo": {
            "Type": "Parallel",
            "Next": "EndState",
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
          },
          "EndState": {
            "Type": "Pass",
            "End": true
          }
        }
      }
      """
    And for input "A", the state "LookupAddress" will be called with
      """
      {
        "StartAt": "LookupAddress",
        "States": {
          "LookupAddress": {
            "Type": "Pass",
            "End": true
          }
        }
      }
      """
    And for input "A", the state "LookupAddress" will return
      """
      123 Unit Test Street
      """
    And for input "B", the state "LookupPhone" will be called with
      """
      {
        "StartAt": "LookupPhone",
        "States": {
          "LookupPhone": {
            "Type": "Pass",
            "End": true
          }
        }
      }
      """
    And for input "B", the state "LookupPhone" will return
      """
      8675309
      """
    When the state machine executes
    Then the next state is "EndState"
