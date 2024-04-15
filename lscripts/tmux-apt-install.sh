#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## tmux
###----------------------------------------------------------


function tmux-apt-install.main() {
  ##sudo apt -y update
  sudo apt -y install tmux
}

tmux-apt-install.main "$@"
