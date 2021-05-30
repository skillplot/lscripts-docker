#!/bin/bash

## Copyright (c) 2020 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## makehuman
#
## References:
## http://www.makehumancommunity.org/
## https://github.com/makehumancommunity/makehuman
## https://launchpad.net/~makehuman-official/+archive/ubuntu/makehuman-community
##----------------------------------------------------------


function makehuman3d-ppa-install.main() {
  sudo add-apt-repository ppa:makehuman-official/makehuman-community
  sudo apt -y update

  ## dependencies
  # sudo apt -y install python3-numpy python3-opengl python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg

  sudo apt -y install makehuman-community
}

makehuman3d-ppa-install.main "$@"
