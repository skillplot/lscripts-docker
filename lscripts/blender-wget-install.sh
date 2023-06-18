#!/bin/bash

## Copyright (c) 2023 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## blender
###----------------------------------------------------------
#
## References:
## * https://www.blender.org
## * https://www.blender.org/download/
###----------------------------------------------------------

## Todo: refactor into multiple functions
## Todo: CODEHUB TOOLS Directory concept introduced
function blender-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh


  if [ -z "${BLENDER_VER}" ]; then
    local BLENDER_VER="3.5.1"
    lsd-mod.log.echo "Unable to get BLENDER_VER version, falling back to default version#: ${BLENDER_VER}"
  fi

  local _prog="blender"

  local _MAJOR_VER=3.5
  local PROG=${_prog}
  local DIR="${PROG}-${BLENDER_VER}-linux-x64"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"
  local FILE="${DIR}.tar.xz"
  # local FILE="blender-3.5.1-linux-x64.tar.xz"

  # local URL=https://ftp.halifax.rwth-aachen.de/blender/release/Blender3.5/blender-3.5.1-linux-x64.tar.xz
  local URL="https://ftp.halifax.rwth-aachen.de/blender/release/Blender${_MAJOR_VER}/${FILE}"

  lsd-mod.log.echo "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.echo "URL: ${URL}"
  lsd-mod.log.echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untartxz.sh

  local _LSD_CODEHUB_TOOLS_DIR="${__CODEHUB_ROOT__}/tools"

  [[ -d "${PROG_DIR}" ]] && (
    lsd-mod.log.echo "${PROG_DIR}"
    lsd-mod.log.echo "moving ${PROG_DIR} to ${_LSD_CODEHUB_TOOLS_DIR}"
  )
}

blender-wget-install.main "$@"
