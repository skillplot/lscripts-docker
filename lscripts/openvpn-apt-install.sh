#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## OpenVPN
###----------------------------------------------------------


function openvpn-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo apt -y install openvpn

  # local FILE=TODO.ovpn
  # sudo openvpn --config ${_LSD__DOWNLOADS_HOME}/${FILE}
}

openvpn-apt-install.main "$@"
