# behave-asl

behave-asl is a Python tool for running unit-style behavioral tests against an AWS Step Function.  It is built on top of [behave](https://github.com/behave/behave).

In the below example, we define a basic state machine with multiple states.  We create a feature file that loads the state machine, skips to a step in the middle, then executes a single step.  It then validates the current state of the execution.

**state-machine.asl**

```
{
    "StartAt": "FirstState",
    "States": {
        "FirstState": {
            "Type": "Pass",
            "Next": "SecondState"
        },
        "SecondState": {
            "Type": "Pass",
            "Next": "ThirdState"
        },
        "ThirdState": {
            "Type": "Pass",
            "Result": "end",
            "End": true
        }
    }
}
```

**features/state-transitions.feature**

```
Feature: States can transition
  Scenario: Go from second to third state
    Given a state machine defined in "state-machine.asl"
    And the execution is currently at the state "SecondState"
    When the state machine executes
    Then the next state is "ThirdState"

  Scenario: Third state is the final state
    Given a state machine defined in "state-machine.asl"
    And the execution is currently at the state "ThirdState"
    When the state machine executes
    Then the execution ended
    And the execution was successful

```

## Advantages

### Quick execution

The `behave-asl` test bed will run very quickly in comparison to the actual time it takes to execute your state machine.  This allows you to catch some some mistakes earlier in the development lifecycle.  You can validate your JsonPath queries without executing your actual state machine.

### Document requirements

Feature files are regularly used in the software development industry to document the requirements for a system.

### Skip steps during test cases

`behave-asl` will allow you to skip steps.  This can be very helpful for state machines that have long running steps.

## Installation

```
$ pip install behave-asl
```

## Usage

### Project Structure

The asl files can be anywhere in your project.  You should have a `features` directory that contains your feature files.  Each feature file should use the `.feature` extension.  You can have subfolders within your `features` folder to help categorize your features.

```
state-machine.asl
features/my-first-feature.feature
features/grouping/my-second-feature.feature
```

### CLI

You can run `behave-asl` without any arguments to run against the current working directory.  `behave-asl` will look for feature files in a subfolder called `features`

```
behave-asl
```

`behave-asl` is a wrapper around `behave`.  All of `behave`'s command line options are available to `behave-asl`

### More Documentation

- [Reference Guide](docs/reference.md)
- [Compatability Guide](docs/compatability.md)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

- [Basic Contributor Guide](CONTRIBUTING.md)
- [Development Guides](docs/devguide.md)

## License

[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0/)
