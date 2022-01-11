# Development Guide

## Development Tools

### Python Code Formatter

`black` is used as the Python code formatter.  All code should be formatted prior to submitting a PR.

### Python Import Organization

`importanize` is used as the Python import organizer.  All imports should be organized prior to submitting a PR.

### Gherkins Code Formatter

`reformat-gherkin` is used as the Gherkins/Feature code formatter.  All feature files should be formatted prior to submitting a PR.

### Markdown Formatter

`mdformat` is used as the Markdown formatter.  All docs should be formatted prior to submitting a PR.

## Compatability

`behave-asl` supports Python >= 3.6.  It should also run on Linux, Mac and Windows

## Test Suite

`behave-asl` uses behave to test itself.

### Internal steps

There are some internal `Given`, `When`, `Then` steps that are used to make it easier to test the `behave-asl` code base.

### Parser tests

The `parser` feature files are used to check various small components to make sure they minimally work.
They don't do much in the sense of validating features that users would care about

### Assertions

The `assertions` feature files validate the `Then` assertion steps.  They use a bundled "simple" state machine
that doesn't have much in it.  The state machine is never actually mock-executed.  Instead, internal steps are
used to set the properties of the current `StepResult` instance.  We can set the result data, then verify the
`Then` steps that use JsonPath.

## Execution

The `execution` feature files validate state machine execution.  This is where the majority of the tool
is validated.  Each state has it's own subfolder that validates the basic execution of the state and that
the various attributes for the state work correctly.

Each state type should have a `basic_execution.feature` file that validates that a minimally configured state
can be executed.

Each attribute of the state type should have it's own feature file that validates that the attribute works the
way the developer intended.  For example, `input_path.feature` is used to validate that the InputPath attribute
correctly selects from the input and passes that data along to the state.

For more complicated state types, a `semantic_validation.feature` can be used to validate things like required
attributes and conflicts between attributes.
