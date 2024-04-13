#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## balena-etcher-electron Live USB, CD creation tool
###----------------------------------------------------------
#
## References
## * https://etcher.balena.io/#download-etcher
## * https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64
## * https://github.com/balena-io/etcher/releases/download/v1.19.5/balena-etcher_1.19.5_amd64.deb
##
## * https://www.raspberrypi.org/documentation/installation/installing-images/README.md
## * https://www.raspberrypi.org/documentation/installation/installing-images/linux.md
###----------------------------------------------------------
## preivously
###----------------------------------------------------------
# echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61

# sudo apt -y update
# sudo apt -y install balena-etcher-electron

# # ## Uninstall
# ## sudo apt remove balena-etcher-electron
# ## sudo rm /etc/apt/sources.list.d/balena-etcher.list
# ## sudo apt update

# # ## https://www.raspberrypi.org/downloads/raspbian/
# # ## Lite
# # wget -c https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/2019-09-26-raspbian-buster-lite.zip

# # ## Full
# # wget -c https://downloads.raspberrypi.org/raspbian_full/images/raspbian_full-2019-09-30/2019-09-26-raspbian-buster-full.zip

###----------------------------------------------------------


function balenaetcher-wget-dpkg-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__DOWNLOADS_HOME}" ]; then
    lsd-mod.log.echo "Unable to get BASEPATH, using default path#: ${_LSD__DOWNLOADS_HOME}"
  fi

  [[ ! -d "${_LSD__DOWNLOADS_HOME}" ]] && mkdir -p "${_LSD__DOWNLOADS_HOME}"

  if [ -z "${BALENAETCHER_VER}" ]; then
    local BALENAETCHER_VER="1.19.5"
    lsd-mod.log.echo "Unable to get BALENAETCHER_VER version, falling back to default version#: ${BALENAETCHER_VER}"
  fi

  local PROG="balena-etcher"
  local FILE="${PROG}_${BALENAETCHER_VER}_amd64.deb"
  local URL="https://github.com/balena-io/etcher/releases/download/v${BALENAETCHER_VER}/${FILE}"

  _LSD__DOWNLOADS=${_LSD__DOWNLOADS_HOME}
  lsd-mod.log.echo "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.echo "BASEPATH: _LSD__DOWNLOADS:: ${_LSD__DOWNLOADS}"
  lsd-mod.log.echo "URL: ${URL}"

  source ${LSCRIPTS}/partials/wget.sh

  source ${LSCRIPTS}/partials/dpkg.install.sh
  # sudo dpkg -i "${_LSD__DOWNLOADS_HOME}/${FILE}" 2>/dev/null
  sudo apt --fix-broken -y install
  # sudo dpkg -i "${_LSD__DOWNLOADS_HOME}/${FILE}" 2>/dev/null
  source ${LSCRIPTS}/partials/dpkg.install.sh
}

balenaetcher-wget-dpkg-install "$@"
