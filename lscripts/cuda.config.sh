#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## CUDA Config
###----------------------------------------------------------
## Nvidia GTX 1080 Ti, Driver 390.42, CUDA 9.1
#
## execute the script with `source` command
## example:
## source cuda.config.sh
###----------------------------------------------------------


function cuda_config() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  #FILE=$HOME/.bashrc
  local FILE=${BASHRC_FILE}
  local LINE

  if [ ! -z "${BASHRC_FILE}" ]; then
    FILE=${BASHRC_FILE}
  fi

  if [ -z "${CUDA_VER}" ]; then
    local CUDA_VER="9.0"
  fi

  # LINE='export CUDA_HOME="/usr/local/cuda-'${CUDA_VER}'"'
  LINE='export CUDA_HOME="/usr/local/cuda"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export PATH="/usr/local/cuda/bin:$PATH"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  # this will work only if the script is invoked with `source` command
  source ${FILE}

  echo ""
  echo "Checking...CUDA_HOME..."
  echo ${CUDA_HOME}
  echo ""

  if [ -z "${CUDA_HOME}" ]; then
    echo "Run manually or open the new shell"
    echo "source ~/.bashrc"
    echo "Exporting the ENV variables: CUDA_HOME, PATH, LD_LIBRARY_PATH"
    #
    source $FILE
    export CUDA_HOME="/usr/local/cuda"
    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${CUDA_HOME}/lib64"
  fi

  echo ""
  echo "Check the CUDA compiler version"
  nvcc -V
  echo ""

  ## Test if the drivers are working by going to your sample directory
  echo "Test if the drivers are working by going to your sample directory"
  echo "Compiling: $CUDA_HOME/samples/1_Utilities/deviceQuery"
  echo ""

  cd ${CUDA_HOME}/samples
  #sudo chown -R <username>:<usergroup> .
  sudo chown -R $(whoami):$(whoami) .
  cd 1_Utilities/deviceQuery
  make
  ./deviceQuery    

  echo ""
  echo "cat /proc/driver/nvidia/version"
  echo ""
  cat /proc/driver/nvidia/version

  cd ${LSCRIPTS}
}

cuda_config
