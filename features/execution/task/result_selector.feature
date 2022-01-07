Feature: The Task type can filter results by using OutputPath

  Scenario: The Task type can use '$' in the OutputPath to copy everything
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Next": "EndState",
                "Resource": "EMR",
                "ResultSelector": {
                    "ClusterId.$": "$.output.ClusterId",
                    "ResourceType.$": "$.resourceType"
                },
                "ResultPath": "$.EMROutput",
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "resourceType": "elasticmapreduce",
        "resource": "createCluster.sync",
        "output": {
            "SdkHttpMetadata": {
                "HttpHeaders": {
                    "Content-Length": "1112",
                    "Content-Type": "application/x-amz-JSON-1.1",
                    "Date": "Mon, 25 Nov 2019 19:41:29 GMT",
                    "x-amzn-RequestId": "1234-5678-9012"
                },
                "HttpStatusCode": 200
            },
            "SdkResponseMetadata": {
                "RequestId": "1234-5678-9012"
            },
            "ClusterId": "AKIAIOSFODNN7EXAMPLE"
        }
    }
    """
    When the state machine executes
    Then the next state is "EndState"
    And the step result data path "$.EMROutput.ResourceType" is a string
    And the step result data path "$.EMROutput.ResourceType" matches "elasticmapreduce"
    And the step result data path "$.EMROutput.ClusterId" is a string
    And the step result data path "$.EMROutput.ClusterId" matches "AKIAIOSFODNN7EXAMPLE"
