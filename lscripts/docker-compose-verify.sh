#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker-compose installation verification
###----------------------------------------------------------
#
## verify:
## docker-compose version
###----------------------------------------------------------


function docker-compose-verify.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local _cmd="docker-compose"

  _log_.info "Verifying ${_cmd} installation..."

  type ${_cmd} &>/dev/null && {
    (${_cmd} --version) 1>&2 &&
    _log_.ok "${_cmd} is available!"
    return 0
  } || {
    _log_.error "${_cmd} not installed or corrupted!"
    return -1
  }

}

docker-compose-verify.main
