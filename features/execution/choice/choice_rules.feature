Feature: Choice Rules and comparisons are supported by the Choice state type
# https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html#amazon-states-language-choice-state-rules

    Scenario: The Choice type supports the And operator
    Scenario: The Choice type supports the BooleanEquals operator
    Scenario: The Choice type supports the BooleanEqualsPath operator
    Scenario: The Choice type supports the IsBoolean operator
    Scenario: The Choice type supports the IsNull operator
    Scenario: The Choice type suports the IsPresent operator
    Scenario: The Choice type supports the IsString operator
    Scenario: The Choice type supports the IsTimestamp operator
    Scenario: The Choice type supports the Not operator
    Scenario: The Choice type supports the NumericEquals operator
    Scenario: The Choice type supports the NumericEqualsPath operator
    Scenario: The Choice type supports the NumericGreaterThan operator
    Scenario: The Choice type supports the NumericGreaterThanPath operator
    Scenario: The Choice type supports the NumericLessThan operator
    Scenario: The Choice type supports the NumericLessThanPath operator
    Scenario: The Choice type supports the Or operator
    Scenario: The Choice type supports the StringEquals operator
    #However, because timestamp fields are logically strings, it's possible that a field considered to be a timestamp can be matched by a StringEquals comparator.
    Scenario: The Choice type supports the StringEqualsPath operator
    Scenario: The Choice type supports the StringGreaterThan operator
    Scenario: The Choice type supports the StringGreaterThanPath operator
    Scenario: The Choice type supports the StringLessThan operator
    Scenario: The Choice type supports the StringLessThanPath operator
    Scenario: The Choice type supports the StringMatches operator
    Scenario: The Choice type supports the TimestampEquals operator
    Scenario: The Choice type supports the TimestampEqualsPath operator
    Scenario: The Choice type supports the TimestampGreaterThan operator
    Scenario: The Choice type supports the TimestampGreaterThanPath operator
    Scenario: The Choice type supports the TimestampGreaterThanEquals operator
    Scenario: The Choice type supports the TimestampGreatherThanEqualsPath operator
    Scenario: The Choice type supports the TimestampLessThan operator
    Scenario: The Choice type supports the TimestampLessThanPath operator
    Scenario: The Choice type supports the TimestampLessThanEquals operator
    Scenario: The Choice type supports the TimestampLessThanEqualsPath operator