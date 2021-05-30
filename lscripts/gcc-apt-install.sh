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
#
## gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function gcc-config() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${LSCRIPTS}/gcc-update-alternatives.sh
}


function __gcc-install() {
  ## Todo: conditional for specific version
  sudo apt -y install gcc-8 g++-8
  sudo apt -y install gcc-7 g++-7
  sudo apt -y install gcc-6 g++-6
  sudo apt -y install gcc-5 g++-5
  sudo apt -y install gcc-4.8 g++-4.8
}


function gcc-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _prog="gcc"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" {
      _log_.echo "Installing..."
      __${_prog}-install
  } || _log_.echo "${_msg}"

  _que="Configure ${_prog} now"
  _msg="Skipping ${_prog} configuration!"
  _fio_.yesno_${_default} "${_que}" {
      _log_.echo "Configuration..."
      __${_prog}-config
  } || _log_.echo "${_msg}"
}

gcc-install.main "$@"
