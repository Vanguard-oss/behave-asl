from behave import given

from behaveasl.steps.given_steps import create_state_machine


@given(u"a state machine defined by")
def given_load_definition_from_text(context):
    context.definition_text = context.text
    create_state_machine(context)


@given(u"a simple state machine")
def given_load_simple_state_machine(context):
    context.definition_text = """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Pass",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    create_state_machine(context)


@given(u"an invalid state machine defined by")
def given_just_load_definition(context):
    context.definition_text = context.text
