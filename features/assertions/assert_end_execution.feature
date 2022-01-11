Feature: The end of an execution can be verified
  Regression test the end execution assertions.

  Scenario: Successful end
    Given a simple state machine
    When the step ends the execution in a successful state
    Then the execution ended
    And the execution succeeded

  Scenario: Failed end
    Given a simple state machine
    When the step ends the execution in a failure state
    Then the execution ended
    And the execution failed
