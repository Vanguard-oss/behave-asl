import json
import logging

from behave import then

from behaveasl import assertions, jsonpath


LOG = logging.getLogger("behaveasl.steps.then")


@then('the step result data path "{path}" does not exist')
def then_result_data_path_does_not_exist(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 0


@then('the step result data path "{path}" matches "{value}"')
def then_match_result_data(context, path, value):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert str(results[0].value) == value


@then('the step result data path "{path}" is null')
def then_result_data_is_none(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert results[0].value is None

@then('the step result data path "{path}" is true')
def then_result_data_is_none(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert results[0].value == True

@then('the step result data path "{path}" is false')
def then_result_data_is_none(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert results[0].value == False


@then('the step result data path "{path}" contains "{value}"')
def then_contains_result_data(context, path, value):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert value in results[0].value


@then('the step result data path "{path}" has "{value}" entry')
@then('the step result data path "{path}" has "{value}" entries')
def then_result_data_list_size(context, path, value):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    assert len(results[0].value) == int(value)


@then('the step result data path "{path}" is an int')
def then_result_data_is_int(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    t = type(results[0].value)
    if t != int:
        LOG.critical(f"{path} is {t}")
        assert t == int


@then('the step result data path "{path}" is a string')
def then_result_data_is_str(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    t = type(results[0].value)
    if t != str:
        LOG.critical(f"{path} is {t}")
        assert t == str


@then('the step result data path "{path}" is a list')
def then_result_data_is_list(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    t = type(results[0].value)
    if t != list:
        LOG.critical(f"{path} is {t}")
        assert t == list


@then('the step result data path "{path}" has length "{length}"')
def then_result_data_is_list(context, path, length):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1

    assert len(results[0].value) == int(length)


@then('the step result data path "{path}" is a dict')
def then_result_data_is_dict(context, path):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.last_step_result.result_data)
    assert len(results) == 1
    t = type(results[0].value)
    if t != dict:
        LOG.critical(f"{path} is {t}")
        assert t == dict


@then("the step result data is")
def then_full_match(context):
    assert context.text is not None
    assertions.assert_json_matches(
        context.text, context.execution.last_step_result.result_data
    )


@then("branches were called with")
def step_impl(context):
    assert context.text is not None
    assertions.assert_json_matches(
        context.text, context.execution.last_step_result.branch_input
    )


@then('the context path "{path}" matches "{value}"')
def step_impl(context, path, value):
    jpexpr = jsonpath.get_instance(path)
    results = jpexpr.find(context.execution.context)
    assert len(results) == 1
    t = results[0].value
    assert t == int(value)


@then('the next state is "{name}"')
def then_next_state(context, name):
    assert not context.execution.last_step_result.end_execution
    try:
        assert context.execution.last_step_result.next_state == name
    except AssertionError:
        print(
            f"Expected next state of: {name} - received: {context.execution.last_step_result.next_state}"
        )
        raise


@then("the execution ended")
def then_execution_ended(context):
    assert context.execution.last_step_result.end_execution


@then("the execution succeeded")
def then_execution_successful(context):
    assert not context.execution.last_step_result.failed


@then("the execution failed")
def then_execution_failed(context):
    assert context.execution.last_step_result.failed


@then('the execution error was "{error}"')
def then_error_was(context, error):
    assert context.execution.last_step_result.error == error


@then("the execution error was null")
def then_error_was_null(context):
    assert context.execution.last_step_result.error is None


@then('the execution error cause was "{cause}"')
def then_error_cause_was(context, cause):
    assert context.execution.last_step_result.cause == cause


@then("the execution error cause was null")
def then_error_cause_was_null(context):
    assert context.execution.last_step_result.cause is None


@then('the execution error cause contained "{cause}"')
def then_error_cause_contained(context, cause):
    assert cause in context.execution.last_step_result.cause


@then('the last state waited for "{num}" seconds')
def then_waited_seconds(context, num):
    assert int(num) == context.execution.last_step_result.waited_seconds


@then('the last state waited until "{timestamp}"')
def then_waited_until_timestamp(context, timestamp):
    assert timestamp == context.execution.last_step_result.waited_until_timestamp


@then(
    'the JSON output of "{state_name}" is'
)  # this will precede an array/json response
def then_output_is_json(context, state_name):
    assert context.execution.last_step_result.result_data == json.loads(context.text)


@then('the sorted JSON output of "{state_name}" is')
def then_sorted_json(context, state_name):
    assert (
        context.execution.last_step_result.result_data.sort()
        == json.loads(context.text).sort()
    )
