#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Lscripts utilities and softwares
###----------------------------------------------------------


function core-apt-install.main() {
  ## sudo apt -y update

  ## Essential for New Machine Setup
  sudo apt -y install git
  sudo apt -y install gparted
  sudo apt -y install net-tools
  sudo apt -y install ppa-purge
  sudo apt -y install sshfs
  sudo apt -y install mono-complete
  sudo apt -y install inxi
}

core-apt-install.main "$@"
