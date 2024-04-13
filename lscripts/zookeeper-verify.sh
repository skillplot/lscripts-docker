#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## zookeeper
###----------------------------------------------------------


function zookeeper-verify() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  source ${LSCRIPTS}/zookeeper-utils.sh
  source ${LSCRIPTS}/core/argparse.sh "$@"

  [[ "$#" -ne "2" ]] && lsd-mod.log.fail "Invalid number of paramerters: required 2 given $#"
  [[ -n "${args['home']+1}" ]] && [[ -n "${args['username']+1}" ]] && {
    # (>&2 echo -e "key: 'username' exists")
    local ZOOKEEPER_HOME="${args['home']}"
    local ZOOKEEPER_USERNAME="${args['username']}"
    local ZOOKEEPER_CONFIG=${LSCRIPTS}/core/config/zookeeper

    lsd-mod.log.info "ZOOKEEPER_HOME: ${ZOOKEEPER_HOME}"
    lsd-mod.log.info "ZOOKEEPER_USERNAME: ${ZOOKEEPER_USERNAME}"
    lsd-mod.log.info "ZOOKEEPER_CONFIG: ${ZOOKEEPER_CONFIG}"

    # su -l ${ZOOKEEPER_USERNAME}

    lsd-mod.log.info "Starting zookeeper..."
    __zookeeper-start ${ZOOKEEPER_HOME} ${ZOOKEEPER_CONFIG}

    # lsd-mod.log.info "Stopping zookeeper..."
    # __zookeeper-stop ${ZOOKEEPER_HOME}

    return 0
  } || {
    lsd-mod.log.error "Invalid paramerters!"
    return -1
  }
}

zookeeper-verify "$@"
