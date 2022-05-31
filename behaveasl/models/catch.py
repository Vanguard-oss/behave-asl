class Catch:
    def __init__(self, config: dict):
        self.error_list = config["ErrorEquals"]
        self.next = config["Next"]
        self.result_path = config.get("ResultPath", "$")
