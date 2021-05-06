#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Nvidia CUDA Docker based images for ML/AI Computer Vision Development
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}

function docker-buildimg-boozo-log() {
  cat > ${1} <<EOL
_SKILL__UUID="${__UUID__}"
_SKILL__LINUX_DISTRIBUTION="${BUILD_FOR_LINUX_DISTRIBUTION}"
_SKILL__CUDA_VERSION="${CUDA_VER}"
_SKILL__CUDNN_PKG="${CUDNN_PKG}"
_SKILL__CUDNN_VER="${CUDNN_VER}"
_SKILL__BASE_IMAGE_NAME="${__NVIDIA_BASE_IMAGE}"
_SKILL__PY_VENV_PATH="${PY_VENV_PATH}"
_SKILL__pyVer="${pyVer}"
_SKILL__PY_VENV_NAME="${PY_VENV_NAME}"
_SKILL__PY_VENV_NAME_ALIAS="${PY_VENV_NAME_ALIAS}"
_SKILL__CUDNN_MAJOR_VERSION="${CUDNN_MAJOR_VERSION}"
_SKILL__TENSORRT_VER="${TENSORRT_VER}"
_SKILL__LIBNVINFER_PKG="${LIBNVINFER_PKG}"
_SKILL__DUSER="${DUSER}"
_SKILL__DUSER_ID="${DUSER_ID}"
_SKILL__DUSER_GRP="${DUSER_GRP}"
_SKILL__DUSER_GRP_ID="${DUSER_GRP_ID}"
_SKILL__DOCKER_ROOT_BASEDIR="${DOCKER_ROOT_BASEDIR}"
_SKILL__MAINTAINER="${DOCKER_BLD_MAINTAINER}"
_SKILL__DOCKER_BLD_IMG_TAG="${DOCKER_BLD_IMG_TAG}"
_SKILL__COPYRIGHT="${_COPYRIGHT_}"
EOL
}

function __docker-buildimg-boozo() {
  local DOCKER_CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/context/boozo"
  _log_.info "DOCKER_CONTEXT: ${DOCKER_CONTEXT}"

  rm -r ${DOCKER_CONTEXT} &>/dev/null

  mkdir -p "${DOCKER_CONTEXT}" \
    "${DOCKER_CONTEXT}/installer" \
    "${DOCKER_CONTEXT}/config" \
    "${DOCKER_CONTEXT}/logs"

  cp -R $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/lscripts ${DOCKER_CONTEXT}/installer/.

  local _build_info_file=${DOCKER_CONTEXT}/logs/$(date -d now +'%d%m%y_%H%M%S').info
  touch ${_build_info_file} &>/dev/null && \
    _log_.info "build_info_file: ${_build_info_file}" || _log_.fail "Internal Error: Unable to create log!"

  local DOCKER_BLD_CONTAINER_IMG="$1"
  [[ ! -z "${DOCKER_BLD_CONTAINER_IMG}" ]] || _log_.fail "Empty tag: DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  ## Fingerprint
  local __UUID__=$(uuid)
  local DOCKER_BLD_VERSION=1
  local DOCKER_BLD_WHICHONE="devel"
  local DOCKERFILE="dockerfiles/${BUILD_FOR_LINUX_DISTRIBUTION}/boozo-${DOCKER_BLD_WHICHONE}-gpu.Dockerfile"
  local DOCKER_BLD_CONTAINER_NAME="${DOCKER_BLD_WHICHONE}-${DOCKER_BLD_VERSION}"

  docker-buildimg-boozo-log ${_build_info_file}

  cat ${_build_info_file}

  _log_.ok "Building new image from\n \
    DOCKERFILE: ${DOCKERFILE}\n \
    DOCKER_BLD_IMG_TAG: ${DOCKER_BLD_IMG_TAG}\n \
    DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  _fio_.yesno_yes "About to execute docker build, check config and confirm" && {
    _log_.echo "Executing... docker build"
    ${DOCKER_CMD} build \
      --build-arg "_SKILL__UUID=${__UUID__}" \
      --build-arg "_SKILL__LINUX_DISTRIBUTION=${BUILD_FOR_LINUX_DISTRIBUTION}" \
      --build-arg "_SKILL__CUDA_VERSION=${CUDA_VER}" \
      --build-arg "_SKILL__CUDNN_PKG=${CUDNN_PKG}" \
      --build-arg "_SKILL__CUDNN_VER=${CUDNN_VER}" \
      --build-arg "_SKILL__BASE_IMAGE_NAME=${__NVIDIA_BASE_IMAGE}" \
      --build-arg "_SKILL__PY_VENV_PATH=${PY_VENV_PATH}" \
      --build-arg "_SKILL__pyVer=${pyVer}" \
      --build-arg "_SKILL__PY_VENV_NAME=${PY_VENV_NAME}" \
      --build-arg "_SKILL__PY_VENV_NAME_ALIAS=${PY_VENV_NAME_ALIAS}" \
      --build-arg "_SKILL__CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION}" \
      --build-arg "_SKILL__TENSORRT_VER=${TENSORRT_VER}" \
      --build-arg "_SKILL__LIBNVINFER_PKG=${LIBNVINFER_PKG}" \
      --build-arg "_SKILL__DUSER=${DUSER}" \
      --build-arg "_SKILL__DUSER_ID=${DUSER_ID}" \
      --build-arg "_SKILL__DUSER_GRP=${DUSER_GRP}" \
      --build-arg "_SKILL__DUSER_GRP_ID=${DUSER_GRP_ID}" \
      --build-arg "_SKILL__DOCKER_ROOT_BASEDIR=${DOCKER_ROOT_BASEDIR}" \
      --build-arg "_SKILL__MAINTAINER=${DOCKER_BLD_MAINTAINER}" \
      --build-arg "_SKILL__COPYRIGHT=${_COPYRIGHT_}" \
      -t ${DOCKER_BLD_CONTAINER_IMG} \
      -f ${DOCKERFILE} ${DOCKER_CONTEXT} || _log_.fail "Internal Error: Build image failed! Check the DOCKERFILE: ${DOCKERFILE}"
  } || _log_.echo "Skipping docker duild at the last moment. Hope to see you soon!"

}

