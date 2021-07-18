#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## PCL Pre-requisite
###----------------------------------------------------------
#
## References:
## * http://pointclouds.org/downloads/linux.html
#
## Setup Prerequisites
## * https://larrylisky.com/2016/11/03/point-cloud-library-on-ubuntu-16-04-lts/
#
## As binaries
## `sudo add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl`
## `sudo apt update`
## `sudo apt -y install libpcl-all`
###----------------------------------------------------------


function __prerequisite-pcl-install() {
  sudo apt -y update
  sudo apt -y install git build-essential linux-libc-dev
  sudo apt -y install cmake cmake-gui 
  sudo apt -y install libusb-1.0-0-dev libusb-dev libudev-dev
  sudo apt -y install mpi-default-dev openmpi-bin openmpi-common  

  if [[ ${LINUX_VERSION} == "16.04" ]]; then
    sudo apt -y install libflann1.8 libflann-dev
    sudo apt -y install libvtk5.10-qt4 libvtk5.10 libvtk5-dev
  fi

  if [[ ${LINUX_VERSION} == "18.04" ]]; then
    sudo apt -y install libflann1.9 libflann-dev
    sudo apt -y install libvtk7.1 libvtk7-dev libvtk7.1-qt libvtk7-qt-dev libvtk7-java libvtk7-jni
  fi

  sudo apt -y install libeigen3-dev
  sudo apt -y install libboost-all-dev

  sudo apt -y install libqhull* libgtest-dev
  sudo apt -y install freeglut3-dev pkg-config
  sudo apt -y install libxmu-dev libxi-dev 
  sudo apt -y install mono-complete
}


function prerequisite-pcl-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _default=no
  local _que
  local _msg
  local _prog

  _prog="prerequisite-pcl"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install || {
      lsd-mod.log.echo "${_msg}"
    }

}

prerequisite-pcl-install.main "$@"
