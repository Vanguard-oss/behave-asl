from behave import given
from behaveasl import parser


@given(u'a state machine defined in "{filename}"')
def given_load_definition_from_file(context, filename):
    with open(filename, "r") as f:
        context.definition_text = f.read()
    context.definition_dict = parser.parse_text(context.definition_text)
