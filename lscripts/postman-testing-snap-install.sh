#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='REST.api.md'
###----------------------------------------------------------
## postman
###----------------------------------------------------------
#
## References:
## * https://tecadmin.net/how-to-install-postman-on-ubuntu-18-04/
## * https://learning.postman.com/docs/getting-started/installation-and-updates/#installing-postman-on-linux
###----------------------------------------------------------


function postman-testing-snap-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ### snapd
  ## sudo apt update
  ## sudo apt install snapd
  sudo snap install postman
}

postman-testing-snap-install.main "$@"
