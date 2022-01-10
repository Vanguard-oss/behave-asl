import json
from urllib.parse import unquote

from diff_match_patch import diff_match_patch


def assert_json_matches(expected: str, actual: dict):
    canonical_expected = json.dumps(json.loads(expected), indent=2, sort_keys=True)
    canonical_actual = json.dumps(actual, indent=2, sort_keys=True)

    if canonical_expected != canonical_actual:
        dmp = diff_match_patch()
        patches = dmp.patch_make(canonical_actual, canonical_expected)
        diff = dmp.patch_toText(patches)
        print(unquote(diff))
    assert canonical_expected == canonical_actual
