from behave import when
from behaveasl import parser


@when(u"the parser runs")
def when_parser_runs(context):
    context.thrown = None
    try:
        context.definition_dict = parser.parse_text(context.definition_text)
    except Exception as e:
        context.thrown = e
