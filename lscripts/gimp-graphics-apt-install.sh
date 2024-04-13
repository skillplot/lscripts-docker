#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gimp
###----------------------------------------------------------
#
## References:
## * http://ubuntuhandbook.org/index.php/2015/11/how-to-install-gimp-2-8-16-in-ubuntu-16-04-15-10-14-04/
###----------------------------------------------------------


function gimp-graphics-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  [[ ${LINUX_VERSION} == "16.04" ]] && (
    ### Uninstall.
    ##sudo apt -y install ppa-purge
    ##sudo ppa-purge ppa:otto-kesselgulasch/gimp

    sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
    sudo apt -y update
  )

  sudo apt -y install gimp
}

gimp-graphics-apt-install.main "$@"
