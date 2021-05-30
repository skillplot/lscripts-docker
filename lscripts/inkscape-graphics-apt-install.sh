#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## inkscape
###----------------------------------------------------------
#
## References:
## * https://launchpad.net/~inkscape.dev/+archive/ubuntu/stable
###----------------------------------------------------------


function inkscape-graphics-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  [[ ${LINUX_VERSION} == "16.04" ]] && (
  	sudo add-apt-repository -y ppa:inkscape.dev/stable
    sudo apt -y update
  )

  sudo apt -y install inkscape
}

inkscape-graphics-apt-install.main "$@"
