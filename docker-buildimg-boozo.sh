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
_SKILL__PYVENV_PATH="${_LSD__PYVENV_PATH}"
_SKILL__pyVer="${_LSD__PYVER}"
_SKILL__PYVENV_NAME="${_LSD__PYVENV_NAME}"
_SKILL__PYVENV_NAME_ALIAS="${_LSD__PYVENV_NAME_ALIAS}"
_SKILL__CUDNN_MAJOR_VERSION="${CUDNN_MAJOR_VERSION}"
_SKILL__TENSORRT_VER="${TENSORRT_VER}"
_SKILL__LIBNVINFER_PKG="${LIBNVINFER_PKG}"
_SKILL__DUSER="${DUSER}"
_SKILL__DUSER_ID="${DUSER_ID}"
_SKILL__DUSER_GRP="${DUSER_GRP}"
_SKILL__DUSER_GRP_ID="${DUSER_GRP_ID}"
_SKILL__DOCKER_ROOT_BASEDIR="${_LSD__DOCKER_ROOT}"
_SKILL__MAINTAINER="${DOCKER_BLD_MAINTAINER}"
_SKILL__DOCKER_BLD_IMG_TAG="${DOCKER_BLD_IMG_TAG}"
_SKILL__COPYRIGHT="${_COPYRIGHT_}"
EOL
}

function __docker-buildimg-boozo() {
  local DOCKER_CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/context/boozo"
  lsd-mod.log.info "DOCKER_CONTEXT: ${DOCKER_CONTEXT}"

  rm -r ${DOCKER_CONTEXT} &>/dev/null

  mkdir -p "${DOCKER_CONTEXT}" \
    "${DOCKER_CONTEXT}/installer" \
    "${DOCKER_CONTEXT}/config" \
    "${DOCKER_CONTEXT}/logs"

  cp -R $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/lscripts ${DOCKER_CONTEXT}/installer/.

  local _build_info_file=${DOCKER_CONTEXT}/logs/$(date -d now +'%d%m%y_%H%M%S').info
  touch ${_build_info_file} &>/dev/null && \
    lsd-mod.log.info "build_info_file: ${_build_info_file}" || lsd-mod.log.fail "Internal Error: Unable to create log!"

  local DOCKER_BLD_CONTAINER_IMG="$1"
  [[ ! -z "${DOCKER_BLD_CONTAINER_IMG}" ]] || lsd-mod.log.fail "Empty tag: DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  ## Fingerprint
  local __UUID__=$(uuid)
  local DOCKER_BLD_VERSION=1
  local DOCKER_BLD_WHICHONE="devel"
  local DOCKERFILE="dockerfiles/${BUILD_FOR_LINUX_DISTRIBUTION}/boozo-${DOCKER_BLD_WHICHONE}-gpu.Dockerfile"
  local DOCKER_BLD_CONTAINER_NAME="${DOCKER_BLD_WHICHONE}-${DOCKER_BLD_VERSION}"

  docker-buildimg-boozo-log ${_build_info_file}

  cat ${_build_info_file}

  lsd-mod.log.ok "Building new image from\n \
    DOCKERFILE: ${DOCKERFILE}\n \
    DOCKER_BLD_IMG_TAG: ${DOCKER_BLD_IMG_TAG}\n \
    DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  lsd-mod.fio.yesno_yes "About to execute docker build, check config and confirm" && {
    lsd-mod.log.echo "Executing... docker build"
    ${DOCKER_CMD} build \
      --build-arg "_SKILL__UUID=${__UUID__}" \
      --build-arg "_SKILL__LINUX_DISTRIBUTION=${BUILD_FOR_LINUX_DISTRIBUTION}" \
      --build-arg "_SKILL__CUDA_VERSION=${CUDA_VER}" \
      --build-arg "_SKILL__CUDNN_PKG=${CUDNN_PKG}" \
      --build-arg "_SKILL__CUDNN_VER=${CUDNN_VER}" \
      --build-arg "_SKILL__BASE_IMAGE_NAME=${__NVIDIA_BASE_IMAGE}" \
      --build-arg "_SKILL__PYVENV_PATH=${_LSD__PYVENV_PATH}" \
      --build-arg "_SKILL__pyVer=${_LSD__PYVER}" \
      --build-arg "_SKILL__PYVENV_NAME=${_LSD__PYVENV_NAME}" \
      --build-arg "_SKILL__PYVENV_NAME_ALIAS=${_LSD__PYVENV_NAME_ALIAS}" \
      --build-arg "_SKILL__CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION}" \
      --build-arg "_SKILL__TENSORRT_VER=${TENSORRT_VER}" \
      --build-arg "_SKILL__LIBNVINFER_PKG=${LIBNVINFER_PKG}" \
      --build-arg "_SKILL__DUSER=${DUSER}" \
      --build-arg "_SKILL__DUSER_ID=${DUSER_ID}" \
      --build-arg "_SKILL__DUSER_GRP=${DUSER_GRP}" \
      --build-arg "_SKILL__DUSER_GRP_ID=${DUSER_GRP_ID}" \
      --build-arg "_SKILL__DOCKER_ROOT_BASEDIR=${_LSD__DOCKER_ROOT}" \
      --build-arg "_SKILL__MAINTAINER=${DOCKER_BLD_MAINTAINER}" \
      --build-arg "_SKILL__COPYRIGHT=${_COPYRIGHT_}" \
      -t ${DOCKER_BLD_CONTAINER_IMG} \
      -f ${DOCKERFILE} ${DOCKER_CONTEXT} || lsd-mod.log.fail "Internal Error: Build image failed! Check the DOCKERFILE: ${DOCKERFILE}"
  } || lsd-mod.log.echo "Skipping docker duild at the last moment. Hope to see you soon!"

}

