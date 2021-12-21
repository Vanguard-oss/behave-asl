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
