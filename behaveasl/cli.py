import sys

from .wrapper import main as behave_main


def main():
    """Delegate to the behave wrapper"""
    sys.exit(behave_main())
