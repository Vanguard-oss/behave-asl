from behave import then


@then(u"the parser fails")
def then_parser_fails(context):
    assert context.thrown is not None
