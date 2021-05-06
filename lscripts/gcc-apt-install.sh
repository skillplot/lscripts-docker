#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gcc, g++ multiple version configuration
###----------------------------------------------------------
#
## References:
## * https://codeyarns.com/2015/02/26/how-to-switch-gcc-version-using-update-alternatives/
#
## -DCMAKE_C_COMPILER=/usr/bin/gcc-6 -DCMAKE_CXX_COMPILER=/usr/bin/g++-6
## https://stackoverflow.com/questions/39854114/set-gcc-version-for-make-in-shell
## make CC=gcc-4.4 CPP=g++-4.4 CXX=g++-4.4 LD=g++-4.4
###----------------------------------------------------------


sudo apt -y install gcc-7 g++-7
sudo apt -y install gcc-6 g++-6
sudo apt -y install gcc-5 g++-5
# sudo apt -y install gcc-4.8 g++-4.8

function gcc_update_alternatives() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${LSCRIPTS}/gcc-update-alternatives.sh
}

gcc_update_alternatives
