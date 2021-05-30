#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ghostwriter - markdown editor
###----------------------------------------------------------
#
## References:
## * https://github.com/wereturtle/ghostwriter
## * http://wereturtle.github.io/ghostwriter/
###----------------------------------------------------------


function ghostwriter-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ### Uninstall.
  ## todo

  ## staging
  # sudo add-apt-repository ppa:wereturtle/staging

  sudo add-apt-repository -y ppa:wereturtle/ppa
  sudo apt -y update
  sudo apt -y install ghostwriter
}

ghostwriter-apt-install.main "$@"
