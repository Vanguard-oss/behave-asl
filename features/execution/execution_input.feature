Feature: The Execution has it's own input data

  Scenario: When starting at the first state, the execution and state inputs match
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
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
        "Type": "Teapot",
        "Size": "Little"
    }
    """

  Scenario: When starting at the second state, the execution and state inputs are different
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "End": true
            }
        }
    }
    """
    And the state machine is current at the state "EndState"
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
        "Type": "Teapot",
        "Size": "Big"
    }
    """

  Scenario: When starting at the second state, the Pass params can pull from the execution input
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
                "Parameters": {
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
        "Size": "Little"
    }
    """
