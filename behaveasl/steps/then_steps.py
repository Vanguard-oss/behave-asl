from behave import then

from behaveasl import assertions, jsonpath


@then(u'the step result data path "{path}" does not exist')
def then_result_data_path_does_not_exist(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 0


@then(u'the step result data path "{path}" matches "{value}"')
def then_match_result_data(context, path, value):
    print(str(context.execution.last_step_result.result_data))
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert str(results[0].value) == value


@then(u'the step result data path "{path}" is null')
def then_result_data_is_none(context, path):
    print(str(context.execution.last_step_result.result_data))
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert results[0].value is None


@then(u'the step result data path "{path}" contains "{value}"')
def then_contains_result_data(context, path, value):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert value in results[0].value


@then(u'the step result data path "{path}" has "{value}" entry')
@then(u'the step result data path "{path}" has "{value}" entries')
def then_result_data_list_size(context, path, value):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert len(results[0].value) == int(value)


@then(u'the step result data path "{path}" is an int')
def then_result_data_is_int(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert type(results[0].value) == int


@then(u'the step result data path "{path}" is a string')
def then_result_data_is_str(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    print(str(context.execution.last_step_result.result_data))
    assert len(results) == 1
    assert type(results[0].value) == str


@then(u'the step result data path "{path}" is a list')
def then_result_data_is_list(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert type(results[0].value) == list


@then(u'the step result data path "{path}" is a dict')
def then_result_data_is_dict(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert type(results[0].value) == dict


@then(u"the step result data is")
def then_full_match(context):
    assert context.text is not None
    assertions.assert_json_matches(
        context.text, context.execution.last_step_result.result_data
    )


@then(u'the next state is "{name}"')
def then_next_state(context, name):
    assert context.execution.last_step_result.next_state == name
    assert not context.execution.last_step_result.end_execution


@then(u"the execution ended")
def then_execution_ended(context):
    assert context.execution.last_step_result.end_execution


@then(u"the execution succeeded")
def then_execution_successful(context):
    assert not context.execution.last_step_result.failed


@then(u"the execution failed")
def then_execution_failed(context):
    assert context.execution.last_step_result.failed


@then(u'the execution error was "{error}"')
def then_error_was(context, error):
    assert context.execution.last_step_result.error == error


@then(u"the execution error was null")
def then_error_was_null(context):
    assert context.execution.last_step_result.error is None


@then(u'the execution error cause was "{cause}"')
def then_error_cause_was(context, cause):
    assert context.execution.last_step_result.cause == cause


@then(u"the execution error cause was null")
def then_error_cause_was_null(context):
    assert context.execution.last_step_result.cause is None


@then(u'the execution error cause contained "{cause}"')
def then_error_cause_contained(context, cause):
    assert cause in context.execution.last_step_result.cause


@then(u'the last state waited for "{num}" seconds')
def then_waited_seconds(context, num):
    assert int(num) == context.execution.last_step_result.waited_seconds


@then(u'the last state waited until "{timestamp}"')
def then_waited_until_timestamp(context, timestamp):
    assert timestamp == context.execution.last_step_result.waited_until_timestamp
