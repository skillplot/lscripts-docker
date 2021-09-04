#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## xournal
###----------------------------------------------------------


function xournal-apt-install.main() {
  ##sudo apt -y update
  sudo apt -y install xournal
}

xournal-apt-install.main "$@"
