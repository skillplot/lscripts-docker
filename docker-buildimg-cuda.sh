#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Building Nvidia CUDA Docker Images from source
###----------------------------------------------------------
#
## References:
## * https://gitlab.com/nvidia/container-images/cuda
## * https://stackoverflow.com/questions/13470413/converting-a-bash-array-into-a-delimited-string
#
## Logs:
## debconf: delaying package configuration, since apt-utils is not installed
## Warning: apt-key output should not be parsed (stdout is not a terminal)
###----------------------------------------------------------


function __docker-buildimg-cuda() {
  declare -a cuda_vers=($(_nvidia_.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  [[ ${_LSCRIPTS__DEBUG_} -eq 0 ]] || {
    (>&2 echo -e "Total: ${#cuda_vers[@]}, Supported cuda_vers: ${cuda_vers[@]}")
    # (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)
  }

  : ${1?
    "Usage:
    bash $0 <cudaversion> [ ${vers} ]"
  }

  _fio_.find_in_array "$1" "${cuda_vers[@]}" &>/dev/null && {
    local BUILD_FOR_CUDA_VER=$1
    _log_.info "Using CUDA version: ${BUILD_FOR_CUDA_VER}"

    local CUDACFG_FILEPATH="${LSCRIPTS}/lscripts/config/${LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
    _log_.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

    ls -1 ${CUDACFG_FILEPATH} &>/dev/null || _log_.fail "config file does not exists: ${CUDACFG_FILEPATH}"
    # ## echo "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"
    # ## local AI_PYCUDA_FILE=${LSCRIPTS}/lscripts/config/${LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
    # ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

    source ${CUDACFG_FILEPATH}
    local DOCKERFILE_BASEPATH="${LSCRIPTS}/external/cuda/dist/${OS}/${CUDA_VERSION}"
    _log_.debug "DOCKERFILE_BASEPATH: ${DOCKERFILE_BASEPATH}"

    local _default=no
    local _que
    local _msg

    ## build base, runtime and devel
    _que="Build Image ${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-base-${OS} now"
    _msg="Skipping build image!"
    _fio_.yesno_${_default} "${_que}" && \
        _log_.echo "Executing..." && \
        docker build -t "${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" "${DOCKERFILE_BASEPATH}/base" && \
        docker run --gpus all --rm "${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" nvidia-smi \
      || _log_.echo "${_msg}"

    _que="Build Image ${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS} now"
    _msg="Skipping build image!"
    _fio_.yesno_${_default} "${_que}" && \
        _log_.echo "Executing..." && \
        docker build -t "${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${NVIDIA_CUDA_IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/runtime" && \
        docker run --gpus all --rm "${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" nvidia-smi \
      || _log_.echo "${_msg}"

    _que="Build Image ${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-devel-${OS} now"
    _msg="Skipping build image!"
    _fio_.yesno_${_default} "${_que}" && \
        _log_.echo "Executing..." && \
        docker build -t "${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${NVIDIA_CUDA_IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/devel" && \
        docker run --gpus all --rm "${NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" nvidia-smi \
      || _log_.echo "${_msg}"
  } 1>&2 || _log_.fail "Invalid or not supported CUDA version: $1"
}

function docker-buildimg-cuda() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local _default=yes
  local _que
  local _msg
  local _prog

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || _log_.fail "Dependency docker-ce-verify is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-verify.sh"

  type nvidia-container-toolkit &>/dev/null \
    || _log_.fail "Dependency nvidia-container-toolkit is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/nvidia-container-toolkit-install.sh"

  # type uuid &>/dev/null || _log_.fail "uuid package not found. Execute...\n sudo apt install uuid"

  _prog="docker-buildimg-cuda"

  _que="Executing ${_prog} now"
  _msg="Skipping ${_prog} execution!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Executing..." && \
      __${_prog} $1 \
    || _log_.echo "${_msg}"

}

docker-buildimg-cuda $1
