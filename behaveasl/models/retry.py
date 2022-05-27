class Retry:
    def __init__(self, config: dict):
        self.error_list = config["ErrorEquals"]
        self.interval_seconds = config.get("IntervalSeconds", 1)
        self.max_attempts = config.get("MaxAttempts", 3)
        self.backoff_rate = config.get("BackoffRate", 2.0)
