#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker-ce installation verification
###----------------------------------------------------------
#
## verify:
## docker run hello-world
## docker version
###----------------------------------------------------------


function docker-ce-verify.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local _cmd="docker"
  lsd-mod.log.info "Verifying ${_cmd} installation..."

  type ${_cmd} &>/dev/null && {
    (${_cmd} version && ${_cmd} run hello-world) 1>&2
    lsd-mod.log.ok "${_cmd} is available!"
    return 0
  } || {
    lsd-mod.log.error "${_cmd} not installed or corrupted!"
    return -1
  }

}

docker-ce-verify.main
