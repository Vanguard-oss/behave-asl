Feature: The end of an execution can be verified

  Scenario: Successful end
    Given a simple state machine
    When the step ends the execution in a successful state
    Then the execution ended
    And the execution was successful

  Scenario: Failed end
    Given a simple state machine
    When the step ends the execution in a failure state
    Then the execution ended
    And the execution failed
