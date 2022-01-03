class Retry:
    def __init__(self, error_list, interval_seconds, max_attempts, backoff_rate):
        self.error_list = error_list
        self.interval_seconds = interval_seconds
        self.max_attempts = max_attempts
        self.backoff_rate = backoff_rate

    def _execute(self):
        # TODO: implement
        pass
