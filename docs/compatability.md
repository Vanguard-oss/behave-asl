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
| Assign | Yes |
| Catch | No |
| Comment | Ignored |
| End | Yes |
| InputPath | Yes|
| ItemBatcher | No |
| ItemProcessor | Yes |
| ItemReader | No |
| Items | Yes |
| ItemSelector | Yes |
| ItemsPath | Yes |
| Label | No |
| MaxConcurrency | Yes |
| Next | Yes |
| Output | Yes |
| OutputPath | Yes |
| Parameters | Yes |
| QueryLanguage | Partial |
| ResultPath | Yes |
| ResultSelector | Yes |
| Retry | No |
| ToleratedFailurePercentage | No |
| ToleratedFailureCount | No |
| Type | Yes |


| Mode   | QueryLanguage | Processing    | Input     | Parameters   | Status |
| ------ | ------------- | ------------- | --------- | ------------ | ------ |
| Inline | JSONPath      | Iterator      | ItemsPath | None         | Yes    | 
| Inline | JSONPath      | Iterator      | ItemsPath | Parameters   | Yes    | 
| Inline | JSONPath      | Iterator      | ItemsPath | ItemSelector | Yes    | 
| Inline | JSONPath      | ItemProcessor | ItemsPath | None         | Yes    | 
| Inline | JSONPath      | ItemProcessor | ItemsPath | Parameters   | Yes    | 
| Inline | JSONPath      | ItemProcessor | ItemsPath | ItemSelector | Yes    | 
| Inline | JSONata       | Iterator      | Items     | None         | No     | 
| Inline | JSONata       | Iterator      | Items     | Parameters   | No     | 
| Inline | JSONata       | Iterator      | Items     | ItemSelector | No     | 
| Inline | JSONata       | ItemProcessor | Items     | None         | Yes    | 
| Inline | JSONata       | ItemProcessor | Items     | Parameters   | No     | 
| Inline | JSONata       | ItemProcessor | Items     | ItemSelector | Yes    | 

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
| Assign | Yes |
| Catch | No |
| Comment | Ignored |
| End | Yes |
| InputPath | Yes|
| Next | Yes |
| Output | Yes |
| OutputPath | Yes |
| Parameters | Yes |
| QueryLanguage | Yes |
| ResultPath | Yes |
| ResultSelector | Yes |
| Retry | No |
| Type | Yes |

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