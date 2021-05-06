#/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## OSRF: Open Source Robotics Foundation, Inc., ROS Docker
###----------------------------------------------------------


## Fail on first error.
# set -e


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}

function __local_volumes() {
  ## Do NOT delete the trailing space
  local volumes="$(_docker_.local_volumes) ${DOCKER_VOLUMES} "
  echo "${volumes}"
}

function __port_maps() {
  local docker_ports="${DOCKER_PORTS} "
  echo "${docker_ports}"
}

function ___docker_.envvars() {
  local envvars="$(_docker_.envvars) "
  echo "${envvars}"
}

function __docker-userfix() {
  $(_docker_.userfix --name="$1")
}

function __docker-adduser_to_sudoer() {
  $(_docker_.adduser_to_sudoer --name="$1")
}

function __docker-createcontainer() {
  local DOCKER_BLD_CONTAINER_IMG="$1"
  local DOCKER_CONTAINER_NAME=$2

  ${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null

  # [[ $? == 0 ]] && ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null && \
  #   ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null

  # ${DOCKER_CMD} start ${DOCKER_CONTAINER_NAME} 1>/dev/null

  _log_.warn "Published ports are discarded when using host network mode!"

  ## Todo:
  ## 1) static name for docker container
  ## 2) check if docker image exists, if not then ask to pull the image confirmation

  ## Use these flags with docker cmd if required
  # $(_docker_.enable_nvidia_gpu) \
  # $(_docker_.restart_policy) \


  ${DOCKER_CMD} run -d -it \
    --name ${DOCKER_CONTAINER_NAME} \
    $(___docker_.envvars) \
    $(__local_volumes) \
    --net host \
    --add-host ${LOCAL_HOST}:127.0.0.1 \
    --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
    --hostname ${DOCKER_LOCAL_HOST} \
    --shm-size ${SHM_SIZE_2GB} \
    ${DOCKER_BLD_CONTAINER_IMG} &>/dev/null

  [[ $? -eq 0 ]] || _log_.fail "Internal Error: Failed to create docker container!"

  ## Grant docker access to host X server to show images
  xhost +local:`${DOCKER_CMD} inspect --format='{{ .Config.Hostname }}' ${DOCKER_CONTAINER_NAME}`

  _log_.echo "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment."
  _log_.ok "Enjoy!"
  _log_.info "Execute container..."
  _log_.echo "bash lscripts/exec_cmd.sh --cmd=_docker_.exec_container --name=${DOCKER_CONTAINER_NAME}\n"

  _log_.info "Or simple execution:\n ${DOCKER_CMD} exec -it ${DOCKER_CONTAINER_NAME}\n"
}

function __docker-pull() {
  echo "Pulling image: ${DOCKER_BLD_CONTAINER_IMG}"
  ${DOCKER_CMD} pull ${DOCKER_BLD_CONTAINER_IMG}
}

function docker-createcontainer() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || _log_.fail "Dependency docker-ce-verify is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-verify.sh"


  # : ${1?
  #   "Usage:
  #   bash $0 <DOCKER_BLD_CONTAINER_IMG>"
  # }


  source ${LSCRIPTS}/lscripts/utils/argparse.sh "$@"

  [[ "$#" -lt "1" ]] && _log_.fail "Invalid number of paramerters: required --image [--container] given $#"
  [[ -n "${args['image']+1}" ]] || _log_.fail "Required params: --image=<imageName> [--container=<containerName>]"

  local DOCKER_BLD_CONTAINER_IMG=${args['image']}
  local DOCKER_CONTAINER_NAME
  [[ -n "${args['container']+1}" ]] && DOCKER_CONTAINER_NAME=${args['container']} || \
    DOCKER_CONTAINER_NAME=${DOCKER_PREFIX}-$(date -d now +'%d%m%y_%H%M%S')


  # local DOCKER_BLD_CONTAINER_IMG="$1"
  _log_.info "Using DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  # local DOCKER_CONTAINER_NAME=${DOCKER_PREFIX}-$(date -d now +'%d%m%y_%H%M%S')
  _log_.info "Using DOCKER_CONTAINER_NAME: ${DOCKER_CONTAINER_NAME}"

  local _default=yes
  local _que
  local _msg
  local _prog

  _prog="docker"

  _que="Pull docker image before creating the container"
  _msg="Skipping pulling docker image. It must already exists before you continue further!"
  _fio_.yes_or_no_loop "${_que}" && {
      _log_.echo "Pulling image from dockerhub..."
      __${_prog}-pull ${DOCKER_BLD_CONTAINER_IMG}
    } || _log_.echo "${_msg}"

  _que="Create container using ${_prog} now"
  _msg="Skipping ${_prog} container creation!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Creating container..."
      __${_prog}-createcontainer ${DOCKER_BLD_CONTAINER_IMG} ${DOCKER_CONTAINER_NAME}
    } || _log_.echo "${_msg}"


  _log_.info "Execute container..."
  _log_.echo "bash lscripts/exec_cmd.sh --cmd=_docker_.exec_container --name=${DOCKER_CONTAINER_NAME}\n"

  _que="Create Host user inside container"
  _msg="Skipping host user creation!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Creating Host user..."
      __${_prog}-userfix ${DOCKER_CONTAINER_NAME}
    } || _log_.echo "${_msg}"

  _que="Add Docker user inside container to sudoer"
  _msg="Skipping adding docker user to sudoer!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Adding to sudoer..."
      __${_prog}-adduser_to_sudoer ${DOCKER_CONTAINER_NAME}
    } || _log_.echo "${_msg}"
}

docker-createcontainer "$@"
