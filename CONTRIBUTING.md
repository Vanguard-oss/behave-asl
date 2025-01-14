# Contributing

## Legal considerations

External contributor signs contributor license agreement, and issues a pull request. We have two types of agreements, one for individual and the other for those contributing on behalf of their company. These files will be available soon.

## Process

- For small changes, please proceed to the next step. For large changes, please submit a proposal first for review.
- Fork the repo
- Create a branch in your forked repo
- Make sure to add tests (see "How to Run Tests" below)
- Merge your changes back to your master branch.
- Open a PR to merge the master branch of your fork into behave-asl's master branch
- Add your name to [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Done!

## Requirements

- Files should be formatted according to the [Development Guides](docs/devguide.md)
- Google docstring format shall be used
- The code shall pass all existing tests
- New changes:
  - Shall have 80% test coverage
  - Shall have an updated docstring as applicable
  - Should have inline comments as needed

## How to Run Tests
This library extends '''behave''', but it also uses '''behave''' as its testing framework.

To run tests, set up a virtual environment like 

To run tests, you can use the following command:
```
```