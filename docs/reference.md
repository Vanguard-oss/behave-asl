# behave-asl Steps

## Given
### a state machine defined in "filename"
Load an ASL file in either json or yaml format.

**Parameters**
* filename - relative path to the ASL file to load

**Examples**
```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
```
### the execution is currently at "name"
Tell the state machine execution that it is currently at the specific state

**Parameters**
* name - the name of the state to execute

**Examples**
```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    And the execution is currently at "SecondState"
```
## When
### the state machine executes
Mock the execution of a single step of the state machine
**Examples**
```
Feature: Example feature
  Scenario: Load a state machine from an asl file
    Given a state machine defined in "my-state-machine.asl"
    When the state machine executes
```
## Then
### the step result data path "path" contains "value"
Verify that the path within the result data contains the string

**Parameters**
* path - a JsonPath query to traverse into the result data
* value - the value to check for

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


### the step result data path "path" has "count" entries
Verify that the path within the result data contains the given number of entries.  This step works for both lists and dictionaries

**Parameters**
* path - a JsonPath query to traverse into the result data
* count - the expected number of entries
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

### the step result data path "path" has "count" entry
Verify that the path within the result data contains the given number of entries.  This step works for both lists and dictionaries.  This is the same step as above, but with the word `entries` changed to `entry` to make the scenario with `1` entry feel more natural

**Parameters**
* path - a JsonPath query to traverse into the result data
* count - the expected number of entries
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

### the step result data path "path" is a dict
Verify that the path within the result data is a dictionary/map
**Parameters**
* path - JsonPath to the data element to check
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
### the step result data path "path" is an int
Verify that the path within the result data is an integer

**Parameters**
* path - JsonPath to the data element to check

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

### the step result data path "path" is a list
Verify that the path within the result data is a list of values

**Parameters**
* path - JsonPath to the data element to check

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

### the step result data path "path" is a string
Verify that the path within the result data is a string
**Parameters**
* path - JsonPath to the data element to check
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

### the step result data path "path" matches "value"
Validate a field in the step's result data.

**Parameters**
* path - a JsonPath query to traverse into the result data
* value - the value to check against

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
