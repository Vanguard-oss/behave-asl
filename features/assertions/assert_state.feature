Feature: The step and execution state information can be checked
  Regression test the next state assertion.

  Scenario: The next state was set
    Given a simple state machine
    When the step sets "MyState" as the next state
    Then the next state is "MyState"
  
  Scenario: The current state can be set using "the execution is currently at the state (state)"
    Given a simple state machine
    And the execution is currently at the state "FirstState"

  Scenario: The current state can be set using "the state machine is current at the state (state)"
    Given a simple state machine
    And the state machine is current at the state "FirstState"
