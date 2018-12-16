# Anaconda

## Installation

To use this segment, you need to activate it by adding `anaconda` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment shows your active anaconda environment. It relies on either the
`CONDA_ENV_PATH` or the `CONDA_PREFIX` (depending on the `conda` version)
environment variable to be set which happens when you properly `source
activate` an environment.

Special configuration variables:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_ANACONDA_LEFT_DELIMITER`|"("|The left delimiter just before the environment name.|
|`P9K_ANACONDA_RIGHT_DELIMITER`|")"|The right delimiter just after the environment name.|

Additionally the following segment specific parameters can be used to customize
it: `P9K_PYTHON_ICON`, `P9K_ANACONDA_BACKGROUND`, and
`P9K_ANACONDA_FOREGROUND`.