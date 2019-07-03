#!/usr/bin/env bash

set -xeuo pipefail

# test for working en_US.UTF-8 locale
locale -a | grep -i 'en_US.UTF.\?8'
[ "$( LC_ALL=en_US.UTF-8 sh -euc : 2>&1 )" = "" ]
# make sure the above fails for non-existent locale
[ ! "$( LC_ALL=badlocale sh -euc : 2>&1 )" = "" ]

# check that /opt/conda has correct permissions
touch /opt/conda/bin/test_conda_forge

# check that conda is activated
conda info

# show all packages installed in root
conda list

# check that we can install a conda package
conda install --yes --quiet conda-forge-pinning -c conda-forge

touch /home/conda/feedstock_root/build_artifacts/conda-forge-build-done
