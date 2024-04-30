#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## llvm
###----------------------------------------------------------
#
## Referenecs:
## * https://github.com/llvm/llvm-project.git
## * https://llvm.org/
###----------------------------------------------------------
## wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
## sudo add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main"
#
## sudo apt-get update
## sudo apt-get install llvm-18
#
## llvm-symbolizer --version
#
## Inside:: ~/.bashrc
# export PATH="${HOME}/.local/bin:/usr/local/bin:${PATH}"
# export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
#
## llvm-symbolizer --version
###----------------------------------------------------------


function __llvm-project-build() {
  local DIR="llvm-project"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"

  local URL="https://github.com/llvm/${DIR}.git"

  lsd-mod.log.info "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.info "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.info "URL: ${URL}"
  lsd-mod.log.info "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/gitclone.sh

  [[ $? -eq 0 ]] || {
    lsd-mod.log.error "Clone failed"
  }

  cd ${PROG_DIR}
  git pull
  # local llvm-project_REL="19"
  # git checkout ${llvm-project_REL}

  [[ -d ${PROG_DIR}/build ]] && rm -rf ${PROG_DIR}/build

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  ## cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
  cmake -G "Unix Makefiles" ../llvm \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local

  ## not required
  # ccmake ../llvm

  make -j${NUMTHREADS}

  [[ $? -eq 0 ]] && {
    lsd-mod.log.info "Installing..."
    lsd-mod.log.echo "sudo make install -j${NUMTHREADS}"

    # sudo make install -j${NUMTHREADS}
  } || lsd-mod.log.error "Build failed"

  cd -
}


function llvm-project-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="llvm-project"

  lsd-mod.log.info "Clone & compile ${_prog}..."
  lsd-mod.log.warn "sudo access is required to install the compiled code!"

  local _default=yes
  local _que
  local _msg

  _que="Clone & compile ${_prog} now"
  _msg="Skipping ${_prog} clonning & compiling!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {

      lsd-mod.log.echo "Cloning & compiling..."
      __${_prog}-build
    } || lsd-mod.log.echo "${_msg}"

}


llvm-project-install.main "$@"
