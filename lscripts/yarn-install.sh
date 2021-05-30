#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install yarn
#
## Reference:
## https://yarnpkg.com/lang/en/docs/install/#debian-stable
## https://code.facebook.com/posts/1840075619545360
##----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function yarn-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  _log_.info "Installing yarn:"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt -y update
  sudo apt -y install --no-install-recommends yarn

  ## export PATH="${PATH}:/opt/yarn-[version]/bin"

  _log_.info "yarn version is: $(yarn --version)"
}

yarn-install.main "$@"
