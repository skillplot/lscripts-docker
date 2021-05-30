#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Octave - Opensource alternative to matlab
###----------------------------------------------------------


function octave-apt-install.main() {
  sudo apt -y install octave
}

octave-apt-install.main "$@"
