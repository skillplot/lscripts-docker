#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Docker Create Container for stack - ML/AI, Computer vision
###----------------------------------------------------------
#
## References:
##  - https://docs.docker.com/network/host/
##  - https://github.com/facebookresearch/detectron2/tree/master/docker
##  - https://docs.docker.com/engine/reference/commandline/exec/
###----------------------------------------------------------


## Fail on first error.
# set -e

function __docker-createcontainer-boozo() {
  local DOCKER_BLD_CONTAINER_IMG="$1"
  local DOCKER_CONTAINER_NAME=${DOCKER_PREFIX}-$(date -d now +'%d%m%y_%H%M%S')

  # [[ $? == 0 ]] && ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null && \
  #   ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null

  # ${DOCKER_CMD} start ${DOCKER_CONTAINER_NAME} 1>/dev/null

  lsd-mod.log.warn "Published ports are discarded when using host network mode!"

  echo "${DOCKER_CMD} run -d -it \
      --user $(id -un):$(id -gn) \
      --name ${DOCKER_CONTAINER_NAME} \
      $(lsd-mod.docker.enable_nvidia_gpu) \
      $(lsd-mod.docker.envvars) \
      $(lsd-mod.docker.local_volume) \
      $(lsd-mod.docker.restart_policy) \
      --net host \
      --add-host ${LOCAL_HOST}:127.0.0.1 \
      --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
      --hostname ${DOCKER_LOCAL_HOST} \
      --shm-size ${SHM_SIZE_8GB} \
      ${DOCKER_BLD_CONTAINER_IMG}"

  [[ $? -eq 0 ]] || lsd-mod.log.fail "Internal Error: Failed to create docker container!"

  ## Grant docker access to host X server to show images
  xhost +local:`${DOCKER_CMD} inspect --format='{{ .Config.Hostname }}' ${DOCKER_CONTAINER_NAME}`

  lsd-mod.log.echo "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment."
  lsd-mod.log.ok "Enjoy!"
  lsd-mod.log.info "Execute container..."
  lsd-mod.log.echo "bash lscripts/exec_cmd.sh --cmd=_docker_.container.exec --name=${DOCKER_CONTAINER_NAME}\n"

  lsd-mod.log.info "Or simple execution:\n ${DOCKER_CMD} exec -it ${DOCKER_CONTAINER_NAME}\n"
  echo ${DOCKER_CONTAINER_NAME}
}


function docker-createcontainer-boozo.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || lsd-mod.log.fail "Dependency docker-ce-verify is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-verify.sh"

  type nvidia-container-toolkit &>/dev/null \
    || lsd-mod.log.fail "Dependency nvidia-container-toolkit is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/nvidia-container-toolkit-install.sh"

  declare -a cuda_vers=($(_cuda_.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
    (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)
  }

  : ${1?
    "Usage:
    bash $0 <cudaversion> [ ${vers} ]"
  }

  lsd-mod.fio.find_in_array "$1" "${cuda_vers[@]}" &>/dev/null \
    || lsd-mod.log.fail "Invalid or not supported CUDA version: $1"

  local BUILD_FOR_CUDA_VER="$1"
  lsd-mod.log.info "Using CUDA version: ${BUILD_FOR_CUDA_VER}"

  local CUDACFG_FILEPATH="${LSCRIPTS}/lscripts/core/config/${LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}"
  ## Only for reference, not used here
  ## local AI_PYCUDA_FILE=${LSCRIPTS}/lscripts/core/config/${LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
  ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

  local __CUDA_LOG_FILEPATH="${LSCRIPTS}/logs/${scriptname%.*}-cuda-${BUILD_FOR_CUDA_VER}-${__TIMESTAMP__}.log"
  source ${CUDACFG_FILEPATH}
  echo -e "###----------------------------------------------------------"
  source ${LSCRIPTS}/lscripts/cuda-echo.sh 1>${__CUDA_LOG_FILEPATH} 2>&1
  lsd-mod.log.ok "Verify cuda-stack versions: ${__CUDA_LOG_FILEPATH}"
  echo -e "###----------------------------------------------------------"

  lsd-mod.log.debug "OS: ${OS}"
  lsd-mod.log.debug "CUDA_OS_REL: ${CUDA_OS_REL}"
  lsd-mod.log.debug "LINUX_DISTRIBUTION_TR: ${LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.debug "CUDA_VER: ${CUDA_VER}"

  local _default=yes
  local _que
  local _msg
  local _prog
  local docker_container_name
  # type uuid &>/dev/null || lsd-mod.log.fail "uuid package not found. Execute...\n sudo apt install uuid"

  lsd-mod.log.debug "_LSD__DOCKER_HUB_REPO:${_LSD__DOCKER_HUB_REPO}: DOCKER_BLD_IMG_TAG:${DOCKER_BLD_IMG_TAG}"
  local DOCKER_BLD_CONTAINER_IMG="${_LSD__DOCKER_HUB_REPO}:${DOCKER_BLD_IMG_TAG}"

  _prog="docker-createcontainer-boozo"

  _que="Create test container"
  _msg="Skipping creating test container!"
  lsd-mod.fio.yesno_no "${_que}" && {
    lsd-mod.log.echo "Testing..."
    _docker_.container_test "${DOCKER_BLD_CONTAINER_IMG}"
  } || {
    lsd-mod.log.echo "${_msg}"
    lsd-mod.log.info "You can manually test container creation by executing:"
    lsd-mod.log.echo "${DOCKER_CMD} run --name $(uuid) --user $(id -un):$(id -gn) --gpus all --rm -it ${DOCKER_BLD_CONTAINER_IMG} bash"
  }

  _que="Create container using ${_prog} now"
  _msg="Skipping ${_prog} container creation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating container..."
    docker_container_name=$(__${_prog} ${DOCKER_BLD_CONTAINER_IMG})
  } || lsd-mod.log.echo "${_msg}"

  _que="Execute userfix for docker container"
  _msg="Skipping userfix for container!"
  lsd-mod.fio.yesno_no "${_que}" && {
    lsd-mod.log.echo "Executing userfix for container: ${docker_container_name}"
    _docker_.userfix --name="${docker_container_name}"
  } || lsd-mod.log.echo "${_msg}"
}

docker-createcontainer-boozo.main "$@"
