# behave-asl Compatability

## States

### Choice

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |
| Choices | Partial |
| Default | Yes |

#### Comparison Operators

| Operator | Status |
| -------- | ------ |
| And | No |
| BooleanEquals | Yes |
| BooleanEqualsPath | Yes |
| IsBoolean | Yes |
| IsNull | Yes |
| IsNumeric | Yes |
| IsPresent | No |
| IsString | Yes |
| IsTimestamp | Yes |
| Not | No |
| NumericEquals | Yes |
| NumericEqualsPath | Yes |
| NumericGreaterThan | Yes |
| NumericGreaterThanPath | Yes |
| NumericGreaterThanEquals | Yes |
| NumericGreaterThanEqualsPath | Yes |
| NumericLessThan | Yes |
| NumericLessThanPath | Yes |
| NumericLessThanEquals | Yes |
| NumericLessThanEqualsPath | Yes |
| Or | No |
| StringEquals | Yes |
| StringEqualsPath | Yes |
| StringGreaterThan | Yes |
| StringGreaterThanPath | No |
| StringGreaterThanEquals | Yes |
| StringGreaterThanEqualsPath | No |
| StringLessThan | Yes |
| StringLessThanPath | No |
| StringLessThanEquals | Yes |
| StringLessThanEqualsPath | No |
| StringMatches | Yes |
| TimestampEquals | Yes |
| TimestampEqualsPath | No |
| TimestampGreaterThan | Yes |
| TimestampGreaterThanPath | No |
| TimestampGreaterThanEquals | Yes |
| TimestampGreaterThanEqualsPath | No |
| TimestampLessThan | Yes |
| TimestampLessThanPath | No |
| TimestampLessThanEquals | Yes |
| TimestampLessThanEqualsPath | No |

### Fail

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |

### Map

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |
| Next | No |
| End | No |
| ResultPath | No |
| Parameters | No |
| ResultSelector | No |
| Retry | No |
| Catch | No |

### Pass

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | Yes |
| OutputPath | Yes |
| Next | Yes |
| End | Yes |
| ResultPath | Yes |
| Parameters | Yes |

### Parallel

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |
| Next | No |
| End | No |
| ResultPath | No |
| Parameters | No |
| ResultSelector | No |
| Retry | No |
| Catch | No |

### Succeed

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | Yes |
| OutputPath | Yes |

### Task

The Task state doesn't simulate the interaction with an external resource yet.  It
is just a passthrough.

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | Yes|
| OutputPath | Yes |
| Next | Yes |
| End | Yes |
| ResultPath | Yes |
| Parameters | Yes |
| ResultSelector | Yes |
| Retry | No |
| Catch | No |

### Wait

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |
| Next | No |
| End | No |

## Reference Paths

| Location | Status |
| --- | --- |
| State Input | Yes |
| State Output | Yes |
| Execution Input | Yes |
| Context Object | Yes |

## Intrinsics

| Function | Status |
| --- | --- |
| States.Array | Yes |
| States.Format | Yes |
| States.JsonToString | Yes |
| States.StringToJson | Yes |

## Intrinsic Argument Literal Types

| Type | Status | Notes |
| --- | --- | --- |
| String | Yes | |
| Boolean | No | |
| Integer | Yes | |
| Float | Yes | x.x format only |
