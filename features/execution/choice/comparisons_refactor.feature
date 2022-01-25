Feature: Choice rules should be supported

  Scenario Outline: The Choice type supports all non-boolean (And/Or/Not), non-path operators
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
                        "<comparator>": <value_1>,
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
      | comparator                 | value_1                        | value_2                        | matched_state |
      | BooleanEquals              | true                           | true                           | MatchState    |
      | BooleanEquals              | false                          | false                          | MatchState    |
      | BooleanEquals              | false                          | true                           | DefaultState  |
      | BooleanEquals              | true                           | false                          | DefaultState  |
      | BooleanEquals              | true                           | "true"                         | DefaultState  |
      | IsBoolean                  | true                           | true                           | MatchState    |
      | IsBoolean                  | true                           | false                          | MatchState    |
      | IsBoolean                  | false                          | true                           | DefaultState  |
      | IsBoolean                  | false                          | false                          | DefaultState  |
      | IsBoolean                  | false                          | "not_a_bool"                   | MatchState    |
      | IsBoolean                  | false                          | "true"                         | MatchState    |
      | IsNull                     | true                           | null                           | MatchState    |
      | IsNull                     | false                          | "not_null"                     | MatchState    |
      | IsNull                     | true                           | "null"                         | DefaultState  |
      | IsNull                     | false                          | null                           | DefaultState  |
      | IsNumeric                  | true                           | 15                             | MatchState    |
      | IsNumeric                  | true                           | 1.8                            | MatchState    |
      | IsNumeric                  | true                           | -2                             | MatchState    |
      | IsNumeric                  | true                           | -2.0                           | MatchState    |
      | IsNumeric                  | false                          | "some_string"                  | MatchState    |
      | IsNumeric                  | false                          | false                          | MatchState    |
      | IsNumeric                  | false                          | null                           | MatchState    |
      | IsNumeric                  | false                          | "1"                            | MatchState    |
      | IsNumeric                  | true                           | "some_string"                  | DefaultState  |
      | IsNumeric                  | true                           | false                          | DefaultState  |
      | IsNumeric                  | true                           | null                           | DefaultState  |
      | IsNumeric                  | true                           | "1"                            | DefaultState  |
      | IsNumeric                  | false                          | 15                             | DefaultState  |
      | IsNumeric                  | false                          | 1.8                            | DefaultState  |
      | IsNumeric                  | false                          | -2                             | DefaultState  |
      | IsNumeric                  | false                          | -2.0                           | DefaultState  |
      | IsPresent                  | true                           | { "thing": "here" }            | MatchState    |
      | IsPresent                  | false                          | { "notathing": "here" }        | MatchState    |
      | IsPresent                  | false                          | { "thing": "here" }            | DefaultState  |
      | IsPresent                  | true                           | { "notathing": "here" }        | DefaultState  |
      | IsPresent                  | true                           | {}                             | DefaultState  |
      | IsString                   | true                           | "is_a_string"                  | MatchState    |
      | IsString                   | false                          | 1                              | MatchState    |
      | IsString                   | false                          | true                           | MatchState    |
      | IsString                   | false                          | null                           | MatchState    |
      | IsString                   | true                           | " "                            | MatchState    |
      | IsString                   | false                          | "is_a_string"                  | DefaultState  |
      | IsString                   | true                           | 1                              | DefaultState  |
      | IsString                   | true                           | true                           | DefaultState  |
      | IsString                   | true                           | null                           | DefaultState  |
      | IsTimestamp                | true                           | "2001-01-01T12:00:00Z"         | MatchState    |
      | IsTimestamp                | true                           | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | IsTimestamp                | true                           | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | IsTimestamp                | false                          | "2019-10-12 07:20:50.52Z"      | MatchState    |
      | IsTimestamp                | false                          | "2001-01-01T12:00:00Z+04:00"   | MatchState    |
      | IsTimestamp                | false                          | "2019-02-31T07:20:50.52+00:00" | MatchState    |
      | IsTimestamp                | false                          | "2001-01-01T12:00:00Z"         | DefaultState  |
      | IsTimestamp                | false                          | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | IsTimestamp                | false                          | "2019-10-12T07:20:50.52+00:00" | DefaultState  |
      | IsTimestamp                | true                           | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | IsTimestamp                | true                           | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | IsTimestamp                | true                           | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | NumericEquals              | 9                              | 9                              | MatchState    |
      | NumericEquals              | 2.0                            | 2.0                            | MatchState    |
      | NumericEquals              | -3                             | -3                             | MatchState    |
      | NumericEquals              | "1"                            | "1"                            | DefaultState  |
      | NumericEquals              | 1                              | 3                              | DefaultState  |
      | NumericEquals              | 1.0                            | 3.0                            | DefaultState  |
      | NumericEquals              | -1                             | -3                             | DefaultState  |
      | NumericGreaterThan         | 2                              | 1                              | MatchState    |
      | NumericGreaterThan         | 3.0                            | 2.0                            | MatchState    |
      | NumericGreaterThan         | -1.0                           | -2.0                           | MatchState    |
      | NumericGreaterThan         | 2                              | 2                              | DefaultState  |
      | NumericGreaterThan         | "2"                            | "1"                            | DefaultState  |
      | NumericGreaterThan         | 1                              | 2                              | DefaultState  |
      | NumericGreaterThan         | 2.0                            | 3.0                            | DefaultState  |
      | NumericGreaterThan         | -2.0                           | -1.0                           | DefaultState  |
      | NumericGreaterThanEquals   | 2                              | 1                              | MatchState    |
      | NumericGreaterThanEquals   | 3.0                            | 2.0                            | MatchState    |
      | NumericGreaterThanEquals   | -1.0                           | -2.0                           | MatchState    |
      | NumericGreaterThanEquals   | 2.0                            | 1                              | MatchState    |
      | NumericGreaterThanEquals   | 2                              | 2                              | MatchState    |
      | NumericGreaterThanEquals   | 3.5                            | 3.5                            | MatchState    |
      | NumericGreaterThanEquals   | -1                             | -1                             | MatchState    |
      | NumericGreaterThanEquals   | 2.0                            | 2                              | MatchState    |
      | NumericGreaterThanEquals   | "2"                            | "1"                            | DefaultState  |
      | NumericGreaterThanEquals   | 1                              | 2                              | DefaultState  |
      | NumericGreaterThanEquals   | 2.0                            | 3.0                            | DefaultState  |
      | NumericGreaterThanEquals   | -2.0                           | -1.0                           | DefaultState  |
      | NumericLessThan            | 1                              | 2                              | MatchState    |
      | NumericLessThan            | 2.0                            | 3.0                            | MatchState    |
      | NumericLessThan            | -2.0                           | -1.0                           | MatchState    |
      | NumericLessThan            | 1                              | 2.0                            | MatchState    |
      | NumericLessThan            | 2                              | 2                              | MatchState    |
      | NumericLessThan            | "1"                            | "2"                            | DefaultState  |
      | NumericLessThan            | 2                              | 1                              | DefaultState  |
      | NumericLessThan            | 3.0                            | 2.0                            | DefaultState  |
      | NumericLessThan            | -1.0                           | -2.0                           | DefaultState  |
      | NumericLessThanEquals      | 1                              | 2                              | MatchState    |
      | NumericLessThanEquals      | 2.0                            | 3.0                            | MatchState    |
      | NumericLessThanEquals      | -2.0                           | -1.0                           | MatchState    |
      | NumericLessThanEquals      | 1                              | 2.0                            | MatchState    |
      | NumericLessThanEquals      | 2                              | 2                              | MatchState    |
      | NumericLessThanEquals      | 3.5                            | 3.5                            | MatchState    |
      | NumericLessThanEquals      | -1                             | -1                             | MatchState    |
      | NumericLessThanEquals      | 2                              | 2.0                            | MatchState    |
      | NumericLessThanEquals      | "1"                            | "2"                            | DefaultState  |
      | NumericLessThanEquals      | 2                              | 1                              | DefaultState  |
      | NumericLessThanEquals      | 3.0                            | 2.0                            | DefaultState  |
      | NumericLessThanEquals      | -1.0                           | -2.0                           | DefaultState  |
      | StringEquals               | "foo"                          | "foo"                          | MatchState    |
      | StringEquals               | "foo_bar"                      | "foo_bar"                      | MatchState    |
      | StringEquals               | "1"                            | "1"                            | MatchState    |
      | StringEquals               | "i should match"               | "i should match"               | MatchState    |
      | StringEquals               | "2016-08-18T17:33:00Z"         | "2016-08-18T17:33:00Z"         | MatchState    |
      | StringEquals               | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | StringEquals               | "2016-08-18T17:33:00Z"         | "2016-08-18T17:34:00Z"         | DefaultState  |
      | StringEquals               | "2001-01-01T12:00:00+04:00"    | "2001-01-02T12:00:00+04:00"    | DefaultState  |
      | StringEquals               | "foo"                          | "bar"                          | DefaultState  |
      | StringEquals               | "foo_bar"                      | "bar_foo"                      | DefaultState  |
      | StringEquals               | "1"                            | "2"                            | DefaultState  |
      | StringEquals               | "this should not match"        | "this should also not match"   | DefaultState  |
      | StringEquals               | "I should not match"           | "i should not match"           | DefaultState  |
      | StringGreaterThan          | "b"                            | "a"                            | MatchState    |
      | StringGreaterThan          | "foo"                          | "foo"                          | DefaultState  |
      | StringGreaterThan          | "caret^"                       | "caret^"                       | DefaultState  |
      | StringGreaterThan          | "1"                            | "1"                            | DefaultState  |
      | StringGreaterThan          | "baby"                         | "apple"                        | MatchState    |
      | StringGreaterThan          | "2"                            | "1"                            | MatchState    |
      | StringGreaterThan          | "&"                            | "!"                            | MatchState    |
      | StringGreaterThan          | """                            | " "                            | MatchState    |
      | StringGreaterThan          | 1                              | "foo"                          | DefaultState  |
      | StringGreaterThan          | null                           | "bar"                          | DefaultState  |
      | StringGreaterThan          | "A"                            | "a"                            | MatchState    |
      | StringGreaterThanEquals    | "b"                            | "a"                            | MatchState    |
      | StringGreaterThanEquals    | "foo"                          | "foo"                          | MatchState    |
      | StringGreaterThanEquals    | "caret^"                       | "caret^"                       | MatchState    |
      | StringGreaterThanEquals    | "1"                            | "1"                            | MatchState    |
      | StringGreaterThanEquals    | "baby"                         | "apple"                        | MatchState    |
      | StringGreaterThanEquals    | "2"                            | "1"                            | MatchState    |
      | StringGreaterThanEquals    | "&"                            | "!"                            | MatchState    |
      | StringGreaterThanEquals    | """                            | " "                            | MatchState    |
      | StringGreaterThanEquals    | 1                              | "foo"                          | DefaultState  |
      | StringGreaterThanEquals    | null                           | "bar"                          | DefaultState  |
      | StringGreaterThanEquals    | "A"                            | "a"                            | MatchState    |
      | StringLessThan             | "a"                            | "b"                            | MatchState    |
      | StringLessThan             | "foo"                          | "foo"                          | DefaultState  |
      | StringLessThan             | "caret^"                       | "caret^"                       | DefaultState  |
      | StringLessThan             | "1"                            | "1"                            | DefaultState  |
      | StringLessThan             | "apple"                        | "baby"                         | MatchState    |
      | StringLessThan             | "1"                            | "2"                            | MatchState    |
      | StringLessThan             | "!"                            | "&"                            | MatchState    |
      | StringLessThan             | " "                            | """                            | MatchState    |
      | StringLessThan             | "foo"                          | 1                              | DefaultState  |
      | StringLessThan             | "bar"                          | null                           | DefaultState  |
      | StringLessThan             | "a"                            | "A"                            | MatchState    |
      | StringLessThanEquals       | "a"                            | "b"                            | MatchState    |
      | StringLessThanEquals       | "foo"                          | "foo"                          | MatchState    |
      | StringLessThanEquals       | "caret^"                       | "caret^"                       | MatchState    |
      | StringLessThanEquals       | "1"                            | "1"                            | MatchState    |
      | StringLessThanEquals       | "apple"                        | "baby"                         | MatchState    |
      | StringLessThanEquals       | "1"                            | "2"                            | MatchState    |
      | StringLessThanEquals       | "!"                            | "&"                            | MatchState    |
      | StringLessThanEquals       | " "                            | """                            | MatchState    |
      | StringLessThanEquals       | "foo"                          | 1                              | DefaultState  |
      | StringLessThanEquals       | "bar"                          | null                           | DefaultState  |
      | StringLessThanEquals       | "a"                            | "A"                            | MatchState    |
      | StringMatches              | "log-*.txt"                    | "log-2022-01-24.txt"           | MatchState    |
      | StringMatches              | "log-*.txt"                    | "log-2022-01-24"               | DefaultState  |
      | StringMatches              | "a"                            | "a"                            | MatchState    |
      | StringMatches              | "Zebra"                        | "Zebra"                        | MatchState    |
      | StringMatches              | "foo"                          | "foo"                          | MatchState    |
      | StringMatches              | "caret^"                       | "caret^"                       | MatchState    |
      | StringMatches              | "1"                            | "1"                            | MatchState    |
      | StringMatches              | "apple"                        | "apples"                       | DefaultState  |
      | StringMatches              | "1"                            | "2"                            | DefaultState  |
      | StringMatches              | "!"                            | "&"                            | DefaultState  |
      | StringMatches              | " "                            | " "                            | MatchState    |
      | StringMatches              | "foo"                          | 1                              | DefaultState  |
      | StringMatches              | "bar"                          | null                           | DefaultState  |
      | StringMatches              | "Foo"                          | "foo"                          | DefaultState  |
      | TimestampEquals            | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | TimestampEquals            | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | TimestampEquals            | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | TimestampEquals            | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | TimestampEquals            | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | TimestampEquals            | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | TimestampEquals            | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampEquals            | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | TimestampEquals            | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThan       | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampGreaterThan       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampGreaterThan       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampGreaterThan       | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | TimestampGreaterThan       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | TimestampGreaterThan       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | DefaultState  |
      | TimestampGreaterThan       | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThan       | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThan       | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThan       | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampGreaterThan       | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampGreaterThan       | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampGreaterThan       | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThan       | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampGreaterThan       | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | TimestampGreaterThanEquals | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEquals | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | TimestampGreaterThanEquals | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEquals | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampGreaterThanEquals | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampGreaterThanEquals | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampGreaterThanEquals | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEquals | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampGreaterThanEquals | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThan          | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampLessThan          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampLessThan          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampLessThan          | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | TimestampLessThan          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | TimestampLessThan          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | DefaultState  |
      | TimestampLessThan          | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThan          | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThan          | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThan          | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampLessThan          | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampLessThan          | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampLessThan          | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThan          | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampLessThan          | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | TimestampLessThanEquals    | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEquals    | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | TimestampLessThanEquals    | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEquals    | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampLessThanEquals    | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampLessThanEquals    | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampLessThanEquals    | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEquals    | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampLessThanEquals    | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |

  Scenario Outline: The Choice type supports the Path versions of all operators (ie, BooleanEqualsPath, etc.)
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
      | comparator                     | value_1                        | value_2                        | matched_state |
      | BooleanEqualsPath              | true                           | true                           | MatchState    |
      | BooleanEqualsPath              | false                          | false                          | MatchState    |
      | BooleanEqualsPath              | true                           | false                          | DefaultState  |
      | BooleanEqualsPath              | false                          | true                           | DefaultState  |
      | BooleanEqualsPath              | "not_a_bool"                   | false                          | DefaultState  |
      | BooleanEqualsPath              | "true"                         | true                           | DefaultState  |
      | NumericEqualsPath              | 9                              | 9                              | MatchState    |
      | NumericEqualsPath              | 2.0                            | 2.0                            | MatchState    |
      | NumericEqualsPath              | -3                             | -3                             | MatchState    |
      | NumericEqualsPath              | "1"                            | "1"                            | DefaultState  |
      | NumericEqualsPath              | 1                              | 3                              | DefaultState  |
      | NumericEqualsPath              | 1.0                            | 3.0                            | DefaultState  |
      | NumericEqualsPath              | -1                             | -3                             | DefaultState  |
      | NumericGreaterThanPath         | 2                              | 1                              | MatchState    |
      | NumericGreaterThanPath         | 3.0                            | 2.0                            | MatchState    |
      | NumericGreaterThanPath         | -1.0                           | -2.0                           | MatchState    |
      | NumericGreaterThanPath         | 2.0                            | 1                              | MatchState    |
      | NumericGreaterThanPath         | 2                              | 2                              | DefaultState  |
      | NumericGreaterThanPath         | "2"                            | "1"                            | DefaultState  |
      | NumericGreaterThanPath         | 1                              | 2                              | DefaultState  |
      | NumericGreaterThanPath         | 2.0                            | 3.0                            | DefaultState  |
      | NumericGreaterThanPath         | -2.0                           | -1.0                           | DefaultState  |
      | NumericGreaterThanEqualsPath   | 2                              | 1                              | MatchState    |
      | NumericGreaterThanEqualsPath   | 3.0                            | 2.0                            | MatchState    |
      | NumericGreaterThanEqualsPath   | -1.0                           | -2.0                           | MatchState    |
      | NumericGreaterThanEqualsPath   | 2.0                            | 1                              | MatchState    |
      | NumericGreaterThanEqualsPath   | 2                              | 2                              | MatchState    |
      | NumericGreaterThanEqualsPath   | 3.5                            | 3.5                            | MatchState    |
      | NumericGreaterThanEqualsPath   | -1                             | -1                             | MatchState    |
      | NumericGreaterThanEqualsPath   | 2.0                            | 2                              | MatchState    |
      | NumericGreaterThanEqualsPath   | "2"                            | "1"                            | DefaultState  |
      | NumericGreaterThanEqualsPath   | 1                              | 2                              | DefaultState  |
      | NumericGreaterThanEqualsPath   | 2.0                            | 3.0                            | DefaultState  |
      | NumericGreaterThanEqualsPath   | -2.0                           | -1.0                           | DefaultState  |
      | NumericLessThanPath            | 1                              | 2                              | MatchState    |
      | NumericLessThanPath            | 2.0                            | 3.0                            | MatchState    |
      | NumericLessThanPath            | -2.0                           | -1.0                           | MatchState    |
      | NumericLessThanPath            | 1                              | 2.0                            | MatchState    |
      | NumericLessThanPath            | 2                              | 2                              | MatchState    |
      | NumericLessThanPath            | "1"                            | "2"                            | DefaultState  |
      | NumericLessThanPath            | 2                              | 1                              | DefaultState  |
      | NumericLessThanPath            | 3.0                            | 2.0                            | DefaultState  |
      | NumericLessThanPath            | -1.0                           | -2.0                           | DefaultState  |
      | NumericLessThanEqualsPath      | 1                              | 2                              | MatchState    |
      | NumericLessThanEqualsPath      | 2.0                            | 3.0                            | MatchState    |
      | NumericLessThanEqualsPath      | -2.0                           | -1.0                           | MatchState    |
      | NumericLessThanEqualsPath      | 1                              | 2.0                            | MatchState    |
      | NumericLessThanEqualsPath      | 2                              | 2                              | MatchState    |
      | NumericLessThanEqualsPath      | 3.5                            | 3.5                            | MatchState    |
      | NumericLessThanEqualsPath      | -1                             | -1                             | MatchState    |
      | NumericLessThanEqualsPath      | 2                              | 2.0                            | MatchState    |
      | NumericLessThanEqualsPath      | "1"                            | "2"                            | DefaultState  |
      | NumericLessThanEqualsPath      | 2                              | 1                              | DefaultState  |
      | NumericLessThanEqualsPath      | 3.0                            | 2.0                            | DefaultState  |
      | NumericLessThanEqualsPath      | -1.0                           | -2.0                           | DefaultState  |
      | StringEqualsPath               | "foo"                          | "foo"                          | MatchState    |
      | StringEqualsPath               | "foo_bar"                      | "foo_bar"                      | MatchState    |
      | StringEqualsPath               | "1"                            | "1"                            | MatchState    |
      | StringEqualsPath               | "i should match"               | "i should match"               | MatchState    |
      | StringEqualsPath               | "2016-08-18T17:33:00Z"         | "2016-08-18T17:33:00Z"         | MatchState    |
      | StringEqualsPath               | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | StringEqualsPath               | "2016-08-18T17:33:00Z"         | "2016-08-18T17:34:00Z"         | DefaultState  |
      | StringEqualsPath               | "2001-01-01T12:00:00+04:00"    | "2001-01-02T12:00:00+04:00"    | DefaultState  |
      | StringEqualsPath               | "foo"                          | "bar"                          | DefaultState  |
      | StringEqualsPath               | "foo_bar"                      | "bar_foo"                      | DefaultState  |
      | StringEqualsPath               | "1"                            | "2"                            | DefaultState  |
      | StringEqualsPath               | "this should not match"        | "this should also not match"   | DefaultState  |
      | StringEqualsPath               | "I should not match"           | "i should not match"           | DefaultState  |
      | StringGreaterThanPath          | "b"                            | "a"                            | MatchState    |
      | StringGreaterThanPath          | "foo"                          | "foo"                          | DefaultState  |
      | StringGreaterThanPath          | "caret^"                       | "caret^"                       | DefaultState  |
      | StringGreaterThanPath          | "1"                            | "1"                            | DefaultState  |
      | StringGreaterThanPath          | "baby"                         | "apple"                        | MatchState    |
      | StringGreaterThanPath          | "2"                            | "1"                            | MatchState    |
      | StringGreaterThanPath          | "&"                            | "!"                            | MatchState    |
      | StringGreaterThanPath          | """                            | " "                            | MatchState    |
      | StringGreaterThanPath          | 1                              | "foo"                          | DefaultState  |
      | StringGreaterThanPath          | null                           | "bar"                          | DefaultState  |
      | StringGreaterThanPath          | "A"                            | "a"                            | MatchState    |
      | StringGreaterThanEqualsPath    | "b"                            | "a"                            | MatchState    |
      | StringGreaterThanEqualsPath    | "foo"                          | "foo"                          | MatchState    |
      | StringGreaterThanEqualsPath    | "caret^"                       | "caret^"                       | MatchState    |
      | StringGreaterThanEqualsPath    | "1"                            | "1"                            | MatchState    |
      | StringGreaterThanEqualsPath    | "baby"                         | "apple"                        | MatchState    |
      | StringGreaterThanEqualsPath    | "2"                            | "1"                            | MatchState    |
      | StringGreaterThanEqualsPath    | "&"                            | "!"                            | MatchState    |
      | StringGreaterThanEqualsPath    | """                            | " "                            | MatchState    |
      | StringGreaterThanEqualsPath    | 1                              | "foo"                          | DefaultState  |
      | StringGreaterThanEqualsPath    | null                           | "bar"                          | DefaultState  |
      | StringGreaterThanEqualsPath    | "A"                            | "a"                            | MatchState    |
      | StringLessThanPath             | "a"                            | "b"                            | MatchState    |
      | StringLessThanPath             | "foo"                          | "foo"                          | DefaultState  |
      | StringLessThanPath             | "caret^"                       | "caret^"                       | DefaultState  |
      | StringLessThanPath             | "1"                            | "1"                            | DefaultState  |
      | StringLessThanPath             | "apple"                        | "baby"                         | MatchState    |
      | StringLessThanPath             | "1"                            | "2"                            | MatchState    |
      | StringLessThanPath             | "!"                            | "&"                            | MatchState    |
      | StringLessThanPath             | " "                            | """                            | MatchState    |
      | StringLessThanPath             | "foo"                          | 1                              | DefaultState  |
      | StringLessThanPath             | "bar"                          | null                           | DefaultState  |
      | StringLessThanPath             | "a"                            | "A"                            | MatchState    |
      | StringLessThanEqualsPath       | "a"                            | "b"                            | MatchState    |
      | StringLessThanEqualsPath       | "foo"                          | "foo"                          | MatchState    |
      | StringLessThanEqualsPath       | "caret^"                       | "caret^"                       | MatchState    |
      | StringLessThanEqualsPath       | "1"                            | "1"                            | MatchState    |
      | StringLessThanEqualsPath       | "apple"                        | "baby"                         | MatchState    |
      | StringLessThanEqualsPath       | "1"                            | "2"                            | MatchState    |
      | StringLessThanEqualsPath       | "!"                            | "&"                            | MatchState    |
      | StringLessThanEqualsPath       | " "                            | """                            | MatchState    |
      | StringLessThanEqualsPath       | "foo"                          | 1                              | DefaultState  |
      | StringLessThanEqualsPath       | "bar"                          | null                           | DefaultState  |
      | StringLessThanEqualsPath       | "a"                            | "A"                            | MatchState    |
      | TimestampEqualsPath            | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | TimestampEqualsPath            | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | TimestampEqualsPath            | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | TimestampEqualsPath            | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.52+00:00" | MatchState    |
      | TimestampEqualsPath            | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:50.52Z"      | DefaultState  |
      | TimestampEqualsPath            | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T12:00:00Z+04:00"   | DefaultState  |
      | TimestampEqualsPath            | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampEqualsPath            | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | TimestampEqualsPath            | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | DefaultState  |
      | TimestampGreaterThanPath       | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanPath       | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanPath       | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanPath       | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampGreaterThanPath       | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampGreaterThanPath       | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampGreaterThanPath       | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanPath       | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampGreaterThanPath       | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | TimestampGreaterThanEqualsPath | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEqualsPath | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | TimestampGreaterThanEqualsPath | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEqualsPath | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampGreaterThanEqualsPath | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampGreaterThanEqualsPath | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampGreaterThanEqualsPath | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampGreaterThanEqualsPath | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampGreaterThanEqualsPath | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanPath          | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampLessThanPath          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampLessThanPath          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampLessThanPath          | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | DefaultState  |
      | TimestampLessThanPath          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | DefaultState  |
      | TimestampLessThanPath          | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | DefaultState  |
      | TimestampLessThanPath          | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanPath          | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanPath          | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanPath          | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampLessThanPath          | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampLessThanPath          | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampLessThanPath          | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanPath          | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampLessThanPath          | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00Z"         | "2001-01-01T11:00:00Z"         | MatchState    |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T11:00:00+04:00"    | MatchState    |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T07:00:00Z"         | MatchState    |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00Z"         | "2001-01-01T12:00:00Z"         | MatchState    |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T12:00:00+04:00"    | MatchState    |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00+04:00"    | "2001-01-01T08:00:00Z"         | MatchState    |
      | TimestampLessThanEqualsPath    | "2019-02-31T07:20:50.52+00:00" | "2019-02-31T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEqualsPath    | "2020-02-29T07:20:50.52+00:00" | "2020-02-29T07:20:50.52+00:00" | MatchState    |
      | TimestampLessThanEqualsPath    | "2019-02-29T07:20:50.52+00:00" | "2019-02-29T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEqualsPath    | "2019-10-12T07:20:50.52+00:00" | "2019-10-12T07:20:50.50+00:00" | MatchState    |
      | TimestampLessThanEqualsPath    | "2019-10-12 07:20:50.52Z"      | "2019-10-12 07:20:40.52Z"      | DefaultState  |
      | TimestampLessThanEqualsPath    | "2001-01-01T12:00:00Z+04:00"   | "2001-01-01T11:00:00Z+04:00"   | DefaultState  |
      | TimestampLessThanEqualsPath    | "2019-02-31T07:20:50.52+00:00" | "2019-02-22T07:20:50.52+00:00" | DefaultState  |
      | TimestampLessThanEqualsPath    | "2020-02-29T07:20:50.52+00:00" | "2020-02-28T07:20:50.52+00:00" | MatchState    |
      | TimestampLessThanEqualsPath    | "2019-02-29T07:20:50.52+00:00" | "2019-02-28T07:20:50.52+00:00" | DefaultState  |
