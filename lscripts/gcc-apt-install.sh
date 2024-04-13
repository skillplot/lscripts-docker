#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
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


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 lsd-mod.log.debug -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function __gcc-config() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  local _gcc_ver=$1
  source ${LSCRIPTS}/gcc-update-alternatives.sh ${_gcc_ver}
}


function __gcc-install() {
  ## Todo: conditional for specific version
  local _gcc_ver=$1
  [[ ! -z ${_gcc_ver} ]] && {
    lsd-mod.log.debug "_gcc_ver: ${_gcc_ver}"
    lsd-mod.log.debug "sudo apt -y install gcc-${_gcc_ver} g++-${_gcc_ver}"
    sudo apt -y install gcc-${_gcc_ver} g++-${_gcc_ver}
  } || {
    lsd-mod.log.debug "_gcc_ver: ${_gcc_ver}"

    lsd-mod.log.debug "GCC_VERS: ${GCC_VERS[@]}"
    for _gcc_ver in ${GCC_VERS[@]}; do
      lsd-mod.log.debug "sudo apt -y install gcc-${_gcc_ver} g++-${_gcc_ver}"
      sudo apt -y install gcc-${_gcc_ver} g++-${_gcc_ver}
    done
    # sudo apt -y install gcc-8 g++-8
    # sudo apt -y install gcc-7 g++-7
    # sudo apt -y install gcc-6 g++-6
    # sudo apt -y install gcc-5 g++-5
    # sudo apt -y install gcc-4.8 g++-4.8
  }
}


function gcc-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="gcc"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.debug "Installing..."
    __${_prog}-install "$@"
  } || lsd-mod.log.debug "${_msg}"

  _que="Configure ${_prog} now"
  _msg="Skipping ${_prog} configuration!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.debug "Configuration..."
    __${_prog}-config "$@"
  } || lsd-mod.log.debug "${_msg}"
}

gcc-install.main "$@"
