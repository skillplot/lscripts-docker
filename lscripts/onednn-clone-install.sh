#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## oneAPI Deep Neural Network Library (oneDNN) is an open-source cross-platform performance library of basic building blocks for deep learning applications. oneDNN project is part of the UXL Foundation and is an implementation of the oneAPI specification for oneDNN component.
###----------------------------------------------------------
#
## Referenecs:
## * https://github.com/oneapi-src/oneDNN.git
## * https://www.oneapi.io/
###----------------------------------------------------------


function __oneDNN-pre_requisite() {
  ## Todo: check if this is required or not; but this is required for parallel processing in pytorch
  sudo apt -y install libomp-dev
}


function __oneDNN-build() {
  local DIR="oneDNN"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"

  local URL="https://github.com/oneapi-src/${DIR}.git"

  lsd-mod.log.info "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.info "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.info "URL: ${URL}"
  lsd-mod.log.info "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/gitclone.sh
  cd ${PROG_DIR}
  git pull
  # local oneDNN_REL="19"
  # git checkout ${oneDNN_REL}

  [[ -d ${PROG_DIR}/build ]] && rm -rf ${PROG_DIR}/build

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..

  ## not required
  # ccmake ..

  make -j${NUMTHREADS}

  [[ $? -eq 0 ]] && {
    lsd-mod.log.info "Installing..."
    sudo make install -j${NUMTHREADS}
  } || lsd-mod.log.error "Build failed"

  cd -
}


function oneDNN-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="oneDNN"

  lsd-mod.log.info "Clone & compile ${_prog}..."
  lsd-mod.log.warn "sudo access is required to install the compiled code!"

  local _default=yes
  local _que
  local _msg

  _que="Clone & compile ${_prog} now"
  _msg="Skipping ${_prog} clonning & compiling!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Installing pre-requisites..."
      __${_prog}-pre_requisite

      lsd-mod.log.echo "Cloning & compiling..."
      __${_prog}-build
    } || lsd-mod.log.echo "${_msg}"

}

oneDNN-install.main "$@"
