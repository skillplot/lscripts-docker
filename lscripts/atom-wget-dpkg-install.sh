#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
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

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    # local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  if [ -z "${ATOM_VER}" ]; then
    # local ATOM_VER="v1.47.0"
    local ATOM_VER="v1.58.0"
    echo "Unable to get ATOM_VER version, falling back to default version#: ${ATOM_VER}"
  fi

  local PROG="atom"
  local FILE="${PROG}-amd64.deb"

  # local URL="https://atom-installer.github.com/${ATOM_VER}/${FILE}"
  ## latest
  local URL="https://atom.io/download/deb"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"

  source ${LSCRIPTS}/partials/wget.sh

  source ${LSCRIPTS}/partials/dpkg.install.sh
  # sudo dpkg -i "${_LSD__DOWNLOADS_HOME}/${FILE}" 2>/dev/null
  sudo apt --fix-broken -y install
  # sudo dpkg -i "${_LSD__DOWNLOADS_HOME}/${FILE}" 2>/dev/null
  source ${LSCRIPTS}/partials/dpkg.install.sh
}

atom-wget-dpkg-install "$@"
