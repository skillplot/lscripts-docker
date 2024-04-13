#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='networking.sumulator.md'
###----------------------------------------------------------
## ns-3
## ns-3 is a discrete-event network simulator, targeted primarily for research and educational use. ns-3 is free software, licensed under the GNU GPLv2 license, and is publicly available for research, development, and use.
###----------------------------------------------------------
#
## References:
## * https://www.nsnam.org/releases/ns-3-29/download/
## * https://www.nsnam.org/wiki/Installation
#
## `wget -c https://www.nsnam.org/releases/ns-allinone-3.37.tar.bz2`
###----------------------------------------------------------


function ns3-wget-tar-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  ## program specific variables
  if [ -z "${NS3_VER}" ]; then
    local NS3_VER="3.37"
    echo "Unable to get NS3_VER version, falling back to default version#: ${NS3_VER}"
  fi

  local PROG='ns-allinone'
  local DIR=${PROG}
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${PROG}"
  local FILE="${PROG}-${NS3_VER}.tar.bz2"

  local URL="https://www.nsnam.org/releases/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untarbz2.sh

  # cd ${PROG_DIR}

  # cd ${LSCRIPTS}
}

ns3-wget-tar-install.main "$@"
