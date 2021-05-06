#/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## MongoDB Docker Container Creation
###----------------------------------------------------------


## Fail on first error.
# set -e

function __local_volumes_mongo() {
  ## Do NOT delete the trailing space
  local volumes="$(local_volumes) ${MONGODB_VOLUMES} "
  echo "${volumes}"
}

function __port_maps_mongo() {
  local docker_ports="${MONGODB_PORTS} "
  echo "${docker_ports}"
}

function ___docker_.envvars_mongo() {
  local envvars="$(_docker_.envvars) ${MONGODB_DOCKER_ENVVARS} "
  echo "${envvars}"
}

function __docker-createcontainer-mongo() {
  local DOCKER_BLD_CONTAINER_IMG="$1"
  # local DOCKER_CONTAINER_NAME=${DOCKER_PREFIX}-$(date -d now +'%d%m%y_%H%M%S')
  local DOCKER_CONTAINER_NAME="${MONGODB_DOCKER_CONTAINER_NAME}"

  ${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null

  # [[ $? == 0 ]] && ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null && \
  #   ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null

  # ${DOCKER_CMD} start ${DOCKER_CONTAINER_NAME} 1>/dev/null

  _log_.warn "Published ports are discarded when using host network mode!"

  ${DOCKER_CMD} run -d -it \
    --name ${DOCKER_CONTAINER_NAME} \
    $(___docker_.envvars_mongo) \
    $(__port_maps_mongo) \
    $(__local_volumes_mongo) \
    $(_docker_.restart_policy) \
    --net host \
    --add-host ${LOCAL_HOST}:127.0.0.1 \
    --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
    --hostname ${DOCKER_LOCAL_HOST} \
    --shm-size ${SHM_SIZE_2GB} \
    ${DOCKER_BLD_CONTAINER_IMG}

  xhost +local:`docker inspect --format='{{ .Config.Hostname }}' ${DOCKER_CONTAINER_NAME}`

  _log_.success -e "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with:\n source $(pwd)/docker.exec-aidev.sh ${DOCKER_CONTAINER_NAME}"
  _log_.ok "Enjoy!"
}

function docker-createcontainer-mongo() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || _log_.fail "Dependency docker-ce-verify is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-verify.sh"

  : ${1?
    "Usage:
    bash $0 <dockerfile>"
  }

  local DOCKER_BLD_CONTAINER_IMG="$1"
  _log_.info "Using DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  local _default=yes
  local _que
  local _msg
  local _prog

  _prog="docker-createcontainer-mongo"

  _que="Create container using ${_prog} now"
  _msg="Skipping ${_prog} container creation!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Creating container..." && \
      __${_prog} ${DOCKER_BLD_CONTAINER_IMG} \
    || _log_.echo "${_msg}"
}

docker-createcontainer-mongo "$@"
