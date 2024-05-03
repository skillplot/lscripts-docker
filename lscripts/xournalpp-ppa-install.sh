#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## xournalpp
## https://xournalpp.github.io/installation/linux/
###----------------------------------------------------------


function xournalpp-ppa-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local target_version="20.04"

  if [[ "$LINUX_VERSION" == "$target_version" || "$LINUX_VERSION" < "$target_version" ]]; then
    ## (Ubuntu-based distros only): Install the latest stable release from the following unofficial PPA
    sudo add-apt-repository -y ppa:apandada1/xournalpp-stable
  fi

  sudo apt -y update
  sudo apt -y install xournalpp
}

xournalpp-ppa-install.main "$@"
