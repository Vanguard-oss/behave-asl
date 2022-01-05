import jsonpath_ng


cache = {}


def get_instance(expr: str):
    """Get a jsonpath_ng instance"""
    global cache
    if expr not in cache:
        cache[expr] = jsonpath_ng.parse(expr)
    return cache[expr]
