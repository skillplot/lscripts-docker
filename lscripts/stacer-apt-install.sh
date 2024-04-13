#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='tools.md'
###----------------------------------------------------------
## stacer - System Optimizer and Monitoring app
###----------------------------------------------------------
#
## References:
## * https://github.com/oguzhaninan/Stacer
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function stacer-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo add-apt-repository -y ppa:oguzhaninan/stacer
  sudo apt -y update
  sudo apt -y install stacer

}

stacer-apt-install.main "$@"
