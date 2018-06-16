#!/usr/bin/env bash

set -xeuo pipefail

# check that /opt/conda has correct permissions
touch /opt/conda/bin/test_conda_forge

# check that conda is activated
conda info

# check that we can install a conda package
conda install --yes --quiet python -c conda-forge

touch /home/conda/feedstock_root/build_artifacts/conda-forge-build-done
