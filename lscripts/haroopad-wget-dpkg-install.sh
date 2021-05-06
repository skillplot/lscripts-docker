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


function haroopad-wget-dpkg-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  [[ ! -d "${BASEPATH}" ]] && mkdir -p "${BASEPATH}"

  if [ -z "${HAROOPAD_VER}" ]; then
    local HAROOPAD_VER="0.13.1"
    echo "Unable to get HAROOPAD_VER version, falling back to default version#: ${HAROOPAD_VER}"
  fi

  sudo apt -y install libgconf2-4

  local PROG='haroopad'
  local FILE="${PROG}-v${HAROOPAD_VER}-x64.deb"

  local URL="https://bitbucket.org/rhiokim/haroopad-download/downloads/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh

  sudo dpkg -i "${DOWNLOAD_PATH}/${FILE}"
}

haroopad-wget-dpkg-install
