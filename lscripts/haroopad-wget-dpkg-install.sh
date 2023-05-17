#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Haroopad - markdown editor
###----------------------------------------------------------
#
## References:
## * http://pad.haroopress.com/user.html
###----------------------------------------------------------


function haroopad-wget-dpkg-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  if [ -z "${HAROOPAD_VER}" ]; then
    local HAROOPAD_VER="0.13.1"
    echo "Unable to get HAROOPAD_VER version, falling back to default version#: ${HAROOPAD_VER}"
  fi

  sudo apt -y install libgconf2-4

  local PROG='haroopad'
  local FILE="${PROG}-v${HAROOPAD_VER}-x64.deb"

  local URL="https://bitbucket.org/rhiokim/haroopad-download/downloads/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh

  source ${LSCRIPTS}/partials/dpkg.install.sh
}

haroopad-wget-dpkg-install.main "$@"
