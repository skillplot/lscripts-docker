#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## shutter
###----------------------------------------------------------
#
## References:
## * http://shutter-project.org/about/
## * http://tipsonubuntu.com/2015/04/13/install-the-latest-shutter-screenshot-tool-in-ubuntu/
## * http://lightscreen.com.ar/
## * http://ubuntuhandbook.org/index.php/2018/10/how-to-install-shutter-screenshot-tool-in-ubuntu-18-10/
###----------------------------------------------------------


function shutter-ppa-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [[ ${LINUX_VERSION} == "16.04" ]]; then
    sudo add-apt-repository -y ppa:shutter/ppa
    sudo apt -y update
    sudo apt -y install shutter
  fi

  if [[ ${LINUX_VERSION} == "18.04" ]]; then
    sudo add-apt-repository -y ppa:ubuntuhandbook1/shutter
    sudo apt -y install shutter
  fi

  ## To uninstall
  # sudo -E apt remove --autoremove shutter

  ## And go to Software & Updates -> Other Software to remove third-party PPA repositories.
  ## For kali Linux Screenshot utilities, also available on Ubuntu
  ## https://blog.anantshri.info/content/uploads/2010/09/add-apt-repository.sh.txt
  # sudo apt -y install scrot screengrab
}

shutter-ppa-install.main "$@"
