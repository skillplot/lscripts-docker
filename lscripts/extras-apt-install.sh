#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install utilities and softwares
###----------------------------------------------------------


function extras-apt-install.main() {
  # sudo apt -y install redshift
  sudo apt -y install gnuplot

  # https://linuxconfig.org/how-to-fix-missing-plugin-gstreamer-on-ubuntu-18-04-bionic-beaver-linux
  # sudo apt -y install ubuntu-restricted-extras
}

extras-apt-install.main "$@"
