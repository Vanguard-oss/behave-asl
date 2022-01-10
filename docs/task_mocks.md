# Task Mocks

The Task Type allows for State Machines to execute a resource in AWS.  Instead of actually invoking resources in AWS, `behave-asl` uses a mocking system.  You can specify what you expect the resource to be called with and what the resource should return.  The start of every scenario resets the mocks.  Mocks are configured on a per resource basis.  Each resource gets a FIFO list of responses and expectations.  Mocks are configured using the Given statements.

## Mock Responses

You can only configure a mock response to have a static JSON response

## Expectations

You can configure a mock to have two different types of expectations.

1. JSON comparison of Parameters
1. Skip validation

## Examples

### Mock with expectation and result mock

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the execution input is:
    """
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
    """
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

### Mock just the result

```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the execution input is:
    """
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
    """
    And the resource "Lambda" will be called with any parameters and return
    """
    {
        "Size": "Little"
    }
    """
    When the state machine executes
```

## Notes

- `behave-asl` does not do any validation of the resource name field.  The string you pass in is used verbatim.
- You must make sure that each resource has both a response and an expectation.