function docker-buildimg-boozo() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || lsd-mod.log.fail "Dependency docker-ce is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-install.sh"

  declare -a cuda_vers=($(_cuda_.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  local distributions="${CUDA_LINUX_DISTRIBUTIONS[@]}"
  distributions=$(echo "${distributions// / | }")

  # [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
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

  [[ "$#" -ne "2" ]] && lsd-mod.log.error "Invalid number of paramerters: required 2 given $#\n ${__error_msg}"


  ( lsd-mod.fio.find_in_array $1 "${cuda_vers[@]}" || lsd-mod.log.fail "Invalid or unsupported cuda version: $1" ) && \
    ( lsd-mod.fio.find_in_array $2 "${CUDA_LINUX_DISTRIBUTIONS[@]}" || lsd-mod.log.fail "Invalid or unsupported linux distribution: $2" )

  local BUILD_FOR_CUDA_VER=$1
  local BUILD_FOR_LINUX_DISTRIBUTION=$2
  local BUILD_FOR_LINUX_DISTRIBUTION_TR=${BUILD_FOR_LINUX_DISTRIBUTION//./}

  lsd-mod.log.echo "Docker Image will be build for:"
  lsd-mod.log.echo "Using CUDA version: ${BUILD_FOR_CUDA_VER}"
  lsd-mod.log.echo "Using BUILD_FOR_LINUX_DISTRIBUTION version: ${BUILD_FOR_LINUX_DISTRIBUTION}"

  local CUDACFG_FILEPATH="${LSCRIPTS}/lscripts/config/${BUILD_FOR_LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}"
  ## Only for reference, not used here
  ## local AI_PYCUDA_FILE=${LSCRIPTS}/lscripts/config/${BUILD_FOR_LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
  ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

  local __CUDA_LOG_FILEPATH="${LSCRIPTS}/logs/${scriptname%.*}-cuda-${BUILD_FOR_CUDA_VER}-${__TIMESTAMP__}.log"
  source ${CUDACFG_FILEPATH}
  echo -e "###----------------------------------------------------------"
  source ${LSCRIPTS}/lscripts/cuda-echo.sh 1>${__CUDA_LOG_FILEPATH} 2>&1
  lsd-mod.log.ok "Verify cuda-stack versions: ${__CUDA_LOG_FILEPATH}"
  echo -e "###----------------------------------------------------------"

  lsd-mod.log.debug "OS: ${OS}"
  lsd-mod.log.debug "CUDA_OS_REL: ${CUDA_OS_REL}"
  lsd-mod.log.debug "BUILD_FOR_LINUX_DISTRIBUTION_TR: ${BUILD_FOR_LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.debug "CUDA_VER: ${CUDA_VER}"

  local _default=yes
  local _que
  local _msg
  local _prog

  local DOCKER_BLD_CONTAINER_IMG="${_LSD__DOCKER_HUB_REPO}:${DOCKER_BLD_IMG_TAG}"

  _prog="docker-buildimg-boozo"

  _que="Executing ${_prog} now"
  _msg="Skipping ${_prog} execution!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Executing..." && {
        __${_prog} ${DOCKER_BLD_CONTAINER_IMG}

        lsd-mod.log.info "Now you can create container:\n \
          source ${LSCRIPTS}/docker-createcontainer-boozo.sh ${DOCKER_BLD_CONTAINER_IMG}"

        lsd-mod.log.success "Enjoy!"

      } || lsd-mod.log.echo "${_msg}"

  _que="Create test container"
  _msg="Skipping creating test container!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Testing..."
    _docker_.container_test ${DOCKER_BLD_CONTAINER_IMG}
  } || {
    lsd-mod.log.echo "${_msg}"
    lsd-mod.log.info "You can manually test container creation by executing:"
    lsd-mod.log.echo "${DOCKER_CMD} run --name $(uuid) --user $(id -un):$(id -gn) --gpus all --rm -it ${DOCKER_BLD_CONTAINER_IMG} bash"
  }
}

docker-buildimg-boozo "$@"
