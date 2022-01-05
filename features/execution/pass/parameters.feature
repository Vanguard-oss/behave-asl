Feature: The Pass type can have parameters set

  Scenario: The Pass type can set a hard coded parameter
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Parameters": {
                    "Static": "Value"
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
    And the step result data path "$.output.Static" is a string
    And the step result data path "$.output.Static" matches "Value"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Pass type can set a parameter that is a JsonPath selector of the input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Parameters": {
                    "Param.$": "$.Existing"
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
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "Value"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Pass type can set a parameter that looks like a JsonPath selector of the input
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Parameters": {
                    "Param": "$.Existing"
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
    And the step result data path "$.output.Param" is a string
    And the step result data path "$.output.Param" matches "$.Existing"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Pass type can have both Parameters and Result set, but Result wins
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState",
                "Parameters": {
                    "Static": "Value"
                },
                "Result": {
                    "Key": "Something"
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
    And the step result data path "$.output.Static" does not exist
    And the step result data path "$.output.Key" is a string
    And the step result data path "$.output.Key" matches "Something"
    And the step result data path "$.Existing" is a string
    And the step result data path "$.Existing" matches "Value"

  Scenario: The Pass type can have a nested json path expression
    Given a state machine defined by:
    """
    {
    "StartAt": "FirstState",
    "States": {
        "FirstState": {
            "Type": "Pass",
            "Next": "EndState",
            "Parameters": {
                "OutputDetails": {
                    "colorData": {
                        "color.$": "$.product.details.color"
                    },
                    "size.$": "$.product.details.size",
                    "staticValue": "foo"
                }
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
    "product": {
        "details": {
            "color": "blue",
            "size": "small",
            "material": "cotton"
        }
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.output.OutputDetails.colorData.color" is a string
    And the step result data path "$.output.OutputDetails.colorData.color" matches "blue"
    And the step result data path "$.output.OutputDetails.size" is a string
    And the step result data path "$.output.OutputDetails.size" matches "small"
    And the step result data path "$.output.OutputDetails.staticValue" is a string
    And the step result data path "$.output.OutputDetails.staticValue" matches "foo"
    And the step result data path "$.product.details.color" matches "blue"
