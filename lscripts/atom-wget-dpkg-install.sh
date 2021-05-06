#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Atom - text editor
###----------------------------------------------------------
#
## References:
## * https://atom.io/
## * https://atom-installer.github.com/v1.47.0/atom-amd64.deb?s=1589835132&ext=.deb
###----------------------------------------------------------


function atom-wget-dpkg-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  [[ ! -d "${BASEPATH}" ]] && mkdir -p "${BASEPATH}"

  if [ -z "${ATOM_VER}" ]; then
    local ATOM_VER="v1.47.0"
    echo "Unable to get ATOM_VER version, falling back to default version#: ${ATOM_VER}"
  fi

  local PROG="atom"
  local FILE="${PROG}-amd64.deb"

  local URL="https://atom-installer.github.com/${ATOM_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh

  sudo dpkg -i "${DOWNLOAD_PATH}/${FILE}" 2>/dev/null
  sudo apt --fix-broken -y install
  sudo dpkg -i "${DOWNLOAD_PATH}/${FILE}" 2>/dev/null
}

atom-wget-dpkg-install
