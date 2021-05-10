#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gcc, g++ multiple version configuration
###----------------------------------------------------------
#
## -DCMAKE_C_COMPILER=/usr/bin/gcc-6 -DCMAKE_CXX_COMPILER=/usr/bin/g++-6
## https://stackoverflow.com/questions/39854114/set-gcc-version-for-make-in-shell
## make CC=gcc-4.4 CPP=g++-4.4 CXX=g++-4.4 LD=g++-4.4
#
## * https://codeyarns.com/2015/02/26/how-to-switch-gcc-version-using-update-alternatives/
#
### Alternative to update-alternative options is to create sym link
### I preferred update-alternatives option
#
## gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
###----------------------------------------------------------
## sudo ln -s /usr/bin/gcc-5 /usr/local/cuda/bin/gcc 
## sudo ln -s /usr/bin/g++-5 /usr/local/cuda/bin/g++
#
## so to fix this, just make gcc6 available
## first install gcc6 and g++6
## sudo apt install -y gcc-6 g++-6
## next, link them into your cuda stack
##
## sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc 
## sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++
###----------------------------------------------------------



function gcc-update-alternatives() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 10 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 20 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 30 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 100 --slave /usr/bin/g++ g++ /usr/bin/g++-6
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 200 --slave /usr/bin/g++ g++ /usr/bin/g++-7
  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-8
  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 300 --slave /usr/bin/g++ g++ /usr/bin/g++-9
  sudo update-alternatives --config gcc
}

gcc-update-alternatives
