import json

from behave import given

from behaveasl import parser
from behaveasl.models.execution import Execution


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


@given(u"the current state data is")
def step_impl(context):
    context.execution.set_current_state_data(json.loads(context.text))
