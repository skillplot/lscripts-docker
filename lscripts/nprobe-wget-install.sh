#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## nprobe
#
## NOTE:
## * Note that ntopng must not be installed together with nedge. Remove ntopng before installing nedge.
## * Most software work without licenses. However some components do need a license. They include:
##    * PF_RING ZC user-space libraries
##    * nProbe (NetFlow/IPFIX probe)
##    * n2disk (packet to disk application)
## * ntop suggests to use Ubuntu Server LTS or CentOS x64.
## * If you are a nProbe user and want to install a nprobe package with no dependency, please install the nprobes
## (rather than the nprobe) package. Note that you can either install the nprobe or the nprobes package
## butPF_RING ZC user-space libraries
##    * nProbe (NetFlow/IPFIX probe)
##    *  NOT both simultaneously.
#
## References:
## * https://packages.ntop.org/apt-stable/
###----------------------------------------------------------


function nprobe-wget-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  # if [ -z "${NPROBE_VER}" ]; then
  #   # local NPROBE_VER="v1.47.0"
  #   local NPROBE_VER="v1.58.0"
  #   echo "Unable to get NPROBE_VER version, falling back to default version#: ${NPROBE_VER}"
  # fi

  local PROG="nprobe"
  local FILE="apt-ntop-stable.deb"
  ## latest
  local URL="https://packages.ntop.org/apt-stable/${LINUX_VERSION}/all/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"
  # echo "FILEPATH: ${_LSD__DOWNLOADS_HOME}/${FILE}"
  echo "FILEPATH: ${_LSD__DOWNLOADS}/${FILE}"

  # sudo apt install software-properties-common wget
  # sudo add-apt-repository universe

  ## wget https://packages.ntop.org/apt-stable/20.04/all/apt-ntop-stable.deb
  source ${LSCRIPTS}/partials/wget.sh

  sudo apt -y install ${_LSD__DOWNLOADS}/${FILE}
  sudo apt -y update
  sudo apt -y install pfring-dkms nprobe ntopng n2disk cento
  ## You can (optionally) install the ZC drivers as follows
  # sudo apt -y install pfring-drivers-zc-dkms
}

nprobe-wget-install "$@"