function docker-buildimg-boozo() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || _log_.fail "Dependency docker-ce is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-install.sh"

  declare -a cuda_vers=($(_nvidia_.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  local distributions="${CUDA_LINUX_DISTRIBUTIONS[@]}"
  distributions=$(echo "${distributions// / | }")

  # [[ ${_LSCRIPTS__DEBUG_} -eq 0 ]] || {
  #   (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
  #   local ver
  #   (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)

  #   local distribution
  #   (>&2 echo -e "Total CUDA_LINUX_DISTRIBUTIONS: ${#CUDA_LINUX_DISTRIBUTIONS[@]}\n CUDA_LINUX_DISTRIBUTIONS: ${CUDA_LINUX_DISTRIBUTIONS[@]}")
  #   (for distribution in "${CUDA_LINUX_DISTRIBUTIONS[@]}"; do (>&2 echo -e "distributions => ${distribution}"); done)
  # }

  local __error_msg="
  Usage:
    bash $0 <cuda_version> <linux_distribution>
    
    Supported values:
    <cuda_version> => [ ${vers} ]
    <linux_distribution> => [ ${distributions} ]

    example:
    bash $0 ${cuda_vers[0]} ${CUDA_LINUX_DISTRIBUTIONS[0]}
  "
  : ${1? "${__error_msg}" } && : ${2? "${__error_msg}"}

  [[ "$#" -ne "2" ]] && _log_.error "Invalid number of paramerters: required 2 given $#\n ${__error_msg}"


  ( _fio_.find_in_array $1 "${cuda_vers[@]}" || _log_.fail "Invalid or unsupported cuda version: $1" ) && \
    ( _fio_.find_in_array $2 "${CUDA_LINUX_DISTRIBUTIONS[@]}" || _log_.fail "Invalid or unsupported linux distribution: $2" )

  local BUILD_FOR_CUDA_VER=$1
  local BUILD_FOR_LINUX_DISTRIBUTION=$2
  local BUILD_FOR_LINUX_DISTRIBUTION_TR=${BUILD_FOR_LINUX_DISTRIBUTION//./}

  _log_.echo "Docker Image will be build for:"
  _log_.echo "Using CUDA version: ${BUILD_FOR_CUDA_VER}"
  _log_.echo "Using BUILD_FOR_LINUX_DISTRIBUTION version: ${BUILD_FOR_LINUX_DISTRIBUTION}"

  local CUDACFG_FILEPATH="${LSCRIPTS}/lscripts/config/${BUILD_FOR_LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
  _log_.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || _log_.fail "config file does not exists: ${CUDACFG_FILEPATH}"
  ## Only for reference, not used here
  ## local AI_PYCUDA_FILE=${LSCRIPTS}/lscripts/config/${BUILD_FOR_LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
  ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

  local __CUDA_LOG_FILEPATH="${LSCRIPTS}/logs/${scriptname%.*}-cuda-${BUILD_FOR_CUDA_VER}-${__TIMESTAMP__}.log"
  source ${CUDACFG_FILEPATH}
  echo -e "###----------------------------------------------------------"
  source ${LSCRIPTS}/lscripts/cuda-echo.sh 1>${__CUDA_LOG_FILEPATH} 2>&1
  _log_.ok "Verify cuda-stack versions: ${__CUDA_LOG_FILEPATH}"
  echo -e "###----------------------------------------------------------"

  _log_.debug "OS: ${OS}"
  _log_.debug "CUDA_OS_REL: ${CUDA_OS_REL}"
  _log_.debug "BUILD_FOR_LINUX_DISTRIBUTION_TR: ${BUILD_FOR_LINUX_DISTRIBUTION_TR}"
  _log_.debug "CUDA_VER: ${CUDA_VER}"

  local _default=yes
  local _que
  local _msg
  local _prog

  local DOCKER_BLD_CONTAINER_IMG="${DOCKER_HUB_REPO}:${DOCKER_BLD_IMG_TAG}"

  _prog="docker-buildimg-boozo"

  _que="Executing ${_prog} now"
  _msg="Skipping ${_prog} execution!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Executing..." && {
        __${_prog} ${DOCKER_BLD_CONTAINER_IMG}

        _log_.info "Now you can create container:\n \
          source ${LSCRIPTS}/docker-createcontainer-boozo.sh ${DOCKER_BLD_CONTAINER_IMG}"

        _log_.success "Enjoy!"

      } || _log_.echo "${_msg}"

  _que="Create test container"
  _msg="Skipping creating test container!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Testing..."
    _docker_.container_test ${DOCKER_BLD_CONTAINER_IMG}
  } || {
    _log_.echo "${_msg}"
    _log_.info "You can manually test container creation by executing:"
    _log_.echo "${DOCKER_CMD} run --name $(uuid) --user $(id -un):$(id -gn) --gpus all --rm -it ${DOCKER_BLD_CONTAINER_IMG} bash"
  }
}

docker-buildimg-boozo "$@"
