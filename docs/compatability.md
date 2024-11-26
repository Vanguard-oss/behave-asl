# behave-asl Compatability

## Top Level Fields

| Field | Status |
| ----- | ------ |
| StartAt | Yes |
| QueryLanguage | No |

## States

### Choice

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | Yes|
| Parameters | Yes |
| OutputPath | Yes |
| Output | No |
| Choices | Yes |
| Default | Yes |
| Assign | No |
| QueryLanguage | Partial |

#### Comparison Operators

| Operator | Status |
| -------- | ------ |
| And | Yes |
| BooleanEquals | Yes |
| BooleanEqualsPath | Yes |
| IsBoolean | Yes |
| IsNull | Yes |
| IsNumeric | Yes |
| IsPresent | Yes |
| IsString | Yes |
| IsTimestamp | Yes |
| Not | Yes |
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
| Or | Yes |
| StringEquals | Yes |
| StringEqualsPath | Yes |
| StringGreaterThan | Yes |
| StringGreaterThanPath | Yes |
| StringGreaterThanEquals | Yes |
| StringGreaterThanEqualsPath | Yes |
| StringLessThan | Yes |
| StringLessThanPath | Yes |
| StringLessThanEquals | Yes |
| StringLessThanEqualsPath | Yes |
| StringMatches | Yes |
| TimestampEquals | Yes |
| TimestampEqualsPath | Yes |
| TimestampGreaterThan | Yes |
| TimestampGreaterThanPath | Yes |
| TimestampGreaterThanEquals | Yes |
| TimestampGreaterThanEqualsPath | Yes |
| TimestampLessThan | Yes |
| TimestampLessThanPath | Yes |
| TimestampLessThanEquals | Yes |
| TimestampLessThanEqualsPath | Yes |

### Fail

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |

### Map

| Modes | Status |
| ----- | ------ |
| Inline | Yes |
| Distributed | No |


| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |
| Output | No |
| Next | No |
| End | No |
| ResultPath | No |
| ItemProcessor | Yes |
| ItemReader | No |
| ItemsPath | No |
| ItemSelector | Yes |
| ItemBatcher | No |
| MaxConcurrency | Yes |
| ToleratedFailurePercentage | No |
| ToleratedFailureCount | No |
| Label | No |
| Parameters | No |
| ResultSelector | No |
| Retry | No |
| Catch | No |
| Assign | No |
| QueryLanguage | Partial |

| Input Type | Status |
| ---------- | ------ |
| CSV | No |
| object | No |
| JSON | No |
| S3 inventory list | No |

### Pass

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | Yes |
| OutputPath | Yes |
| Output | Yes |
| Next | Yes |
| End | Yes |
| ResultPath | Yes |
| Parameters | Yes |
| Assign | Yes |
| QueryLanguage | Partial |

### Parallel

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | Yes|
| OutputPath | Yes |
| Output | No |
| Next | Yes |
| End | Yes |
| ResultPath | Yes |
| Parameters | Yes |
| ResultSelector | Yes |
| Retry | No |
| Catch | No |
| Assign | No |
| QueryLanguage | Partial |

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
| Output | No |
| Next | Yes |
| End | Yes |
| ResultPath | Yes |
| Parameters | Yes |
| ResultSelector | Yes |
| Retry | Yes |
| Catch | Yes |
| Credentials | Yes |
| Assign | No |
| QueryLanguage | Partial |

### Wait

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |
| Output | No |
| Next | No |
| End | No |
| Assign | No |
| QueryLanguage | Partial |

## Reference Paths

### JSONPath

| Location | Status |
| --- | --- |
| State Input | Yes |
| State Output | Yes |
| Execution Input | Yes |
| Context Object | Yes |

### JSONata

| Location | Status |
| --- | --- |
| State Input | Yes |
| Result | No |
| Error | No |
| Context Object | Yes |

## Intrinsics

| Function | Status |
| --- | --- |
| States.Array | Yes |
| States.ArrayContains | Yes |
| States.ArrayGetItem | Yes |
| States.ArrayLength | Yes |
| States.ArrayPartition | Yes |
| States.ArrayRange | Yes |
| States.ArrayUnique | Yes |
| States.Format | Yes |
| States.Base64Decode | Yes |
| States.Base64Encode | Yes |
| States.Hash | Yes |
| States.JsonMerge | Yes |
| States.JsonToString | Yes |
| States.MathAdd | Yes |
| States.MathRandom | Yes |
| States.StringSplit | Yes |
| States.StringToJson | Yes |
| States.UUID | Yes |

## Intrinsic Argument Literal Types

| Type | Status | Notes |
| --- | --- | --- |
| String | Yes | |
| Boolean | Yes | |
| Integer | Yes | |
| Float | Yes | x.x format only |

## Query Languages

| Type | Status |
| JSONPath | Yes |
| JSONata | Partial |