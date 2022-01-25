import json

from behave import given
from behaveasl import parser
from behaveasl.models.execution import Execution
from behaveasl.models.task_mock import (
    AnyParameters,
    AssertParameters,
    StaticResponse,
)


def create_state_machine(context):
    context.definition_dict = parser.parse_text(context.definition_text)
    context.state_machine = parser.create_state_machine(input=context.definition_dict)
    context.execution = Execution(state_machine=context.state_machine)


@given(u'a state machine defined in "{filename}"')
def given_load_definition_from_file(context, filename):
    with open(filename, "r") as f:
        context.definition_text = f.read()

    create_state_machine(context)


@given(u'the state machine is current at the state "{name}"')
def given_set_current_state(context, name):
    context.execution.set_current_state_name(name)


@given("the current state data is")
def given_set_current_state_data(context):
    context.execution.set_current_state_data(json.loads(context.text))


@given("the execution input is")
def given_set_execution_input(context):
    context.execution.set_execution_input_data(json.loads(context.text))


@given(u'the resource "{resource}" will return')
@given(u'the map state "{resource} will return')
def given_resource_will_return(context, resource):
    context.execution.resource_response_mocks.add_mock(
        resource, StaticResponse(json.loads(context.text))
    )


@given(u'the resource "{resource}" will be called with any parameters and return')
@given(u'the map state "{resource}" will be called with any parameters and return')
def given_resource_any_param_will_return(context, resource):
    context.execution.resource_response_mocks.add_mock(
        resource, StaticResponse(json.loads(context.text))
    )
    context.execution.resource_expectations.add_mock(resource, AnyParameters())


@given(u'the resource "{resource}" will be called with')
@given(u'the map state "{resource}" will be called with')
def given_resource_expect_param(context, resource):
    context.execution.resource_expectations.add_mock(
        resource, AssertParameters(context.text)
    )
