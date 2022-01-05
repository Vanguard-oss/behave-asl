from setuptools import find_packages, setup


setup(
    author="Vanguard",
    author_email="opensource@vanguard.com",
    classifiers=[
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
    ],
    description="",
    install_requires=[
        "behave>=1.0.25",
        "diff_match_patch==20200713",
        "jsonpath_ng<2.0.0",
        "PyYAML>=5.4.1",
    ],
    name="behave-asl",
    packages=find_packages(),
    entry_points={
        "console_scripts": [
            "behave-asl = behaveasl.cli:main",
        ]
    },
    url=("https://github.com/vanguard/behave-asl"),
    version="0.1.0",
)
