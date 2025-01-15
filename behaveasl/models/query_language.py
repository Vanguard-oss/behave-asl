from enum import Enum


class QueryLanguage(Enum):
    JSONPATH = 1
    JSONATA = 2


def get_query_language(name: str) -> QueryLanguage:
    langs = {
        "JSONPath": QueryLanguage.JSONPATH,
        "JSONata": QueryLanguage.JSONATA,
    }
    return langs.get(name, QueryLanguage.JSONPATH)
