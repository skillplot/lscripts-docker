#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


function __zookeeper-service-setup() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

  local ZOOKEEPER_HOME=$1
  [[ ! -z ${ZOOKEEPER_HOME} ]] || lsd-mod.log.fail "Undefined ZOOKEEPER_HOME: ${ZOOKEEPER_HOME}"

  local zookeeperservicename=zookeeper.service
  local service_filepath=${LSCRIPTS}/core/config/zookeeper/${zookeeperservicename}
  ## Todo: lsd-mod.log.error check and dynamic service file

  sudo cp ${service_filepath} /etc/systemd/system/

  sudo systemctl enable ${zookeeperservicename}
  sudo journalctl --vacuum-time=1d
  sudo systemctl restart ${zookeeperservicename}
  # sudo systemctl status ${zookeeperservicename}
}


function __zookeeper-stop() {
  local ZOOKEEPER_HOME=$1
  [[ ! -z ${ZOOKEEPER_HOME} ]] || lsd-mod.log.fail "Undefined ZOOKEEPER_HOME: ${ZOOKEEPER_HOME}"

  sudo /bin/bash -c ${ZOOKEEPER_HOME}/bin/zkServer.sh stop >> ${_BZO__LOGS}/zookeeper.log 2>&1
}


function __zookeeper-start() {
  local ZOOKEEPER_HOME=$1
  local ZOOKEEPER_CONFIG=$2
  [[ ! -z ${ZOOKEEPER_HOME} ]] || lsd-mod.log.fail "Undefined ZOOKEEPER_HOME: ${ZOOKEEPER_HOME}"
  [[ ! -z ${ZOOKEEPER_CONFIG} ]] || lsd-mod.log.fail "Undefined ZOOKEEPER_CONFIG: ${ZOOKEEPER_CONFIG}"

  mkdir -p ${_BZO__LOGS}/zookeeper
  sudo /bin/bash ${ZOOKEEPER_HOME}/bin/zkServer.sh --config ${ZOOKEEPER_CONFIG} start > ${_BZO__LOGS}/zookeeper/zookeeper.log 2>&1
  sudo /bin/bash /boozo-hub/data/external/zookeeper/bin/zkServer.sh --config $PWD/core/config/zookeeper start
}
