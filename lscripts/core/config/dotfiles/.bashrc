#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## .bashrc custom configurations
#
## CAUTION:
## 1. DO NOT Change the order of initialization/export
## 2. Make changes as desired and it's for reference only
## 3. Use at your own risk
###----------------------------------------------------------


export PATH="${HOME}/.local/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
# export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/libreoffice/program/libreglo.so"

### localhost config
[ -f ${HOME}/Documents/local/env.sh ] && source ${HOME}/Documents/local/env.sh

### lscripts-docker configuration
export LSCRIPTS__ROOT=${HOME}
export LSCRIPTS__PYVENV_PATH=${HOME}/virtualmachines/virtualenvs
export LSCRIPTS__DOCKER="${HOME}/external/lscripts-docker"
[ -f ${LSCRIPTS__DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS__DOCKER}/lscripts/lscripts.env.sh

### virtualenvwrapper
export WORKON_HOME=${LSCRIPTS__PYVENV_PATH}
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
[ -f ${HOME}/.local/bin/virtualenvwrapper.sh ] && source ${HOME}/.local/bin/virtualenvwrapper.sh

### NVM and NPM for nodejs
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NPM_PACKAGES=${HOME}/.npm-packages
export PATH=${NPM_PACKAGES}/bin:${PATH}
## export MANPATH='/share/man:${HOME}/.local/man:/usr/local/man:/usr/local/share/man:/usr/share/man'

### cuda
export CUDA_HOME="/usr/local/cuda"
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu"

### aihub
export __AIMLHUB_ROOT__="${HOME}/codehub/aihub"
