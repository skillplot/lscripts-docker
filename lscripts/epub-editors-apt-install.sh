#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='epub.md'
###----------------------------------------------------------
## epub editors
###----------------------------------------------------------
#
## References:
## * https://www.fosslinux.com/1220/how-to-create-edit-epub-ebooks-in-ubuntu-linux-mint-and-elementary-os.htm
###----------------------------------------------------------


function epub-editors-apt-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo apt -y install sigil
  sudo apt -y install calibre

}

epub-editors-apt-install
