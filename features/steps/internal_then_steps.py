from behave import then


@then(u"the parser fails")
def then_parser_fails(context):
    assert context.thrown is not None

@then(u'a "{class_name}" is created')
def then_object_is_created(context, class_name):
    pass

@then(u'the "{step_name}" step is a "{class_name}" type object')
def then_step_is_created_with_correct_object_type(context, step_name, class_name):
    pass
