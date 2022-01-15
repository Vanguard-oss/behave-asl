Feature: Choice Rules and comparisons that should match values in the input/are set to True are supported by the Choice state type (Except for And/Not/Or)

  # https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html#amazon-states-language-choice-state-rules
  Scenario Outline: The Choice type supports the BooleanEquals operator
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
                        "BooleanEquals": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass"
            },
            "DefaultState": {
                "Type": Pass
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | true       | true        | MatchState    |
      | false      | false       | MatchState    |
      | false      | true        | DefaultState  |
      | true       | false       | DefaultState  |
      | true       | "true"      | DefaultState  |

  Scenario Outline: The Choice type supports the BooleanEqualsPath operator
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
                        "BooleanEqualsPath": "$.mybool",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass"
            },
            "DefaultState": {
                "Type": "Pass"
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": <value_1>,
        "mybool": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1      | value_2 | matched_state |
      | true         | true    | MatchState    |
      | false        | false   | MatchState    |
      | true         | false   | DefaultState  |
      | false        | true    | DefaultState  |
      | "not_a_bool" | false   | DefaultState  |
      | "true"       | true    | DefaultState  |

  Scenario Outline: The Choice type supports the IsBoolean operator
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
                        "IsBoolean": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass"
            },
            "DefaultState": {
                "Type": "Pass"
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
    | value_1 | value_2 | matched_state |
    | true | true | MatchState |
    | true | false | MatchState |
    | false | true | DefaultState |
    | false | false | DefaultState |
    | false | "not_a_bool" | MatchState |
    | false | "true" | MatchState |

  Scenario Outline: The Choice type supports the IsNull operator
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
                        "IsNull": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the IsNumeric operator
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
                        "IsNumeric": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the IsPresent operator
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
                        "IsPresent": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the IsString operator
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
                        "IsString": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the IsTimestamp operator
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
                        "IsTimestamp": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the NumericEquals operator
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
                        "NumericEquals": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the NumericEqualsPath operator
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
                        "NumericEqualsPath": "$.myvalue",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the NumericGreaterThan operator
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
                        "NumericGreaterThan": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the NumericGreaterThanPath operator
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
                        "NumericGreaterThanPath": "$.myvalue",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

Scenario Outline: The Choice type supports the NumericGreaterThanEquals operator
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
                        "NumericGreaterThanEquals": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

Scenario Outline: The Choice type supports the NumericGreaterThanEqualsPath
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
                        "NumericGreaterThanEqualsPath": "$.myvalue",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the NumericLessThan operator
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
                        "NumericLessThan": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the NumericLessThanPath operator
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
                        "NumericLessThanPath": "$.myvalue",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": 10,
        "myvalue": 15
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

Scenario Outline: The Choice type supports the NumericLessThanEquals operator
Scenario Outline: The Choice type supports the NumericLessThanEqualsPath operator
  
  Scenario Outline: The Choice type supports the StringEquals operator
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
                        "StringEquals": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the StringEqualsPath operator
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
                        "StringEqualsPath": "$.otherthing",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_1>,
        "otherthing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the StringGreaterThan operator
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
                        "StringGreaterThan": <value_1>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the StringGreaterThanPath operator
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
                        "StringGreaterThanPath": "$.otherthing",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": "so",
        "otherthing": "at",
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the StringGreaterThanEquals operator
  Scenario Outline: The Choice type supports the StringGreaterThanEqualsPath operator

  Scenario Outline: The Choice type supports the StringLessThan operator
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
                        "StringLessThan": "so",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": "at"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the StringLessThanPath operator
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
                        "StringLessThanPath": "$.otherthing",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": "at",
        "otherthing": "so"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

Scenario Outline: The Choice type supports the StringLessThanEquals operator
Scenario Outline: The Choice type supports the StringLessThanEqualsPath operator

  Scenario Outline: The Choice type supports the StringMatches operator
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
                        "StringMatches": "blue",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "thing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampEquals": "2016-08-18T17:33:00Z",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampEqualsPath": "$.othertimestamp",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2016-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampGreaterThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampGreaterThan": "2016-08-18T17:33:00Z"
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2017-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampGreaterThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampGreaterThanPath": "$.othertimestamp",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2017-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampGreaterThanEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampGreatherThanEquals": "$.othertimestamp",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2016-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampGreaterThanEqualsPath operator
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
                        "TimestampGreaterThanEqualsPath": "$.othertimestamp",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2017-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampLessThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampLessThan": "2016-08-18T17:33:00Z",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2015-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampLessThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampLessThanPath": "$.othertimestamp",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2015-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampLessThanEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampLessThanEquals": "2016-08-18T17:33:00Z",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2015-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators

  Scenario Outline: The Choice type supports the TimestampLessThanEqualsPath operator
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
                        "TimestampLessThanEqualsPath": "$.othertimestamp",
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
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
        "timestamp": "2015-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
