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
  declare -a cuda_vers=($(lsd-mod.cuda.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    (>&2 echo -e "Total: ${#cuda_vers[@]}, Supported cuda_vers: ${cuda_vers[@]}")
    # (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)
  }

  : ${1?
    "Usage:
    bash $0 <cudaversion> [ ${vers} ]"
  }

  lsd-mod.fio.find_in_array "$1" "${cuda_vers[@]}" &>/dev/null && {
    local BUILD_FOR_CUDA_VER=$1
    lsd-mod.log.info "Using CUDA version: ${BUILD_FOR_CUDA_VER}"

    LINUX_DISTRIBUTION=ubuntu18.04
    local CUDACFG_FILEPATH="${LSCRIPTS}/lscripts/core/config/${LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
    lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

    ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}"
    # ## echo "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"
    # ## local AI_PYCUDA_FILE=${LSCRIPTS}/lscripts/core/config/${LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
    # ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

    source ${CUDACFG_FILEPATH}

    ## TODO: support for latest cuda repo directory structure and end-of-life version builds
    
    local OS='ubuntu1804'
    local DOCKERFILE_BASEPATH="${LSCRIPTS}/external/cuda/dist/${OS}/${CUDA_VERSION}"
    local DOCKERFILE_BASEPATH="${LSCRIPTS}/external/cuda/dist/end-of-life/10.2/ubuntu1804"
    lsd-mod.log.debug "DOCKERFILE_BASEPATH: ${DOCKERFILE_BASEPATH}"

    local _default=yes
    local _que
    local _msg

    lsd-mod.log.echo "NVIDIA_CUDA_IMAGE_NAME...: ${NVIDIA_CUDA_IMAGE_NAME}"
    lsd-mod.log.echo "__NVIDIA_CUDA_IMAGE_NAME...: ${__NVIDIA_CUDA_IMAGE_NAME}"

    local TARGETARCH="linux/amd64"
    __NVIDIA_CUDA_IMAGE_NAME='skplt.org'
    ## build base, runtime and devel
    _que="Build Image ${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-base-${OS} now"
    _msg="Skipping build image!"
    lsd-mod.fio.yesno_${_default} "${_que}" && \
        lsd-mod.log.echo "Executing..." && \
        docker build -t "${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" --build-arg "TARGETARCH=${TARGETARCH}" "${DOCKERFILE_BASEPATH}/base" && \
        docker run --gpus all --rm "${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" nvidia-smi \
      || lsd-mod.log.echo "${_msg}"

    _que="Build Image ${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS} now"
    _msg="Skipping build image!"
    lsd-mod.fio.yesno_${_default} "${_que}" && {
        lsd-mod.log.echo "Executing..."
        lsd-mod.log.echo "docker build -t ${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS} --build-arg IMAGE_NAME=${__NVIDIA_CUDA_IMAGE_NAME} ${DOCKERFILE_BASEPATH}/runtime"
        docker build -t "${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${__NVIDIA_CUDA_IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/runtime"
        # docker run --gpus all --rm "${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" nvidia-smi
    } || lsd-mod.log.echo "${_msg}"

    _que="Build Image ${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-devel-${OS} now"
    _msg="Skipping build image!"
    lsd-mod.fio.yesno_${_default} "${_que}" && \
        lsd-mod.log.echo "Executing..." && \
        docker build -t "${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${__NVIDIA_CUDA_IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/devel" && \
        docker run --gpus all --rm "${__NVIDIA_CUDA_IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" nvidia-smi \
      || lsd-mod.log.echo "${_msg}"
  } 1>&2 || lsd-mod.log.fail "Invalid or not supported CUDA version: $1"
}

function docker-buildimg-cuda() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local _default=yes
  local _que
  local _msg
  local _prog

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || lsd-mod.log.fail "Dependency docker-ce-verify is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-verify.sh"

  type nvidia-container-toolkit &>/dev/null \
    || lsd-mod.log.fail "Dependency nvidia-container-toolkit is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/nvidia-container-toolkit-install.sh"

  # type uuid &>/dev/null || lsd-mod.log.fail "uuid package not found. Execute...\n sudo apt install uuid"

  _prog="docker-buildimg-cuda"

  _que="Executing ${_prog} now"
  _msg="Skipping ${_prog} execution!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Executing..." && \
      __${_prog} $1 \
    || lsd-mod.log.echo "${_msg}"

}

docker-buildimg-cuda $1
