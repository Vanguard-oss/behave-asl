class StatesException(Exception):
    """Base Exception that contains an error and a cause"""

    def __init__(self, error, cause):
        self._error = error
        self._cause = cause
        super(StatesException, self).__init__(f"{error}: {cause}")

    @property
    def error(self):
        return self._error

    @property
    def cause(self):
        return self._cause


class StatesRuntimeException(StatesException):
    """A runtime exception that can't be caught"""

    def __init__(self, cause):
        super(StatesRuntimeException, self).__init__("States.Runtime", cause)


class StatesCompileException(Exception):
    """Exception that represents a compilation failure"""

    def __init__(self, cause):
        super(StatesCompileException, self).__init__(cause)


class StatesCatchableException(StatesException):
    """Exception that represents a catchable error"""

    def __init__(self, error: str, cause: str = ""):
        super(StatesCatchableException, self).__init__(error, cause)
        self._error = error

    @property
    def error(self) -> str:
        return self._error
