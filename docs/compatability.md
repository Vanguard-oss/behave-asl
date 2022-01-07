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
| Context Object | No |

### Notes

1. Reference lookups are only supported at the first level.  Deeper lookups are not yet supported

## Intrinsics

| Function | Status |
| --- | --- |
| States.Array | No |
| States.Format | No |
| States.JsonToString | No |
| States.StringToJson | No |
