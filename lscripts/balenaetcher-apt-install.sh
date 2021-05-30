#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## balena-etcher-electron Live USB, CD creation tool
###----------------------------------------------------------
#
## References
## * https://www.balena.io/etcher/
## * https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64
## * https://www.raspberrypi.org/documentation/installation/installing-images/README.md
## * https://www.raspberrypi.org/documentation/installation/installing-images/linux.md
###----------------------------------------------------------


function balenaetcher-apt-install() {
  echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61

  sudo apt -y update
  sudo apt -y install balena-etcher-electron

  # ## Uninstall
  ## sudo apt remove balena-etcher-electron
  ## sudo rm /etc/apt/sources.list.d/balena-etcher.list
  ## sudo apt update

  # ## https://www.raspberrypi.org/downloads/raspbian/
  # ## Lite
  # wget -c https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/2019-09-26-raspbian-buster-lite.zip

  # ## Full
  # wget -c https://downloads.raspberrypi.org/raspbian_full/images/raspbian_full-2019-09-30/2019-09-26-raspbian-buster-full.zip
}

balenaetcher-apt-install "$@"
