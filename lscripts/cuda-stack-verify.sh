#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## cuda-stack installation verification
###----------------------------------------------------------


function cuda-stack-verify() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  export CUDA_HOME="/usr/local/cuda"
  export PATH="/usr/local/cuda/bin:${PATH}"
  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64"

  local _cmd="nvcc"
  _log_.info "Verifying ${_cmd} installation..."

  type ${_cmd} &>/dev/null && {
    _log_.info "Check the CUDA compiler version"
    ${_cmd} -V
    _log_.ok "${_cmd} is available!"

    _log_.info "Testing if the drivers are working..."

    [[ -d "${CUDA_HOME}/samples" ]] && {
      _log_.info "Compiling: ${CUDA_HOME}/samples/1_Utilities/deviceQuery"

      sudo chown -R $(whoami):$(whoami) "${CUDA_HOME}/samples"
      cd "${CUDA_HOME}/samples/1_Utilities/deviceQuery"
      make
      ./deviceQuery  
      cd -
      return 0
    } 1>&2 || (error "Cuda samples does not exists: ${CUDA_HOME}/samples" && return -1)
  } 1>&2 || {
    _log_.error "${_cmd} not installed or corrupted!"
    return -1
  }

}

cuda-stack-verify
