#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------------
## ~/.bashrc configuration 
###----------------------------------------------------------

shopt -s direxpand

export PATH="${HOME}/.local/bin:/usr/local/bin:${PATH}"
export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
# export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/libreoffice/program/libreglo.so"
## https://askubuntu.com/questions/913812/libreoffice-stopped-working-in-ubuntu-17-04
## /usr/lib/libreoffice/program/libreglo.so
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib/libreoffice/program

export __CODEHUB_ROOT__="/codehub"
export __DATAHUB_ROOT__="/datahub"
export __AIMLHUB_ROOT__="${__CODEHUB_ROOT__}/aihub"
export __DATAHUB_ROOT_V1__="${__DATAHUB_ROOT__}"
export __DATAHUB_ROOT_V2__="${__DATAHUB_ROOT__}"

### lscripts-docker configuration

export LSCRIPTS__CODEHUB_ROOT=${__CODEHUB_ROOT__}
export LSCRIPTS__DATAHUB_ROOT=${__DATAHUB_ROOT__}
# export LSCRIPTS__AIMLHUB_ROOT=${__AIMLHUB_ROOT__}
# export LSCRIPTS__EXTERNAL_HOME="${__CODEHUB_ROOT__}/external"
# export LSCRIPTS__DOWNLOADS="${HOME}/Downloads"
# export LSCRIPTS__AUTH="${HOME}/Documents/cred"
# export LSCRIPTS__VMHOME="${__DATAHUB_ROOT__}/virtualmachines/virtualenvs"
# export LSCRIPTS__PYVENV_PATH="${__DATAHUB_ROOT__}/virtualmachines/virtualenvs"

[[ ! -L "$HOME/.cred" ]] || [[ ! -d "$HOME/.cred" ]] && {
  ln -s "${LSCRIPTS__AUTH}" "$HOME/.cred"
  ls -lrt "$HOME/.cred"
}

# ## vim
# if [ ! -L ${HOME}/.vimrc ]; then
#   ln -s $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/vim/vimrc ${HOME}/.vimrc
# fi

## keras
if [[ ! -L ${HOME}/.keras ]]; then
  ln -s ${__DATAHUB_ROOT__}/release/keras ${HOME}/.keras
fi
export KERAS_HOME=${__DATAHUB_ROOT__}/release/keras

### virtualenvwrapper
export WORKON_HOME=${LSCRIPTS__PYVENV_PATH}
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
[ -f ${HOME}/.local/bin/virtualenvwrapper.sh ] && source ${HOME}/.local/bin/virtualenvwrapper.sh

# ### Java
# export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
# export PATH="${PATH}:/usr/lib/jvm/java-8-openjdk-amd64/bin"
# export PATH_TO_FX=/usr/share/openjfx/lib
# # export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server:${LD_LIBRARY_PATH}"
# export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server:${PATH_TO_FX}:${LD_LIBRARY_PATH}"

## ruby, gem, asciidoctor
if [[ ! -L ${HOME}/.ruby ]]; then
  ln -s ${__DATAHUB_ROOT__}/ruby ${HOME}/.ruby
fi

## export GEM_HOME=~/.gem
## export GEM_PATH=~/.gem
export GEM_HOME=${__DATAHUB_ROOT__}/ruby
export PATH="${PATH}:${GEM_HOME}/bin"

### NVM and NPM for nodejs
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NPM_PACKAGES=${HOME}/.npm-packages
export PATH=${NPM_PACKAGES}/bin:${PATH}
## Unset manpath so we can inherit from /etc/manpath via the `manpath` command
## unset MANPATH # delete if you already modified MANPATH elsewhere in your config
## export MANPATH='/share/man:${HOME}/.local/man:/usr/local/man:/usr/local/share/man:/usr/share/man'

### cuda
export CUDA_HOME="/usr/local/cuda"
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu"

export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$CUDA_HOME/lib64"

# ## bender
# export PATH=${PATH}:${__CODEHUB_ROOT__}/external/blender

# ## meshlab
# export PATH=${PATH}:${__CODEHUB_ROOT__}/external/meshlab/src/distrib
