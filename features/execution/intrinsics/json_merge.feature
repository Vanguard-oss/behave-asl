Feature: JsonMerge intrinsic

  Scenario: Empty merge
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonMerge($.Input1, $.Input2, false)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input1": {},
          "Input2": {}
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": {}
      }
      """

  Scenario: Deep isn't supported yet
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonMerge($.Input1, $.Input2, true)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input1": {},
          "Input2": {}
      }
      """
    When the state machine executes
    Then the execution failed

  Scenario: Simple combination
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonMerge($.Input1, $.Input2, false)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input1": {
            "A": "B"
          },
          "Input2": {
            "C": "D"
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": {
            "A": "B",
            "C": "D"
          }
      }
      """

  Scenario: Overwrite
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.JsonMerge($.Input1, $.Input2, false)"
                  },
                  "End": true
              }
          }
      }
      """
    And the current state data is:
      """
      {
          "Input1": {
            "A": "B"
          },
          "Input2": {
            "A": "C"
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": {
            "A": "C"
          }
      }
      """
