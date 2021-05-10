#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='markdown.md'
###----------------------------------------------------------
## markdown editors
###----------------------------------------------------------


function markdown-editors-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  source ${LSCRIPTS}/haroopad-wget-dpkg-install.sh
  source ${LSCRIPTS}/typora-apt-install.sh
  source ${LSCRIPTS}/ghostwriter-apt-install.sh
}

markdown-editors-install
