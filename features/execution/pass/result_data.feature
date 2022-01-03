Feature: The Pass type can set result data

  Scenario: The Pass type can add values to a path within the input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Result": {
                    "StringField": "ABC",
                    "IntField": 123
                },
                "ResultPath": "$.output"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
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
    Then the next state is "EndState"
    And the step result data path "$.output.StringField" is a string
    And the step result data path "$.output.StringField" matches "ABC"
    And the step result data path "$.output.IntField" is an int
    And the step result data path "$.output.IntField" matches "123"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Pass type can set a single String result
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Result": "ABC"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
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
    Then the next state is "EndState"
    And the step result data path "$" is a string
    And the step result data path "$" matches "ABC"

  Scenario: The Pass type can add values to the root of the input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Result": {
                    "StringField": "ABC",
                    "IntField": 123
                }
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
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
    Then the next state is "EndState"
    And the step result data path "$.StringField" is a string
    And the step result data path "$.StringField" matches "ABC"
    And the step result data path "$.IntField" is an int
    And the step result data path "$.IntField" matches "123"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"
