Feature: Parse yaml definitions
  As a developer, I want to be able to specify State Machines in YAML format.
  
  These scenarios verify that the yaml parser is working.

  Scenario: Correct yaml
    Given a state machine defined by:
    """
    StartAt: FirstState
    States:
      FirstState:
        Type: Pass
        Next: EndState
      EndState:
        Type: Pass
        Result: end
        End: true
    """

  Scenario: Invalid yaml
    Given an invalid state machine defined by:
    """
    StartAt: FirstState
    States:
      FirstState:
        Type: Pass
        Next: EndState
      EndState:
        Type: Pass
        Result: end
       # Wrong indentation
       End: true
    """
    When the parser runs
    Then the parser fails
