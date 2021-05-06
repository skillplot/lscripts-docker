#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## xnview
###----------------------------------------------------------
#
## References:
## * https://www.xnview.com/en/xnviewmp/#downloads
###----------------------------------------------------------


function xnview-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local FILE=XnViewMP-linux-x64.deb
  local URL=https://download.xnview.com/${FILE}
  source ${LSCRIPTS}/partials/wget.sh

  sudo dpkg -i ${DOWNLOAD_PATH}/${FILE}

}

xnview-install
