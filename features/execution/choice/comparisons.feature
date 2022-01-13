Feature: Choice Rules and comparisons are supported by the Choice state type (Except for And/Not/Or)
# https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html#amazon-states-language-choice-state-rules

    Scenario: The Choice type supports the BooleanEquals operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the BooleanEqualsPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the IsBoolean operator
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
                                "BooleanEquals": true,
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
                "thing": true
            }
            """
            When the state machine executes
            Then the next state is "EndState"
            When the state machine executes
            Then the execution ended
            And the execution succeeded

    Scenario: The Choice type supports the IsNull operator
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
                                "BooleanEquals": true,
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
                "thing": true
            }
            """
            When the state machine executes
            Then the next state is "EndState"
            When the state machine executes
            Then the execution ended
            And the execution succeeded

    Scenario: The Choice type supports the IsPresent operator
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
                                "BooleanEquals": true,
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
                "thing": true
            }
            """
            When the state machine executes
            Then the next state is "EndState"
            When the state machine executes
            Then the execution ended
            And the execution succeeded

    Scenario: The Choice type supports the IsString operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the IsTimestamp operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the NumericEquals operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the NumericEqualsPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the NumericGreaterThan operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the NumericGreaterThanPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the NumericLessThan operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the NumericLessThanPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the StringEquals operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: Timestamp fields can be compared as strings
    #However, because timestamp fields are logically strings, it's possible that a field considered to be a timestamp can be matched by a StringEquals comparator.
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the StringEqualsPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the StringGreaterThan operator
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
                                "BooleanEquals": true,
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
                "thing": true
            }
            """
            When the state machine executes
            Then the next state is "EndState"
            When the state machine executes
            Then the execution ended
            And the execution succeeded
    
    Scenario: The Choice type supports the StringGreaterThanPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the StringLessThan operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the StringLessThanPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the StringMatches operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampEquals operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampEqualsPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampGreaterThan operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampGreaterThanPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampGreaterThanEquals operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampGreatherThanEqualsPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampLessThan operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampLessThanPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampLessThanEquals operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded

    Scenario: The Choice type supports the TimestampLessThanEqualsPath operator
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
                            "BooleanEquals": true,
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
            "thing": true
        }
        """
        When the state machine executes
        Then the next state is "EndState"
        When the state machine executes
        Then the execution ended
        And the execution succeeded