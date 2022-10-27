Feature: Hashing support

  Scenario Outline: States.Hash is supported
    Given a state machine defined by:
      """
      {
          "StartAt": "FirstState",
          "States": {
              "FirstState": {
                  "Type": "Pass",
                  "Parameters": {
                      "Param.$": "States.Hash(<input>, '<algo>')"
                  },
                  "End": true
              }
          }
      }
      """
    When the state machine executes
    Then the execution succeeded
    And the step result data is:
      """
      {
          "Param": <output>
      }
      """

    Examples: Strings
      | input | algo    | output                                                                                                                             |
      | ''    | MD5     | "d41d8cd98f00b204e9800998ecf8427e"                                                                                                 |
      | 'ABC' | MD5     | "902fbdd2b1df0c4f70b4a5d23525e932"                                                                                                 |
      | ''    | SHA-1   | "da39a3ee5e6b4b0d3255bfef95601890afd80709"                                                                                         |
      | 'ABC' | SHA-1   | "3c01bdbb26f358bab27f267924aa2c9a03fcfdb8"                                                                                         |
      | ''    | SHA-256 | "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"                                                                 |
      | 'ABC' | SHA-256 | "b5d4045c3f466fa91fe2cc6abe79232a1a57cdf104f7a26e716e0a1e2789df78"                                                                 |
      | ''    | SHA-384 | "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b"                                 |
      | 'ABC' | SHA-384 | "1e02dc92a41db610c9bcdc9b5935d1fb9be5639116f6c67e97bc1a3ac649753baba7ba021c813e1fe20c0480213ad371"                                 |
      | ''    | SHA-512 | "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e" |
      | 'ABC' | SHA-512 | "397118fdac8d83ad98813c50759c85b8c47565d8268bf10da483153b747a74743a58a90e85aa9f705ce6984ffc128db567489817e4092d050d8a1cc596ddc119" |
