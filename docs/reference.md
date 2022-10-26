# behave-asl Steps

## Given a state machine defined in "filename"

Load an ASL file in either json or yaml format.
**Parameters**

- filename - relative path to the ASL file to load

**Examples**

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
```

## Given the state machine is current at the state "name"

Tell the state machine execution that it is currently at the specific state
**Parameters**

- name - the name of the state to execute

**Examples**

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the state machine is current at the state "SecondState"
```

## Given the current state data is

Tell the state machine execution what the input for the next state to execute is
**Text**
Json object representing the input data

**Examples**

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the current state data is:
    """
    {
        "Key": "Value"
    }
    """
```

## Given the execution input is

Tell the state machine execution what the input is for the overall execution
**Text**
Json object representing the input data

**Examples**

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the execution input is:
    """
    {
        "Key": "Value"
    }
    """
```

## Given the retry count is "count"

Tell the state machine execution what the retry count is for the current step

**Parameters**

- count - the number of retries that the step function already performed

**Examples**

*Definition*

```
    {
       "StartAt": "FirstState",
       "States": {
           "FirstState": {
               "Type": "Task",
               "Resource": "Lambda",
               "Next": "EndState",
               "Retry": [
                   {
                       "MaxAttempts": 2,
                       "ErrorEquals": ["States.Timeout"]
                   }
                ]
            },
            "EndState": {
               "Type": "Task",
               "Resource": "Lambda",
               "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: The system won't exceed the max retries
    Given a state machine defined in "my-state-machine.asl"
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    And the retry count is "1"
    When the state machine executes
    Then the execution ended
    And the execution failed
```

## Given the resource "name" will return

Tell the execution environment to mock out a resource to return a specific value.

**Parameters**

- name - the name or ARN of the resource to mock out

**Text**
Json object representing the resource response

**Examples**

*Definition*

```
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Parameters": {
                    "Type": "Teapot"
                },
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the resource "Lambda" will be called with:
    """
    {
        "Type": "Teapot"
    }
    """
    And the resource "Lambda" will return:
    """
    {
        "Size": "Little"
    }
    """
    When the state machine executes
```

**Notes**

- This must be paired with a `Given the resource "name" will be called with` step

## Given the resource "name" will be called with any parameters and return

Tell the execution environment to mock out a resource to return a specific value.
This step will also tell the execution environment that it doesn't matter what
parameters are used to call the resource.

**Parameters**

- name - the name or ARN of the resource to mock out

**Text**
Json object representing the resource response

**Examples**
*Definition*

```
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Parameters": {
                    "Type": "Teapot"
                },
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the resource "Lambda" will be called with any parameters and return
    """
    {
        "Size": "Little"
    }
    """
    When the state machine executes
```

**Notes**

- This step is standalone.  It cannot be paired with one of the other mock steps

## Given branch "idx" will return

Tell the execution environment that the parallel branch will return a specific json value

**Parameters**

- idx - index of the branch in the parallel state

**Text**

Json object representing the return value of the branch

**Examples**
*Definition*

```
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Parallel",
                "Branches": [
                    {
                        "StartAt": "BranchA1",
                        "States": {
                            "BranchA1": {
                                "Type": "Pass",
                                "End": true
                            }
                        }
                    }
                ],
                "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the execution input is
      """
      {
        "Hello": "There"
      }
      """
    And branch "0" will return
      """
      {
        "A": "B"
      }
    """
    When the state machine executes
    Then branches were called with
      """
      {
        "Hello": "There"
      }
      """

```

## Given the resource "name" will be called with any parameters and fail with error "error"

Tell the execution environment to mock out a resource to return an error.
This step will also tell the execution environment that it doesn't matter what
parameters are used to call the resource.

**Parameters**

- name - the name or ARN of the resource to mock out
- error - the error type that should be thrown

**Examples**
*Definition*

