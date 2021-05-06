#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


function __kafka-service-setup() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

  local KAFKA_HOME=$1
  [[ ! -z ${KAFKA_HOME} ]] || _log_.fail "Undefined KAFKA_HOME: ${KAFKA_HOME}"

  local kafkaservicename=kafka.service
  local service_filepath=${LSCRIPTS}/config/kafka/${kafkaservicename}
  ## Todo: _log_.error check and dynamic service file

  sudo cp ${service_filepath} /etc/systemd/system/

  sudo systemctl enable ${kafkaservicename}
  sudo journalctl --vacuum-time=1d
  sudo systemctl restart ${kafkaservicename}
  # sudo systemctl status ${kafkaservicename}
}


function __kafka-stop() {
  local KAFKA_HOME=$1
  [[ ! -z ${KAFKA_HOME} ]] || _log_.fail "Undefined KAFKA_HOME: ${KAFKA_HOME}"

  /bin/bash -c ${KAFKA_HOME}/bin/kafka-server-stop.sh
}


function __kafka-start() {
  local KAFKA_HOME=$1
  local KAFKA_CONFIG=$2
  [[ ! -z ${KAFKA_HOME} ]] || _log_.fail "Undefined KAFKA_HOME: ${KAFKA_HOME}"
  [[ ! -z ${KAFKA_CONFIG} ]] || _log_.fail "Undefined KAFKA_CONFIG: ${KAFKA_CONFIG}"

  /bin/bash -c ${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_CONFIG} > ${AI_LOGS}/kafka.log 2>&1
}
