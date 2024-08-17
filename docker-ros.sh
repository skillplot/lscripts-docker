#/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## OSRF: Open Source Robotics Foundation, Inc., ROS Docker
###----------------------------------------------------------
#
## References:
## * http://wiki.ros.org/docker/Tutorials/Docker
###----------------------------------------------------------


## Fail on first error.
# set -e

function __local_volumes_ros() {
  local volumes="$(local_volumes) ${ROS_VOLUMES} "
  echo "${volumes}"
}

function __port_maps_ros() {
  local docker_ports="${ROS_PORTS} "
  echo "${docker_ports}"
}

function ___docker_.envvars_ros() {
  local envvars="$(_docker_.envvars) ${ROS_DOCKER_ENVVARS} "
  echo "${envvars}"
}

function __docker-ros() {
  # ## official
  # docker pull ros:kinetic-ros-base-xenial
  # ## OSRF
  # docker pull osrf/ros:<tag_name>
  # docker pull osrf/ros2:<tag_name>
  # docker pull osrf/gazebo:<tag_name>
  # docker pull osrf/ros_legacy:<tag_name>


  docker pull osrf/ros:melodic-desktop-full

  # sudo chown $(id -u):$(id -g) ros_entrypoint.sh
  # source ros_entrypoint.sh
  # roscore
}

function __docker-create_container_ros() {
  local DOCKER_BLD_CONTAINER_IMG="$1"
  # local DOCKER_CONTAINER_NAME=${DOCKER_PREFIX}-$(date -d now +'%d%m%y_%H%M%S')
  local DOCKER_CONTAINER_NAME="${ROS_DOCKER_CONTAINER_NAME}"

  ${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null

  # [[ $? == 0 ]] && ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null && \
  #   ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null

  # ${DOCKER_CMD} start ${DOCKER_CONTAINER_NAME} 1>/dev/null

  lsd-mod.log.warn "Published ports are discarded when using host network mode!"

  ${DOCKER_CMD} run -d -it \
    --name ${DOCKER_CONTAINER_NAME} \
    $(___docker_.envvars_ros) \
    $(__port_maps_ros) \
    $(__local_volumes_ros) \
    $(_docker_.restart_policy) \
    --net host \
    --add-host ${LOCAL_HOST}:127.0.0.1 \
    --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
    --hostname ${DOCKER_LOCAL_HOST} \
    --shm-size ${SHM_SIZE_2GB} \
    ${DOCKER_BLD_CONTAINER_IMG}

  xhost +local:`docker inspect --format='{{ .Config.Hostname }}' ${DOCKER_CONTAINER_NAME}`

  lsd-mod.log.success -e "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with:\n source $(pwd)/docker.exec-aidev.sh ${DOCKER_CONTAINER_NAME}"
  lsd-mod.log.ok "Enjoy!"
}

function docker-ros() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/lscripts/docker-ce-verify.sh" &>/dev/null \
    || lsd-mod.log.fail "Dependency docker-ce-verify is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/lscripts/docker-ce-verify.sh"

  ## kinetic-desktop-full
  ## melodic-desktop-full

  : ${1?
    "Usage:
    bash $0 <rosver>"
  }

  local DOCKER_BLD_CONTAINER_IMG="$1"
  lsd-mod.log.info "Using DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  local _default=yes
  local _que
  local _msg
  local _prog

  _prog="docker-ros"

  _que="Create container using ${_prog} now"
  _msg="Skipping ${_prog} container creation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Creating container..." && \
      __${_prog} ${DOCKER_BLD_CONTAINER_IMG} \
    || lsd-mod.log.echo "${_msg}"
}

docker-ros "$@"
