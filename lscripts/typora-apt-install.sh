#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## typora - markdown editor
###----------------------------------------------------------
#
## References:
## * https://typora.io/#linux
##----------------------------------------------------------


function typora-apt-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ### Uninstall.
  ## todo

  # or run:
  # wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -

  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
  # add Typora's repository
  sudo add-apt-repository -y 'deb https://typora.io/linux ./'
  sudo apt -y update
  sudo apt -y install typora

}

typora-apt-install
