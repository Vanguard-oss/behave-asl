Feature: The step and execution state information can be checked

  Scenario: The next state was set
    Given a simple state machine
    When the step sets "MyState" as the next state
    Then the next state is "MyState"
