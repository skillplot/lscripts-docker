#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Ceres Solver is an open source C++ library for modeling and solving large, complicated optimization problems.
## It can be used to solve Non-linear Least Squares problems with bounds constraints and general unconstrained
## optimization problems. It is a mature, feature rich, and performant library that has been used in production at Google since 2010
## - A Nonlinear Least Squares Minimizer
###----------------------------------------------------------
#
## References:
## * http://ceres-solver.org/
## * http://ceres-solver.org/installation.html#linux
## * https://ceres-solver.googlesource.com/ceres-solver
#
## Dependencies
# If you have followed the Software Installation Sequence
# all dependencies would already be installed, if not it will
# be installed by this script
#
###----------------------------------------------------------
# # CMake
# sudo apt install cmake
# # google-glog + gflags
# sudo apt install libgoogle-glog-dev
# # BLAS & LAPACK
# sudo apt install libatlas-base-dev
# # Eigen3
# sudo apt install libeigen3-dev
# # SuiteSparse and CXSparse (optional)
# # - If you want to build Ceres as a *static* library (the default)
# #   you can use the SuiteSparse package in the main Ubuntu package
# #   repository:
# sudo apt install libsuitesparse-dev
# # - However, if you want to build Ceres as a *shared* library, you must
# #   add the following PPA:
# sudo add-apt-repository ppa:bzindovic/suitesparse-bugfix-1319687
# sudo apt update
# sudo apt install libsuitesparse-dev
###----------------------------------------------------------

## Check for the required dependencies, install if required
# apt-cache policy libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
# apt-cache policy libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev | grep -i Installed | rev | cut -d' ' -f1 | rev
# apt-cache policy libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev | grep -i Candidate | rev | cut -d' ' -f1 | rev


function __ceres_solver-pre_requisite() {
  ## Todo: check if exists and if not, then install them
  sudo apt -y install libsuitesparse-dev
}


function __ceres_solver-build() {
  # local CERES_SOLVER_REL=""
  # local CERES_SOLVER_REL="-1.10.0"
  # local CERES_SOLVER_REL="-1.14.0"
  local DIR="ceres-solver"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}${CERES_SOLVER_REL}"

  local URL="https://ceres-solver.googlesource.com/${DIR}"

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
  git checkout ${CERES_SOLVER_REL}_TAG

  [[ -d ${PROG_DIR}/build ]] && rm -rf ${PROG_DIR}/build

  mkdir ${PROG_DIR}/build
  ## https://github.com/alicevision/AliceVisionDependencies/blob/master/ci/install-ceres.sh
  ## http://faculty.cse.tamu.edu/davis/suitesparse.html

  cd ${PROG_DIR}/build

  cmake -DCMAKE_C_FLAGS=-fPIC \
        -DCMAKE_CXX_FLAGS="-fPIC -I/usr/local/include -DEIGEN_DONT_ALIGN_STATICALLY=1 -DEIGEN_DONT_VECTORIZE=1" \
        -DCMAKE_EXE_LINKER_FLAGS=-L/usr/local/lib \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local ..

  ## not required
  # ccmake ..

  make -j${NUMTHREADS}

  [[ $? -eq 0 ]] && {
    lsd-mod.log.info "Installing..."
    sudo make install -j${NUMTHREADS}
  } || lsd-mod.log.error "Build failed"

  cd -
}


function ceres_solver-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="ceres_solver"

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

ceres_solver-install "$@"
