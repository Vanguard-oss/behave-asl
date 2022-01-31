Feature: The States.Format intrinsic can be used with static strings

  Scenario: The Pass type can return static formatted data
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.Format('Hello {}', 'World')"
                },
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
    """
    {
        "Param": "Hello World"
    }
    """

  Scenario: The Pass type can return static formatted data from multiple arguments
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.Format('{} {}', 'Hello', 'World')"
                },
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
    """
    {
        "Param": "Hello World"
    }
    """

  Scenario: The Pass type can return static formatted data with a single quote in the value
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.Format('Hello {}', 'Wor\\'ld')"
                },
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
    """
    {
        "Param": "Hello Wor\\'ld"
    }
    """

  Scenario: The Pass type can return static formatted data with a double quote in the value
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.Format('Hello {}', 'Wor\"ld')"
                },
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
    """
    {
        "Param": "Hello Wor\"ld"
    }
    """

  Scenario: The Pass type can return static formatted data with a newline in the value
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Parameters": {
                    "Param.$": "States.Format('Hello {}', 'Wor\nld')"
                },
                "End": true
            }
        }
    }
    """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
    """
    {
        "Param": "Hello Wor\nld"
    }
    """
