#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## WINE
###----------------------------------------------------------
#
## Ubuntu 16.04 LTS
## * http://ubuntuhandbook.org/index.php/2015/12/install-wine-1-8-stable-new-ppa/
#
# `sudo -E add-apt-repository ppa:ubuntu-wine/ppa`
# `sudo -E apt update`
# `sudo -E apt -q -y install wine1.8 winetricks`
#
## Ubuntu 18.04 LTS
## * https://linuxconfig.org/install-wine-on-ubuntu-18-04-bionic-beaver-linux
## The recommended approach to install Wine on Ubuntu 18.04 is to perform the installation from an Ubuntu repository 
###----------------------------------------------------------


function wine-apt-install.main() {
  sudo apt -y install wine64
  wine --version
}

wine-apt-install.main "$@"
