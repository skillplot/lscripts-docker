#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## xnview
###----------------------------------------------------------
#
## References:
## * https://www.xnview.com/en/xnviewmp/#downloads
###----------------------------------------------------------


function xnview-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local FILE=XnViewMP-linux-x64.deb
  local URL=https://download.xnview.com/${FILE}
  source ${LSCRIPTS}/partials/wget.sh

  source ${LSCRIPTS}/partials/dpkg.install.sh

}

xnview-wget-install.main "$@"
