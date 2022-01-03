from behaveasl.models.abstract_state import AbstractStateModel
from behaveasl.models.choice import Choice
from behaveasl.models.retry import Retry

# Order of classes follows: https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-common-fields.html
class PassState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        
        pass

    def execute(self, state_input):
        ''' The fail state will always raise an error with a cause '''
        # TODO: implement
        pass 

class TaskState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        pass
    # def __init__(self, state_name, state_details):
        # self.state_name = state_name
        # self.resource = None
        # self.next_state = None
        # self.retry_list = None
        # self.input = None # For a non-SDK call - note that input and parameters will both work for either SDK or non-SDK calls
        # self.parameters = None # For an SDK call - note that input and parameters will both work for either SDK or non-SDK calls
        # # TODO: for retry in retry_list, create an instance of Retry and add it to the list
        pass

    def execute(self, state_input):
        # TODO: implement
        pass 

class ChoiceState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        
        pass
    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     self.choice_list = None
    #     # TODO: for choice in choice_list, create an instance of Choice and add it to the list
    #     pass

    def execute(self, state_input):
        # TODO: implement
        pass
    
class WaitState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        
        pass
    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        ''' The fail state will always raise an error with a cause '''
        # TODO: implement
        pass

class SucceedState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        
        pass
    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        # TODO: implement
        pass 

class FailState(AbstractStateModel):
    '''The Fail state terminates the machine and marks it as a failure'''
    def __init__(self, *args, **kwargs):
        
        pass
    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        ''' The fail state will always raise an error with a cause '''
        # TODO: implement
        pass 
    

class ParallelState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        
        pass
    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        ''' The fail state will always raise an error with a cause '''
        # TODO: implement
        pass

class MapState(AbstractStateModel):
    def __init__(self, *args, **kwargs):
        
        pass
    # def __init__(self, state_name, state_details):
    #     self.state_name = state_name
    #     pass

    def execute(self, state_input):
        ''' The fail state will always raise an error with a cause '''
        # TODO: implement
        pass 