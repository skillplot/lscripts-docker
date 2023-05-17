#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## todo
###----------------------------------------------------------
#
## References:
## telegram desktop
## * https://telegram.org/dl/desktop/linux
## * https://updates.tdesktop.com/tlinux/tsetup.1.9.3.tar.xz
###----------------------------------------------------------


sudo dpkg -i ~/Downloads/discord-0.0.9.deb

sudo apt -y install libappindicator1 libc++1 libindicator7


function discord-wget-dpkg-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  if [ -z "${DISCORD_VER}" ]; then
    local DISCORD_VER="v1.47.0"
    echo "Unable to get DISCORD_VER version, falling back to default version#: ${DISCORD_VER}"
  fi

  local PROG="discord"
  local FILE="${PROG}-amd64.deb"

  local URL="https://atom-installer.github.com/${DISCORD_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh

  source ${LSCRIPTS}/partials/dpkg.install.sh
  sudo apt --fix-broken -y install
  source ${LSCRIPTS}/partials/dpkg.install.sh
}

discord-wget-dpkg-install