```
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Parameters": {
                    "Type": "Teapot"
                },
                "Retry": [
                    {
                        "ErrorEquals": ["States.Timeout"]
                    }
                ]
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    When the state machine executes
    Then the next state is "FirstState"
```

**Notes**

- This step is standalone.  It cannot be paired with one of the other mock steps

## Given the resource "name" will be called with

Tell the execution environment that you expect the mocked resource to be called with specific parameters

**Parameters**

- name - the name or ARN of the resource to mock out

**Text**
Json object representing the parameters you expect the resource to be called with

**Examples**
*Definition*

```
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "Parameters": {
                    "Type": "Teapot"
                },
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the resource "Lambda" will be called with:
    """
    {
        "Type": "Teapot"
    }
    """
    And the resource "Lambda" will return:
    """
    {
        "Size": "Little"
    }
    """
    When the state machine executes
```

**Notes**

- This must be paired with a `Given the resource "name" will return` step

______________________________________________________________________

## When the state machine executes

Mock the execution of a single step of the state machine
**Examples**

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
```

______________________________________________________________________

## Then the context path "path" matches "value"

Verify that some data in the execution context matches what you expect it to.

**Parameters**

- path - a JsonPath query to traverse into the execution context
- value - the value to check for

**Examples**

*Definition*

```
    {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "Next": "EndState",
                  "Retry": [
                      {
                        "MaxAttempts": 3,
                        "ErrorEquals": ["States.Timeout"]
                      }
                  ]
              },
              "EndState": {
                  "Type": "Task",
                  "Resource": "Lambda",
                  "End": true
              }
          }
      }
```

*Feature file*

```
Feature: Example feature
  Scenario: A second retry can occur
    Given a state machine defined in "my-state-machine.asl"
    And the resource "Lambda" will be called with any parameters and fail with error "States.Timeout"
    And the retry count is "1"
    When the state machine executes
    Then the next state is "FirstState"
    And the context path "$.State.RetryCount" matches "2"
