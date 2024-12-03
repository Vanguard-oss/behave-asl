# behave-asl Compatability

| Status  | Description |
| ------- | ----------- |
| Yes     | Fully Supported |
| No      | Not Supported |
| Ignored | Value can be set, but it not actually used/validated |
| Partial | The value will be used and validated in some situations |

## Top Level Fields

| Field | Status |
| ----- | ------ |
| Comment | Ignored |
| QueryLanguage | Partial |
| StartAt | Yes |
| TimeoutSeconds | Ignored |
| Version | Ignored |
| States | Yes |

## States

### Choice

| Field | Status | Notes |
| ----- | ------ | ----- |
| Assign | No | |
| Choices | Yes | |
| Comment | Ignored | |
| Default | Yes | |
| QueryLanguage | Yes | |
| Type | Yes | |

#### JSONPath Comparison Operators

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
| Cause | Yes |
| CausePath | Yes |
| Comment | Ignored |
| Error | Yes |
| ErrorPath | Yes |
| QueryLanguage | Yes |
| Type | Yes |

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
| Comment | Ignored |
| InputPath | Yes |
| Output | Yes |
| OutputPath | Yes |
| QueryLanguage | Yes |
| Type | Yes |

### Task

| Field | Status | Notes |
| ----- | ------ | ----- |
| Arguments | Yes | |
| Assign | No | |
| Catch | Partial | JSONPath only |
| Comment | Ignored | |
| Credentials | Yes | |
| End | Yes |
| InputPath | Yes|
| Next | Yes |
| Output | Yes |
| OutputPath | Yes |
| Parameters | Yes |
| QueryLanguage | Partial |
| ResultPath | Yes |
| ResultSelector | Yes |
| Retry | Partial | JSONPath only |
| Type | Yes | |

### Wait

| Field | Status |
| ----- | ------ |
| Assign | Yes |
| Comment | Ignored |
| End | Yes |
| InputPath | Yes |
| Next | Yes |
| Output | Yes |
| OutputPath | Yes |
| QueryLanguage | Yes |
| Seconds | Yes |
| SecondsPath | Yes |
| Timestamp | Yes |
| TimestampPath | Yes |
| Type | Yes |

## Reference Paths

### JSONPath

| Location | Status |
| --- | --- |
| State Input | Yes |
| State Output | Yes |
| Execution Input | Yes |
| Context Object | Yes |
| Variables | Yes |

### JSONata

| Location | Status |
| --- | --- |
| State Input | Yes |
| Result | Yes |
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