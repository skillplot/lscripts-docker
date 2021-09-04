#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## References
## * https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile
## * https://www.omgubuntu.co.uk/2017/10/stylus-labs-write-handwriting-notes-app-linux
## * https://linuxhint.com/xournal_annotate_sign_pdf_ubuntu/

#
###----------------------------------------------------------


function __xournalpp-pre_requisite() {
  ## xournalpp
  sudo apt-get install cmake libgtk-3-dev libpoppler-glib-dev portaudio19-dev libsndfile-dev libcppunit-dev dvipng texlive libxml2-dev liblua5.3-dev libzip-dev librsvg2-dev gettext lua-lgi
}


# function __xournalpp-package() {}


function __xournalpp-build() {
  # local XOURNALPP_REL=""
  local DIR="xournalpp"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}${XOURNALPP_REL}"

  local URL="http://github.com/xournalpp/${DIR}.git"

  lsd-mod.log.info "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.info "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.info "URL: ${URL}"
  lsd-mod.log.info "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Gid clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  git pull
  # git checkout ${XOURNALPP_REL}_TAG

  [[ -d ${PROG_DIR}/build ]] && rm -rf ${PROG_DIR}/build

  mkdir ${PROG_DIR}/build

  cd ${PROG_DIR}/build

  # cmake -DCPACK_GENERATOR="DEB" \
  #       -DCMAKE_INSTALL_PREFIX=/usr/local ..

  cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..

  ## not required
  # ccmake ..

  make -j${NUMTHREADS}

  [[ $? -eq 0 ]] && {
    lsd-mod.log.info "Installing..."
    echo "sudo make install -j${NUMTHREADS}"
  } || lsd-mod.log.error "Build failed"

  cd -

}


function xournalpp-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="xournalpp"

  lsd-mod.log.info "Clone & compile ${_prog}..."
  lsd-mod.log.warn "sudo access is required to install the compiled code!"

  local _default=no
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

xournalpp-install "$@"
