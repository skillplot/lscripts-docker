#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


__LSCRIPTS__=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

export PATH="${HOME}/.local/bin:/usr/local/bin:${PATH}"
export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

export __CODEHUB_ROOT__="$HOME/codehub"
export __DATAHUB_ROOT__="$HOME/datahub"
export __DATAHUB_ROOT_V1__="${__DATAHUB_ROOT__}"
export __DATAHUB_ROOT_V2__="${__DATAHUB_ROOT_V1__}"
export __DATAHUB_ROOT_V3__="${__DATAHUB_ROOT_V2__}"
export __AIMLHUB_ROOT__="${__CODEHUB_ROOT__}/aihub"
export LSCRIPTS__PYVENV_PATH=${__DATAHUB_ROOT__}/virtualmachines/virtualenvs
export __LSCRIPTS_DOCKER="${__CODEHUB_ROOT__}/external/lscripts-docker"
[ -f ${__LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${__LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh

### virtualenvwrapper
export WORKON_HOME=${LSCRIPTS__PYVENV_PATH}
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
[ -f ${HOME}/.local/bin/virtualenvwrapper.sh ] && source ${HOME}/.local/bin/virtualenvwrapper.sh

### cuda
export CUDA_HOME="/usr/local/cuda"
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu"

shopt -s direxpand

## Load history from the file and append new commands
#export PROMPT_COMMAND="history -a; history -n"

_LOG__HAS_FILE=False

[ -f ${HOME}/Documents/local/custom.sh ] && source ${HOME}/Documents/local/custom.sh
