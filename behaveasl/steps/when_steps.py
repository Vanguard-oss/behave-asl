from behave import when


@when(u"the state machine executes")
def when_exec(context):
    context.execution.execute()