```

## Then the step result data is

Verify that the result data matches the expected value.  The order of any json keys does not matter in the comparison.
Using a json value match like this makes the feature file much easier to read, but it makes diagnosing failures much harder.  When there is a failure, you only know that a failure occurred.  The single Then statement will not help you determine where the mismatch is.  The other Then statements are much better are telling you where the mismatch is, but make for a harder to read feature file.

**Examples**
*Result Data*

```
{
    "hello": [
        "A",
        "B"
    ]
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data is:
    """
    {
        "hello": [
            "A",
            "B"
        ]
    }
    """
```

## Then the step result data path "path" contains "value"

Verify that the path within the result data contains the string
**Parameters**

- path - a JsonPath query to traverse into the result data
- value - the value to check for

**Examples**
*Result Data*

```
{
    "hello": [
        "A",
        "B"
    ]
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" contains "A"
```

## Then the step result data path "path" has "count" entries

Verify that the path within the result data contains the given number of entries.  This step works for both lists and dictionaries
**Parameters**

- path - a JsonPath query to traverse into the result data
- count - the expected number of entries

**Examples**
*Result Data*

```
{
    "hello": [
        "A",
        "B"
    ]
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" has "2" entries
```

## Then the step result data path "path" has "count" entry

Verify that the path within the result data contains the given number of entries.  This step works for both lists and dictionaries.  This is the same step as above, but with the word `entries` changed to `entry` to make the scenario with `1` entry feel more natural
**Parameters**

- path - a JsonPath query to traverse into the result data
- count - the expected number of entries

**Examples**
*Result Data*

```
{
    "hello": [
        "A",
        "B"
    ]
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" has "2" entries
```

## Then the step result data path "path" has length "length"

Verify that the path within the result data is a list with the specific length
**Parameters**

- path - JsonPath to the data element to check
- length - number of elements to expect

**Examples**
*Result Data*

```
{
    "hello": ["world"]
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" has length "1"
```


## Then the step result data path "path" is a dict

Verify that the path within the result data is a dictionary/map
**Parameters**

- path - JsonPath to the data element to check

**Examples**
*Result Data*

```
{
    "hello": {
        "world": "yes"
    }
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello.world" matches "yes"
    And the step result data path "$.hello" is a dict
```

## Then the step result data path "path" is an int

Verify that the path within the result data is an integer
**Parameters**

- path - JsonPath to the data element to check

**Examples**
*Result Data*

```
{
    "hello": 2
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" matches "2"
    And the step result data path "$.hello" is an int
```

## Then the step result data path "path" is a list

Verify that the path within the result data is a list of values
**Parameters**

- path - JsonPath to the data element to check

**Examples**
*Result Data*

```
{
    "hello": ["world"]
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" is a list
```

## Then the step result data path "path" is a string

Verify that the path within the result data is a string
**Parameters**

- path - JsonPath to the data element to check
  **Examples**
  *Result Data*

```
{
    "hello": "world"
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" is a string
```

## Then the step result data path "path" is null

Verify that the path within the result data is a null value
**Parameters**

- path - JsonPath to the data element to check

**Examples**
*Result Data*

```
{
    "hello": null
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" is null
```

## Then the step result data path "path" is true

Verify that the path within the result data is a boolean true
**Parameters**

- path - JsonPath to the data element to check

**Examples**
*Result Data*

```
{
    "hello": true
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" is true
```

## Then the step result data path "path" is false

Verify that the path within the result data is a boolean false
**Parameters**

- path - JsonPath to the data element to check

**Examples**
*Result Data*

```
{
    "hello": false
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" is false
```

## Then the step result data path "path" matches "value"

Validate a field in the step's result data.
**Parameters**

- path - a JsonPath query to traverse into the result data
- value - the value to check against

**Examples**
*Result Data*

```
{
    "hello": "world"
}
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the step result data path "$.hello" matches "world"
```

## Then the execution ended

Validates that the execution has ended

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
```

## Then the execution succeeded

Validates that the execution has ended with a successful execution

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution succeeded
```

## Then the execution failed

Validates that the execution has ended with a failed execution

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution failed
```

## Then the execution error was "error"

Validates that the execution failed with a specific error.

The error can be a standard [Error Name](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html)
or it could be a custom one from the `Fail` state.

**Parameters**

- error - name of the error

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution failed
    And the execution error was "States.Runtime"
```

## Then the execution error was null

Validates that the execution failed without an error.  This happens
when the `Fail` state successfuly executes but without an `Error`
configuration.

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution failed
    And the execution error was null
```

## Then the execution error cause was "cause"

Validates that the execution failed with a specific error cause.

**Parameters**

- cause - the exact text of the error cause

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution failed
    And the execution error cause was "My Custom Error"
```

## Then the execution error cause contained "cause"

Validates that the execution failed cause contains the message

**Parameters**

- cause - a string that should be in the error cause

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution failed
    And the execution error cause contained "Invalid"
```

## Then the execution error cause was null

Validates that the execution failed without a cause.  This happens when
the `Fail` state runs without a `Cause` setting.

**Examples**
*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
    Then the exeuction has ended
    And the execution failed
    And the execution error cause was null
```

## Then branches were called with

Validates that each branch got a specific input

**Text**

Json object representing the expected input

**Examples**
*Definition*

```
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Parallel",
                "Branches": [
                    {
                        "StartAt": "BranchA1",
                        "States": {
                            "BranchA1": {
                                "Type": "Pass",
                                "End": true
                            }
                        }
                    }
                ],
                "End": true
            }
        }
    }
```

*Feature file*

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the execution input is
      """
      {
        "Hello": "There"
      }
      """
    And branch "0" will return
      """
      {
        "A": "B"
      }
    """
    When the state machine executes
    Then branches were called with
      """
      {
        "Hello": "There"
      }
      """

```
