import json


def load_settings(filename="settings.json"):
    with open(filename) as f:
        return json.load(f)


settings = load_settings()
