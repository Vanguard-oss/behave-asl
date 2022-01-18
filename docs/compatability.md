# behave-asl Compatability

## States

### Choice

| Field | Status |
| ----- | ------ |
| Type | Yes |
| Comment | Yes |
| InputPath | No|
| OutputPath | No |

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
