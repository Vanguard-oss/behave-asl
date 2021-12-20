from behave import given
from behaveasl import parser


@given(u"a state machine defined by")
def given_load_definition_from_text(context):
    context.definition_text = context.text
    context.definition_dict = parser.parse_text(context.definition_text)


@given(u"an invalid state machine defined by")
def given_just_load_definition(context):
    context.definition_text = context.text
