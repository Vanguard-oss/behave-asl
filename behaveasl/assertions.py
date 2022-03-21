import json
import logging
from urllib.parse import unquote

from diff_match_patch import diff_match_patch


LOG = logging.getLogger("behave.assertions")


def assert_json_matches(expected: str, actual: dict):
    # If the expected is short enough, don't bother creating a multi-line
    # indentation because it can be easier to visually see the difference
    # without it
    if len(expected) > 20:
        canonical_expected = json.dumps(json.loads(expected), indent=2, sort_keys=True)
        canonical_actual = json.dumps(actual, indent=2, sort_keys=True)
    else:
        canonical_expected = json.dumps(json.loads(expected), sort_keys=True)
        canonical_actual = json.dumps(actual, sort_keys=True)

    if canonical_expected != canonical_actual:
        # Print out the values to make it easier to identify what the
        # difference is between the values
        LOG.warn("Expected: " + canonical_expected)
        LOG.warn("Actual: " + canonical_actual)

        # Perform a "diff" to try and see the difference
        dmp = diff_match_patch()
        patches = dmp.patch_make(canonical_actual, canonical_expected)
        diff = dmp.patch_toText(patches)
        LOG.warn(unquote(diff))
    assert canonical_expected == canonical_actual
