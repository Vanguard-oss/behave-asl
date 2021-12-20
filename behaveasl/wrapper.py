import os
import sys

from behave import __version__ as behave_version
from behave.configuration import ConfigError, Configuration
from behave.runner import Runner


class CustomRunner(Runner):
    """Custom Runner that can be used to execute bundled steps"""

    def _choose_initial_base_dir(self):
        """This is the first part of behave/runner.py Runner.setup_paths()"""
        if self.config.paths:
            if self.config.verbose:
                print(
                    "Supplied path:",
                    ", ".join('"%s"' % path for path in self.config.paths),
                )
            first_path = self.config.paths[0]
            if hasattr(first_path, "filename"):
                # -- BETTER: isinstance(first_path, FileLocation):
                first_path = first_path.filename
            base_dir = first_path
            if base_dir.startswith("@"):
                # -- USE: behave @features.txt
                base_dir = base_dir[1:]
                file_locations = self.feature_locations()
                if file_locations:
                    base_dir = os.path.dirname(file_locations[0].filename)
            base_dir = os.path.abspath(base_dir)

            # supplied path might be to a feature file
            if os.path.isfile(base_dir):
                if self.config.verbose:
                    print("Primary path is to a file so using its directory")
                base_dir = os.path.dirname(base_dir)
        else:
            if self.config.verbose:
                print('Using default path "./features"')
            base_dir = os.path.abspath("features")
        return base_dir

    def setup_paths(self):
        self.initial_base_dir = self._choose_initial_base_dir()
        try:
            super(CustomRunner, self).setup_paths()
        except ConfigError as e:
            # Behave forces the steps folder to live in the features folder
            # If it isn't there, then it throws a ConfigError
            # We catch the ConfigError, then assume the basedir
            # is the one we guessed at before doing the validation
            base_dir = os.path.abspath(self.initial_base_dir)
            self.config.base_dir = base_dir
            self.base_dir = base_dir
            self.path_manager.add(base_dir)

            if not self.config.paths:
                self.config.paths = [base_dir]

            if base_dir != os.getcwd():
                self.path_manager.add(os.getcwd())

    def load_step_definitions(self, extra_step_paths=None):
        """Load steps from the bundled steps folder"""
        if behave_version == "1.2.5":
            if not extra_step_paths:
                extra_step_paths = []
            try:
                self.base_dir = os.path.dirname(__file__)
                super(CustomRunner, self).load_step_definitions(extra_step_paths)
            finally:
                self.base_dir = self.config.base_dir
        else:
            from behave.runner_util import load_step_modules

            load_step_modules([os.path.dirname(__file__) + "/steps"])


def main(args=None):
    config = Configuration(args)

    if behave_version == "1.2.5":
        config.format = [config.default_format]

        runner = CustomRunner(config)

        runner.run()
    else:
        from behave.__main__ import run_behave

        return run_behave(config, CustomRunner)


if __name__ == "__main__":
    sys.exit(main())
