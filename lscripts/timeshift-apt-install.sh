#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='tools.md'
###----------------------------------------------------------
## timeshift - Timeshift for Linux is an application that provides functionality similar to the
## System Restore feature in Windows and the Time Machine tool in Mac OS.
###----------------------------------------------------------
#
## References:
## * https://github.com/teejee2008/timeshift
##----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function timeshift-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo add-apt-repository -y ppa:teejee2008/timeshift
  sudo apt-get update
  sudo apt-get install timeshift

}

timeshift-apt-install.main "$@"
