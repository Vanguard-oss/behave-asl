Feature: Choice Rules and comparisons that should not match values in the input/set to False are supported by the Choice state type (Except for And/Not/Or)

Scenario: The Choice type supports the BooleanEquals operator when it is false
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "BooleanEquals": false,
                        "Next": "EndState"
                    }
                ]
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
        "thing": false
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

Scenario: The Choice type supports the IsBoolean operator when it is false
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsBoolean": false,
                        "Next": "EndState"
                    }
                ]
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
        "thing": "notabool"
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

Scenario: The Choice type supports the IsNull operator when it is false
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsNull": false,
                        "Next": "EndState"
                    }
                ]
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
        "notathing": null
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    When the state machine executes
    Then the execution ended
    And the execution succeeded

