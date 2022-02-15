Feature: The Parallel type can filter results by using OutputPath

  Scenario: The Parallel type can use "$" in the OutputPath to copy everything
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
    And the step result data path "$.parallel" is a list
    And the step result data path "$.parallel" contains "8675309"
    And the step result data path "$.parallel" contains "123 Unit Test Street"
    And the step result data path "$.Hello" is a string
    And the step result data path "$.Hello" matches "There"

  Scenario: The Parallel type can use "$.subfield" in the OutputPath
   Given a state machine defined by:
    """
    {
      "Comment": "Parallel Example.",
      "StartAt": "LookupCustomerInfo",
      "States": {
        "LookupCustomerInfo": {
          "Type": "Parallel",
          "OutputPath": "$.Phonebook",
          "ResultPath": "$.Phonebook.parallel",
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
      "Hello": "There",
      "Phonebook": {
        "My": "Number"
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
    And the step result data path "$.parallel" is a list
    And the step result data path "$.parallel" contains "8675309"
    And the step result data path "$.parallel" contains "123 Unit Test Street"
    And the step result data path "$.My" is a string
    And the step result data path "$.My" matches "Number"