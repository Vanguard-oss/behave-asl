Feature: Perform sanity checks against the parser

  Scenario: State with Type=Pass
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
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "PassState" object

  Scenario: State with Type=Task
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "arn:aws:lambda:us-east-1:123456789012:function:sqsconnector-SeedingFunction-T3U43VYDU5OQ",
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
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "TaskState" object

  Scenario: State with Type=Choice
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.value",
                        "NumericEquals": 0,
                        "Next": "FailState"
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
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "ChoiceState" object

  Scenario: State with Type=Wait
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Wait",
                "Seconds": 10,
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
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "WaitState" object

  Scenario: State with Type=Succeed
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Succeed"
            }
        }
    }
    """
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "SucceedState" object

  Scenario: State with Type=Fail
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Fail"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "FailState" object

  Scenario: State with Type=Parallel
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Parallel",
                "End": true,
                "Branches": [
                    {
                    "StartAt": "FirstParallelState",
                    "States": {
                        "FirstParallelState": {
                            "Type": "Pass",
                            "End": true
                            }
                        }
                    },
                    {
                        "StartAt": "SecondParallelState",
                        "States": {
                            "SecondParallelState": {
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
    When the parser runs
    Then a "StateMachineModel" is created
    And the "FirstState" step is a "ParallelState" object
