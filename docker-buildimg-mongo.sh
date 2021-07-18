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
  _log_.info "DOCKER_CONTEXT: ${DOCKER_CONTEXT}"

  rm -r ${DOCKER_CONTEXT} &>/dev/null

  mkdir -p "${DOCKER_CONTEXT}" \
    "${DOCKER_CONTEXT}/installer" \
    "${DOCKER_CONTEXT}/config" \
    "${DOCKER_CONTEXT}/logs"

  local __cmd__="_docker_.image.build"

  local TAG="$(echo ${DOCKERFILE} | sed 's:/*$::' | rev | cut -d'/' -f1 | rev)-$(uname -m)-$(date -d now +'%d%m%y_%H%M%S')"

  ${__cmd__} --tag=${TAG} --tag=${DOCKERFILE} --tag=${DOCKER_CONTEXT}
}

function docker-buildimg-mongo() {
  : ${1?
    "Usage:
    bash $0 <dockerfile>"
  }

  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local _default=yes
  local _que
  local _msg
  local _prog

  _prog="docker-buildimg-mongo"

  _que="Executing ${_prog} now"
  _msg="Skipping ${_prog} execution!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Executing..." && {
        __${_prog} ${1}

        _log_.info "Now you can create container:\n \
          source ${LSCRIPTS}/docker-createcontainer-mongo.sh ${DOCKER_MONGO_CONTAINER_IMG}"

        _log_.success "Enjoy!"

      } || _log_.echo "${_msg}"
}

docker-buildimg-mongo "$1"
