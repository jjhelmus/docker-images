#!/usr/bin/env bash

set -xeuo pipefail

# check that /opt/conda has correct permissions
touch /opt/conda/bin/test_conda_forge

# check that conda is activated
conda info

touch /home/conda/feedstock_root/build_artifacts/conda-forge-build-done
