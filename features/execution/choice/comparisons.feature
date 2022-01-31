Feature: The Choice state type supports all operators (Except for And/Not/Or)

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
                "Type": "Pass",
                "End": true
            },
            "DefaultState": {
                "Type": Pass,
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
      | value_1 | value_2 | matched_state |
      | true    | true    | MatchState    |
      | false   | false   | MatchState    |
      | false   | true    | DefaultState  |
      | true    | false   | DefaultState  |
      | true    | "true"  | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2      | matched_state |
      | true    | true         | MatchState    |
      | true    | false        | MatchState    |
      | false   | true         | DefaultState  |
      | false   | false        | DefaultState  |
      | false   | "not_a_bool" | MatchState    |
      | false   | "true"       | MatchState    |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2    | matched_state |
      | true    | null       | MatchState    |
      | false   | "not_null" | MatchState    |
      | true    | "null"     | DefaultState  |
      | false   | null       | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2       | matched_state |
      | true    | 15            | MatchState    |
      | true    | 1.8           | MatchState    |
      | true    | -2            | MatchState    |
      | true    | -2.0          | MatchState    |
      | false   | "some_string" | MatchState    |
      | false   | false         | MatchState    |
      | false   | null          | MatchState    |
      | false   | "1"           | MatchState    |
      | true    | "some_string" | DefaultState  |
      | true    | false         | DefaultState  |
      | true    | null          | DefaultState  |
      | true    | "1"           | DefaultState  |
      | false   | 15            | DefaultState  |
      | false   | 1.8           | DefaultState  |
      | false   | -2            | DefaultState  |
      | false   | -2.0          | DefaultState  |

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
        <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2                 | matched_state |
      | true    | { "thing": "here" }     | MatchState    |
      | false   | { "notathing": "here" } | MatchState    |
      | false   | { "thing": "here" }     | DefaultState  |
      | true    | { "notathing": "here" } | DefaultState  |
      | true    | {}                      | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2       | matched_state |
      | true    | "is_a_string" | MatchState    |
      | false   | 1             | MatchState    |
      | false   | true          | MatchState    |
      | false   | null          | MatchState    |
      | true    | " "           | MatchState    |
      | false   | "is_a_string" | DefaultState  |
      | true    | 1             | DefaultState  |
      | true    | true          | DefaultState  |
      | true    | null          | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2                        | matched_state |
      | true    | "2001-01-01T12:00:00Z"         | MatchState    |
      | true    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | true    | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | false   | "2019-10-12 07:20:50.52Z"      | MatchState    |
      | false   | "2001-01-01T12:00:00Z+04:00"   | MatchState    |
      | false   | "2019-02-31T07:20:50.52+00:00" | MatchState    |
      | false   | "2001-01-01T12:00:00Z"         | DefaultState  |
      | false   | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | false   | "2019-10-12T07:20:50.52+00:00" | DefaultState  |
      | true    | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | true    | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | true    | "2019-02-31T07:20:50.52+00:00" | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 9       | 9       | MatchState    |
      | 2.0     | 2.0     | MatchState    |
      | 2       | 2.0     | MatchState    |
      | -3      | -3      | MatchState    |
      | "1"     | "1"     | DefaultState  |
      | "1"     | 1       | DefaultState  |
      | 1       | "1"     | DefaultState  |
      | 1       | 3       | DefaultState  |
      | 1.0     | 3.0     | DefaultState  |
      | -1      | -3      | DefaultState  |

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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 9       | 9       | MatchState    |
      | 2.0     | 2.0     | MatchState    |
      | -3      | -3      | MatchState    |
      | "1"     | "1"     | DefaultState  |
      | 1       | 3       | DefaultState  |
      | 1.0     | 3.0     | DefaultState  |
      | -1      | -3      | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 2       | 1       | MatchState    |
      | 3.0     | 2.0     | MatchState    |
      | -1.0    | -2.0    | MatchState    |
      | 2       | 2       | DefaultState  |
      | "2"     | "1"     | DefaultState  |
      | 1       | 2       | DefaultState  |
      | 2.0     | 3.0     | DefaultState  |
      | -2.0    | -1.0    | DefaultState  |

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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 2       | 1       | MatchState    |
      | 3.0     | 2.0     | MatchState    |
      | -1.0    | -2.0    | MatchState    |
      | 2.0     | 1       | MatchState    |
      | 2       | 2       | DefaultState  |
      | "2"     | "1"     | DefaultState  |
      | 1       | 2       | DefaultState  |
      | 2.0     | 3.0     | DefaultState  |
      | -2.0    | -1.0    | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 2       | 1       | MatchState    |
      | 3.0     | 2.0     | MatchState    |
      | -1.0    | -2.0    | MatchState    |
      | 2.0     | 1       | MatchState    |
      | 2       | 2       | MatchState    |
      | 3.5     | 3.5     | MatchState    |
      | -1      | -1      | MatchState    |
      | 2.0     | 2       | MatchState    |
      | "2"     | "1"     | DefaultState  |
      | 1       | 2       | DefaultState  |
      | 2.0     | 3.0     | DefaultState  |
      | -2.0    | -1.0    | DefaultState  |

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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 2       | 1       | MatchState    |
      | 3.0     | 2.0     | MatchState    |
      | -1.0    | -2.0    | MatchState    |
      | 2.0     | 1       | MatchState    |
      | 2       | 2       | MatchState    |
      | 3.5     | 3.5     | MatchState    |
      | -1      | -1      | MatchState    |
      | 2.0     | 2       | MatchState    |
      | "2"     | "1"     | DefaultState  |
      | 1       | 2       | DefaultState  |
      | 2.0     | 3.0     | DefaultState  |
      | -2.0    | -1.0    | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 1       | 2       | MatchState    |
      | 2.0     | 3.0     | MatchState    |
      | -2.0    | -1.0    | MatchState    |
      | 1       | 2.0     | MatchState    |
      | 2       | 2       | DefaultState  |
      | "1"     | "2"     | DefaultState  |
      | 2       | 1       | DefaultState  |
      | 3.0     | 2.0     | DefaultState  |
      | -1.0    | -2.0    | DefaultState  |

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
                        "NumericLessThan": <value_1>,
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 1       | 2       | MatchState    |
      | 2.0     | 3.0     | MatchState    |
      | -2.0    | -1.0    | MatchState    |
      | 1       | 2.0     | MatchState    |
      | 2       | 2       | MatchState    |
      | "1"     | "2"     | DefaultState  |
      | 2       | 1       | DefaultState  |
      | 3.0     | 2.0     | DefaultState  |
      | -1.0    | -2.0    | DefaultState  |

  Scenario Outline: The Choice type supports the NumericLessThanEquals operator
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
                        "NumericLessThanEquals": <value_1>,
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 1       | 2       | MatchState    |
      | 2.0     | 3.0     | MatchState    |
      | -2.0    | -1.0    | MatchState    |
      | 1       | 2.0     | MatchState    |
      | 2       | 2       | MatchState    |
      | 3.5     | 3.5     | MatchState    |
      | -1      | -1      | MatchState    |
      | 2       | 2.0     | MatchState    |
      | "1"     | "2"     | DefaultState  |
      | 2       | 1       | DefaultState  |
      | 3.0     | 2.0     | DefaultState  |
      | -1.0    | -2.0    | DefaultState  |

  Scenario Outline: The Choice type supports the NumericLessThanEqualsPath operator
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
                        "NumericLessThanEqualsPath": "$.myvalue",
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
        "thing": <value_1>,
        "myvalue": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1 | value_2 | matched_state |
      | 1       | 2       | MatchState    |
      | 2.0     | 3.0     | MatchState    |
      | -2.0    | -1.0    | MatchState    |
      | 1       | 2.0     | MatchState    |
      | 2       | 2       | MatchState    |
      | 3.5     | 3.5     | MatchState    |
      | -1      | -1      | MatchState    |
      | 2       | 2.0     | MatchState    |
      | "1"     | "2"     | DefaultState  |
      | 2       | 1       | DefaultState  |
      | 3.0     | 2.0     | DefaultState  |
      | -1.0    | -2.0    | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                     | value_2                      | matched_state |
      | "foo"                       | "foo"                        | MatchState    |
      | "foo_bar"                   | "foo_bar"                    | MatchState    |
      | "1"                         | "1"                          | MatchState    |
      | "i should match"            | "i should match"             | MatchState    |
      | "2016-08-18T17:33:00Z"      | "2016-08-18T17:33:00Z"       | MatchState    |
      | "2001-01-01T12:00:00+04:00" | "2001-01-01T12:00:00+04:00"  | MatchState    |
      | "2016-08-18T17:33:00Z"      | "2016-08-18T17:34:00Z"       | DefaultState  |
      | "2001-01-01T12:00:00+04:00" | "2001-01-02T12:00:00+04:00"  | DefaultState  |
      | "foo"                       | "bar"                        | DefaultState  |
      | "foo_bar"                   | "bar_foo"                    | DefaultState  |
      | "1"                         | "2"                          | DefaultState  |
      | "this should not match"     | "this should also not match" | DefaultState  |
      | "I should not match"        | "i should not match"         | DefaultState  |

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
        "thing": <value_1>,
        "otherthing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                     | value_2                      | matched_state |
      | "foo"                       | "foo"                        | MatchState    |
      | "foo_bar"                   | "foo_bar"                    | MatchState    |
      | "1"                         | "1"                          | MatchState    |
      | "i should match"            | "i should match"             | MatchState    |
      | "2016-08-18T17:33:00Z"      | "2016-08-18T17:33:00Z"       | MatchState    |
      | "2001-01-01T12:00:00+04:00" | "2001-01-01T12:00:00+04:00"  | MatchState    |
      | "2016-08-18T17:33:00Z"      | "2016-08-18T17:34:00Z"       | DefaultState  |
      | "2001-01-01T12:00:00+04:00" | "2001-01-02T12:00:00+04:00"  | DefaultState  |
      | "foo"                       | "bar"                        | DefaultState  |
      | "foo_bar"                   | "bar_foo"                    | DefaultState  |
      | "1"                         | "2"                          | DefaultState  |
      | "this should not match"     | "this should also not match" | DefaultState  |
      | "I should not match"        | "i should not match"         | DefaultState  |

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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "\""     | " "      | MatchState    |
      | "&"      | "!"      | MatchState    |
      | "apple"  | "app"    | MatchState    |
      | "apples" | "apple"  | MatchState    |
      | "a"      | "A"      | MatchState    |
      | "b"      | "a"      | MatchState    |
      | "babble" | "app"    | MatchState    |
      | "baby"   | "apple"  | MatchState    |
      | "foo"    | "foo"    | DefaultState  |
      | "caret^" | "caret^" | DefaultState  |
      | "1"      | "1"      | DefaultState  |
      | "baby"   | "apple"  | MatchState    |
      | "2"      | "1"      | MatchState    |
      | 1        | "foo"    | DefaultState  |
      | null     | "bar"    | DefaultState  |

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
        "thing": <value_1>,
        "otherthing": <value_2>,
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "b"      | "a"      | MatchState    |
      | "foo"    | "foo"    | DefaultState  |
      | "caret^" | "caret^" | DefaultState  |
      | "1"      | "1"      | DefaultState  |
      | "baby"   | "apple"  | MatchState    |
      | "2"      | "1"      | MatchState    |
      | "&"      | "!"      | MatchState    |
      | """      | " "      | MatchState    |
      | 1        | "foo"    | DefaultState  |
      | null     | "bar"    | DefaultState  |
      | "A"      | "a"      | MatchState    |

  Scenario Outline: The Choice type supports the StringGreaterThanEquals operator
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
                        "StringGreaterThanEquals": <value_1>,
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "baby"   | "apple"  | MatchState    |
      | "2"      | "1"      | MatchState    |
      | "b"      | "a"      | MatchState    |
      | "foo"    | "foo"    | MatchState    |
      | "caret^" | "caret^" | MatchState    |
      | "1"      | "1"      | MatchState    |
      | "&"      | "!"      | MatchState    |
      | "\""     | " "      | MatchState    |
      | 1        | "foo"    | DefaultState  |
      | null     | "bar"    | DefaultState  |
      | "a"      | "A"      | MatchState    |

  Scenario Outline: The Choice type supports the StringGreaterThanEqualsPath operator
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
                        "StringGreaterThanEqualsPath": "$.otherthing",
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

        "thing": <value_1>,
        "otherthing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "b"      | "a"      | MatchState    |
      | "foo"    | "foo"    | MatchState    |
      | "caret^" | "caret^" | MatchState    |
      | "1"      | "1"      | MatchState    |
      | "baby"   | "apple"  | MatchState    |
      | "2"      | "1"      | MatchState    |
      | "&"      | "!"      | MatchState    |
      | """      | " "      | MatchState    |
      | 1        | "foo"    | DefaultState  |
      | null     | "bar"    | DefaultState  |
      | "A"      | "a"      | MatchState    |

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
                        "StringLessThan": <value_1>,
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "a"      | "b"      | MatchState    |
      | "foo"    | "foo"    | DefaultState  |
      | "caret^" | "caret^" | DefaultState  |
      | "1"      | "1"      | DefaultState  |
      | "apple"  | "baby"   | MatchState    |
      | "1"      | "2"      | MatchState    |
      | "!"      | "&"      | MatchState    |
      | " "      | "\""     | MatchState    |
      | "foo"    | 1        | DefaultState  |
      | "bar"    | null     | DefaultState  |
      | "A"      | "a"      | MatchState    |

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
        "thing": <value_1>,
        "otherthing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "a"      | "b"      | MatchState    |
      | "foo"    | "foo"    | DefaultState  |
      | "caret^" | "caret^" | DefaultState  |
      | "1"      | "1"      | DefaultState  |
      | "apple"  | "baby"   | MatchState    |
      | "1"      | "2"      | MatchState    |
      | "!"      | "&"      | MatchState    |
      | " "      | "\""     | MatchState    |
      | "foo"    | 1        | DefaultState  |
      | "bar"    | null     | DefaultState  |
      | "A"      | "a"      | MatchState    |

  Scenario Outline: The Choice type supports the StringLessThanEquals operator
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
                        "StringLessThanEquals": <value_1>,
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "a"      | "b"      | MatchState    |
      | "foo"    | "foo"    | MatchState    |
      | "caret^" | "caret^" | MatchState    |
      | "1"      | "1"      | MatchState    |
      | "apple"  | "baby"   | MatchState    |
      | "1"      | "2"      | MatchState    |
      | "!"      | "&"      | MatchState    |
      | " "      | "\""     | MatchState    |
      | "foo"    | 1        | DefaultState  |
      | "bar"    | null     | DefaultState  |
      | "A"      | "a"      | MatchState    |

  Scenario Outline: The Choice type supports the StringLessThanEqualsPath operator
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
                        "StringLessThanEqualsPath": "$.otherthing",
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
        "thing": <value_1>,
        "otherthing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1  | value_2  | matched_state |
      | "a"      | "b"      | MatchState    |
      | "foo"    | "foo"    | MatchState    |
      | "caret^" | "caret^" | MatchState    |
      | "1"      | "1"      | MatchState    |
      | "apple"  | "baby"   | MatchState    |
      | "1"      | "2"      | MatchState    |
      | "!"      | "&"      | MatchState    |
      | " "      | """      | MatchState    |
      | "foo"    | 1        | DefaultState  |
      | "bar"    | null     | DefaultState  |
      | "a"      | "A"      | MatchState    |

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
                        "StringMatches": <value_1>,
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
        "thing": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1     | value_2              | matched_state |
      | "caret^"    | "caret^"             | MatchState    |
      | "apple"     | "apples"             | DefaultState  |
      | "log-*.txt" | "log-2022-01-24.txt" | MatchState    |
      | "Foo"       | "foo"                | DefaultState  |
      | "log-*.txt" | "log-2022-01-24"     | DefaultState  |
      | "a"         | "a"                  | MatchState    |
      | "Zebra"     | "Zebra"              | MatchState    |
      | "foo"       | "foo"                | MatchState    |
      | "1"         | "1"                  | MatchState    |
      | "1"         | "2"                  | DefaultState  |
      | "!"         | "&"                  | DefaultState  |
      | " "         | " "                  | MatchState    |
      | "foo"       | 1                    | DefaultState  |
      | "bar"       | null                 | DefaultState  |

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
                        "TimestampEquals": <value_1>,
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
        "timestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |

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
        "timestamp": <value_1>,
        "othertimestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |

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
                        "TimestampGreaterThan": <value_1>,
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
        "timestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T11:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T11:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T07:00:00Z"         | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | "2001-01-01T08:00:00Z"         | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.50+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | "2019-10-12 07:20:40.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | "2001-01-01T11:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | "2019-02-22T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-28T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-28T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |

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
        "timestamp": <value_1>,
        "othertimestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T11:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T11:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T07:00:00Z"         | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | "2001-01-01T08:00:00Z"         | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.50+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | "2019-10-12 07:20:40.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | "2001-01-01T11:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | "2019-02-22T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-28T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-28T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |

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
                        "TimestampGreaterThanEquals": <value_1>,
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
        "timestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T11:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T11:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T07:00:00Z"         | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T08:00:00Z"         | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.50+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | "2019-10-12 07:20:40.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | "2001-01-01T11:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | "2019-02-22T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-28T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-28T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |

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
        "timestamp": <value_1>,
        "othertimestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T11:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T11:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T07:00:00Z"         | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T08:00:00Z"         | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.50+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | "2019-10-12 07:20:40.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | "2001-01-01T11:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | "2019-02-22T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-28T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-28T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |

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
                        "TimestampLessThan": <value_1>,
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
        "timestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |

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
        "timestamp": <value_1>,
        "othertimestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |

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
                        "TimestampLessThanEquals": <value_1>,
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
        "timestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |

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
        "timestamp": <value_1>,
        "othertimestamp": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1                        | value_2                        | matched_state |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
