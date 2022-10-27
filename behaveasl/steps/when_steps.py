from behave import when


@when("the state machine executes")
def when_exec(context):
    context.execution.execute()

