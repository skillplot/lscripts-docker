#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install utilities and softwares
###----------------------------------------------------------
## References
## * https://askubuntu.com/questions/1276408/night-light-not-working-in-ubuntu-20-04
## * https://www.debugpoint.com/adjust-color-temperature-ubuntu-terminal/
## * https://github.com/faf0/sct
###----------------------------------------------------------


function extras-apt-install.main() {
  # sudo apt -y install redshift
  # sudo apt -y install redshift redshift-gtk
  # vim ~/.config/redshift.conf
  # sudo apt -y install sct
  sudo apt -y install gnuplot

  # https://linuxconfig.org/how-to-fix-missing-plugin-gstreamer-on-ubuntu-18-04-bionic-beaver-linux
  # sudo apt -y install ubuntu-restricted-extras
}

extras-apt-install.main "$@"
