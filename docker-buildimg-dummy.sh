#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker dummy
###----------------------------------------------------------
## References:
## * https://docs.docker.com/engine/examples/running_ssh_service/
## * https://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
#
## Quick
## docker build -t skillplot/boozo:dummy -f dockerfiles/ubuntu18.04/dummy.Dockerfile .
## docker run -d -P --rm --name test_dummy skillplot/boozo:dummy tail -f /dev/null
## docker exec -u $(id -u):$(id -g) -it test_dummy /bin/bash && xhost -local:root 1>/dev/null 2>&1
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}

function __docker-buildimg-dummy() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  local contextname=$(echo "${scriptname%.*}" | cut -d'-' -f3)

  lsd-mod.log.debug "executing script...: ${scriptname} with contextname: ${contextname}"

  local DUSER=${USER}
  local DUSER_ID=$(id -u ${DUSER})
  local DUSER_GRP=$(id -gn ${DUSER})
  local DUSER_GRP_ID=$(id -g ${DUSER})
  local DUSER_HOME="/home/${DUSER}"

  local _LSD__DOCKER_HUB_REPO="skillplot/boozo"
  local DOCKER_BLD_IMG_TAG="${contextname}"
  local DOCKER_BLD_CONTAINER_IMG="${_LSD__DOCKER_HUB_REPO}:${DOCKER_BLD_IMG_TAG}"

  local ROOT_BASEDIR="/boozo-hub"
  local DOCKER_ROOT_BASEDIR="${ROOT_BASEDIR}"

  local DOCKER_BLD_MAINTAINER='"skillplot"'

  local DOCKERFILE="${LSCRIPTS}/dockerfiles/ubuntu18.04/${contextname}.Dockerfile"
  local DOCKER_CONTEXT="${LSCRIPTS}/context/${contextname}"
  lsd-mod.log.info "DOCKERFILE: ${DOCKERFILE}"
  lsd-mod.log.info "DOCKER_CONTEXT: ${DOCKER_CONTEXT}"

  rm -r ${DOCKER_CONTEXT} &>/dev/null

  mkdir -p "${DOCKER_CONTEXT}" \
    "${DOCKER_CONTEXT}/installer" \
    "${DOCKER_CONTEXT}/config" \
    "${DOCKER_CONTEXT}/logs"

  cp -R ${LSCRIPTS}/lscripts ${DOCKER_CONTEXT}/installer/.

  docker build \
    --build-arg "_SKILL__DUSER=${DUSER}" \
    --build-arg "_SKILL__DUSER_ID=${DUSER_ID}" \
    --build-arg "_SKILL__DUSER_GRP=${DUSER_GRP}" \
    --build-arg "_SKILL__DUSER_GRP_ID=${DUSER_GRP_ID}" \
    --build-arg "_SKILL__DOCKER_ROOT_BASEDIR=${DOCKER_ROOT_BASEDIR}" \
    --build-arg "_SKILL__MAINTAINER=${DOCKER_BLD_MAINTAINER}" \
    -t ${DOCKER_BLD_CONTAINER_IMG} \
    -f ${DOCKERFILE} ${DOCKER_CONTEXT} && {
      lsd-mod.log.echo "docker run -d -P --rm --name test_${contextname} ${_LSD__DOCKER_HUB_REPO}:${contextname} tail -f /dev/null"
      lsd-mod.log.echo "docker exec -u $(id -u):$(id -g) -it test_${contextname} /bin/bash && xhost -local:root 1>/dev/null 2>&1"
    } || lsd-mod.log.fail "Build failed!"
}

__docker-buildimg-dummy