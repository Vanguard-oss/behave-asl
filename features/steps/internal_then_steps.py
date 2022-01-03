from behave import then

from behaveasl.models.state_machine import StateMachineModel
from behaveasl.models.state_models import PassState, TaskState, ChoiceState, WaitState, SucceedState, FailState, ParallelState, MapState

@then(u"the parser fails")
def then_parser_fails(context):
    assert context.thrown is not None

@then(u'a "{class_name}" is created')
def then_object_is_created(context, class_name):
    assert isinstance(context.state_machine, StateMachineModel)

@then(u'the "{step_name}" step is a "{class_name}" object')
def then_step_is_created_with_correct_object_type(context, step_name, class_name):
    # Get the step out of the state machine
    step_to_evaluate = context.state_machine._states[step_name]
    step_class=str(type(step_to_evaluate))
    expected_class = f"<class 'behaveasl.models.state_models.{class_name}'>"
    # There should be a better way to do this w/isinstance and dynamic class loading but I can't think of it right now
    assert step_class == expected_class
