#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Build MongoDB Docker image - work in progress
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}

function __docker-buildimg-mongo() {
  local DOCKER_CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/context/mongo"
  lsd-mod.log.info "DOCKER_CONTEXT: ${DOCKER_CONTEXT}"

  rm -r ${DOCKER_CONTEXT} &>/dev/null

  mkdir -p "${DOCKER_CONTEXT}" \
    "${DOCKER_CONTEXT}/installer" \
    "${DOCKER_CONTEXT}/config" \
    "${DOCKER_CONTEXT}/logs"

  # local __cmd__="_docker_.image.build"

  local DOCKER_BLD_IMG_TAG="$(echo ${DOCKERFILE} | sed 's:/*$::' | rev | cut -d'/' -f1 | rev)-$(uname -m)-$(date -d now +'%d%m%y_%H%M%S')"

  # ${__cmd__} --tag=${DOCKER_BLD_IMG_TAG} --tag=${DOCKERFILE} --tag=${DOCKER_CONTEXT}

  lsd-mod.log.ok "Building new image from\n \
    DOCKERFILE: ${DOCKERFILE}\n \
    DOCKER_BLD_IMG_TAG: ${DOCKER_BLD_IMG_TAG}\n \
    DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"

  lsd-mod.fio.yesno_yes "About to execute docker build, check config and confirm" && {
    lsd-mod.log.echo "Executing... docker build"
    ${DOCKER_CMD} build \
      --build-arg "_SKILL__UUID=${__UUID__}" \
      --build-arg "_SKILL__LINUX_DISTRIBUTION=${BUILD_FOR_LINUX_DISTRIBUTION}" \
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

function docker-buildimg-mongo() {
  : ${1?
    "Usage:
    bash $0 <dockerfile>"
  }

  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  local contextname=$(echo "${scriptname%.*}" | cut -d'-' -f3)

  lsd-mod.log.debug "executing script...: ${scriptname} with contextname: ${contextname}"

  local _default=yes
  local _que
  local _msg
  local _prog

  local DOCKER_BLD_CONTAINER_IMG="${_LSD__DOCKER_HUB_REPO}:${DOCKER_BLD_IMG_TAG}"

  _prog="docker-buildimg-mongo"

  _que="Executing ${_prog} now"
  _msg="Skipping ${_prog} execution!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Executing..." && {
        __${_prog} ${1}

        lsd-mod.log.info "Now you can create container:\n \
          source ${LSCRIPTS}/docker-createcontainer-mongo.sh ${DOCKER_MONGO_CONTAINER_IMG}"

        lsd-mod.log.success "Enjoy!"

      } || lsd-mod.log.echo "${_msg}"
}

docker-buildimg-mongo "$1"
