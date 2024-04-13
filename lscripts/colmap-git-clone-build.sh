#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## References
## * https://github.com/colmap/colmap/issues/1940
#
## CMake Error at CMakeLists.txt:262 (message):
##   You must set CMAKE_CUDA_ARCHITECTURES to e.g.  'native', 'all-major', '70',
##   etc.  More information at
##   https://cmake.org/cmake/help/latest/prop_tgt/CUDA_ARCHITECTURES.html
###----------------------------------------------------------


function __colmap-pre_requisite() {
  ## colmap
  sudo apt -y install \
    git \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev
}


## function __colmap-package() {
##
##  cmake --build .
##  ## For a faster build, set the flag -DCMAKE_BUILD_TYPE=RelWithDebInfo
##
##  cmake .. -DCPACK_GENERATOR="DEB" ..
##  cmake --build . --target package
##  cd packages/
##  sudo dpkg -i colmap-1.1.0-Ubuntu-bionic-x86_64.deb
##
##}


function __colmap-build() {
  # local COLMAP_REL=""
  local DIR="colmap"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}${COLMAP_REL}"

  local URL="http://github.com/colmap/${DIR}.git"

  lsd-mod.log.info "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.info "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.info "URL: ${URL}"
  lsd-mod.log.info "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    lsd-mod.log.echo Gid clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  git pull
  git checkout dev
  # git checkout ${COLMAP_REL}_TAG

  [[ -d ${PROG_DIR}/build ]] && rm -rf ${PROG_DIR}/build


  mkdir ${PROG_DIR}/build

  cd ${PROG_DIR}/build

  # cmake -DCPACK_GENERATOR="DEB" \
  #       -DCMAKE_INSTALL_PREFIX=/usr/local ..

  cmake .. -GNinja -DCMAKE_CUDA_ARCHITECTURES=native -DCMAKE_INSTALL_PREFIX=/usr/local ..

  ## not required
  # ccmake ..

  # make -j${NUMTHREADS}

  # ninja
  ninja -j${NUMTHREADS}

  [[ $? -eq 0 ]] && {
    lsd-mod.log.info "Installing..."
    lsd-mod.log.echo "sudo ninja"
    lsd-mod.log.echo "sudo ninja install -j${NUMTHREADS}"

    lsd-mod.log.info "colmap commands..."
    lsd-mod.log.echo "colmap -h"
    lsd-mod.log.echo "colmap gui"
  } || lsd-mod.log.error "Build failed"

  cd -

}


function colmap-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="colmap"

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

colmap-install "$@"
