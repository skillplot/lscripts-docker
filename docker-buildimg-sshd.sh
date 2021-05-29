#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Docker ssh
###----------------------------------------------------------
## References:
## * https://docs.docker.com/engine/examples/running_ssh_service/
## * https://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function __docker-buildimg-sshd() {
  local DUSER=${USER}
  local DUSER_ID=$(id -u ${DUSER})
  local DUSER_GRP=$(id -gn ${DUSER})
  local DUSER_GRP_ID=$(id -g ${DUSER})
  local DUSER_HOME="/home/${DUSER}"

  local _LSD__DOCKER_HUB_REPO="skillplot/boozo"
  local DOCKER_BLD_IMG_TAG="ssh"
  local DOCKER_BLD_CONTAINER_IMG="${_LSD__DOCKER_HUB_REPO}:${DOCKER_BLD_IMG_TAG}"

  local ROOT_BASEDIR="/boozo-hub"
  local DOCKER_ROOT_BASEDIR="${ROOT_BASEDIR}"

  local DOCKER_BLD_MAINTAINER='"skillplot"'

  # local DOCKERFILE="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/dockerfiles/ubuntu18.04/ssh.Dockerfile"
  local DOCKERFILE="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/dockerfiles/ubuntu18.04/ssh-script.Dockerfile"
  local DOCKER_CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/context/ssh"

  docker build \
    --build-arg "_SKILL__DUSER=${DUSER}" \
    --build-arg "_SKILL__DUSER_ID=${DUSER_ID}" \
    --build-arg "_SKILL__DUSER_GRP=${DUSER_GRP}" \
    --build-arg "_SKILL__DUSER_GRP_ID=${DUSER_GRP_ID}" \
    --build-arg "_SKILL__DOCKER_ROOT_BASEDIR=${DOCKER_ROOT_BASEDIR}" \
    --build-arg "_SKILL__MAINTAINER=${DOCKER_BLD_MAINTAINER}" \
    -t ${DOCKER_BLD_CONTAINER_IMG} \
    -f ${DOCKERFILE} ${DOCKER_CONTEXT}

  # docker build -t skillplot/boozo:ssh -f dockerfiles/ubuntu18.04/ssh.Dockerfile .
  # docker run -d -P --name test_sshd skillplot/boozo:ssh
  # docker port test_sshd 22
}

__docker-buildimg-sshd
