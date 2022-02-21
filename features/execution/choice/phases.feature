Feature: The Choice type supports Phases (InputPath, Parameters, and OutputPath)

  Scenario: The Choice type supports InputPath
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "InputPath": "$.dataset2",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringEquals": "red",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass",
                "End": true
            },
            "DefaultState": {
                "Type": "Pass",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "dataset1": {
            "thing": "blue"
        },
        "dataset2": {
            "thing": "red"
        }
    }
    """
    When the state machine executes
    Then the next state is "MatchState"

  Scenario: The Choice type supports Parameters
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Parameters": {
                    "product_details": {
                        "size.$": "$.product.details.size",
                        "quantity.$": "$.product.details.quantity",
                        "StaticValue": "foo"
                    }
                },
                "Choices": [
                    {
                        "Variable": "$.product_details.size",
                        "StringEquals": "small",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass",
                "End": true
            },
            "DefaultState": {
                "Type": "Pass",
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
                "material": "cotton",
                "quantity": 24
            },
            "availability": "in stock",
            "sku": "2317",
            "cost": "$23"
        }
    }
    """
    When the state machine executes
    Then the next state is "MatchState"
    And the step result data path "$.product_details.size" is a string
    And the step result data path "$.product_details.size" matches "small"
    And the step result data path "$.product_details.quantity" is an int
    And the step result data path "$.product_details.quantity" matches "24"
    And the step result data path "$.product_details.StaticValue" is a string
    And the step result data path "$.product_details.StaticValue" matches "foo"

  Scenario: The Choice type supports OutputPath
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "OutputPath": "$.product.details",
                "Choices": [
                    {
                        "Variable": "$.product.details.size",
                        "StringEquals": "small",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass",
                "End": true
            },
            "DefaultState": {
                "Type": "Pass",
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
                "material": "cotton",
                "quantity": 24
            },
            "availability": "in stock",
            "sku": "2317",
            "cost": "$23"
        }
    }
    """
    When the state machine executes
    Then the next state is "MatchState"
    And the step result data path "$.size" is a string
    And the step result data path "$.size" matches "small"
    And the step result data path "$.quantity" is an int
    And the step result data path "$.quantity" matches "24"
