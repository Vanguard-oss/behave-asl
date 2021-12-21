import json

from behave import when

from behaveasl import parser


@when(u"the parser runs")
def when_parser_runs(context):
    context.thrown = None
    try:
        context.definition_dict = parser.parse_text(context.definition_text)
    except Exception as e:
        context.thrown = e


@when(u"the step result is")
def when_step_result_is(context):
    context.execution.last_step_result.result_data = json.loads(context.text)


@when(u'the step sets "{name}" as the next state')
def when_set_next_state(context, name):
    context.execution.last_step_result.next_state = name


@when(u"the step ends the execution in a successful state")
def when_end_success(context):
    context.execution.last_step_result.end_execution = True
    context.execution.last_step_result.failed = False


@when(u"the step ends the execution in a failure state")
def when_end_failure(context):
    context.execution.last_step_result.end_execution = True
    context.execution.last_step_result.failed = True
