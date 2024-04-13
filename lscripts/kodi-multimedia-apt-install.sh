#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='tools.md'
###----------------------------------------------------------
## Kodi - open-source Home Theater software
###----------------------------------------------------------
#
## References:
## * https://kodi.tv/
## * https://github.com/xbmc/xbmc
## * https://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux
##----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function kodi-multimedia-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  # sudo apt-get install software-properties-common
  sudo add-apt-repository -y ppa:team-xbmc/ppa
  sudo apt-get -y update
  sudo apt-get -y install kodi

}

kodi-multimedia-apt-install.main "$@"
