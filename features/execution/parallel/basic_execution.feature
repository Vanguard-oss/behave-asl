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
    And the state "LookupAddress" will return "123 Unit Test Street" for input
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
    And the state "LookupPhone" will return "8675309" for input
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
    When the state machine executes
    Then the execution ended
    And the execution succeeded
    And the step result data path "$" is a list
    And the step result data path "$" contains "8675309"
    And the step result data path "$" contains "123 Unit Test Street"

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
    And the state "LookupAddress" will return "123 Unit Test Street" for input
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
    And the state "LookupPhone" will return "8675309" for input
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
    When the state machine executes
    Then the next state is "EndState"
