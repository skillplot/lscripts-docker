#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Scribus
###----------------------------------------------------------
#
## References:
## * https://askubuntu.com/questions/825391/install-scribus-1-5-on-ubuntu-16-04
###----------------------------------------------------------


function scribus-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [[ ${LINUX_VERSION} == "16.04" ]]; then
    sudo -E add-apt-repository -y ppa:scribus/ppa
    sudo apt -y update
    sudo apt -y install scribus-ng
  fi

  if [[ ${LINUX_VERSION} == "18.04" ]]; then
    sudo apt -y install scribus scribus-template scribus-doc
  fi
}

scribus-apt-install.main "$@"
