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
    And the step result data is:
    """
    {
        "output": {
            "StringField": "ABC",
            "IntField": 123
        },
        "Existing": "Value"
    }
    """

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

  Scenario: The Pass type will replace the output by default
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
    And the step result data path "$.Existing" does not exist

  Scenario: The second state ResultData cannot pull from the execution input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "SecondState"
            },
            "SecondState": {
                "Type": "Pass",
                "Result": {
                    "Size.$": "$$.Execution.Input.Size"
                },
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "End": true
            }
        }
    }
    """
    And the state machine is current at the state "SecondState"
    And the current state data is:
    """
    {
        "Type": "Teapot",
        "Size": "Big"
    }
    """
    And the execution input is:
    """
    {
        "Type": "Teapot",
        "Size": "Little"
    }
    """
    When the state machine executes
    Then the step result data is:
    """
    {
        "Size.$": "$$.Execution.Input.Size"
    }
    """
