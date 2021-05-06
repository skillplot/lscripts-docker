#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


function get_py_virtualenv() {
  local py=python3
  local pip=pip3

  if [ ! -z $1 ]; then
    py=python$1
    pip=pip$1
  fi

  local py_virtualenv_name
  local pyVer
  local timestamp=$(date +%Y-%m-%d) ## $(date +%Y%m%d%H%M%S)
  local pyPath=$(which ${py})
  local pipPath=$(which ${pip})
  local pipVer=$(${pip} --version)
  # _log_.info "pyPath: ${pyVer}"
  # _log_.info "pipPath: ${pipVer}"
  pyVer=$(${py} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  # _log_.info "create_and_setup_py_env:py: ${py}; pip: ${pip}"
  py_virtualenv_name="py_"${pyVer}"_"${timestamp}
  # _log_.info "py_virtualenv_name: ${py_virtualenv_name}"
  echo ${py_virtualenv_name}
}

get_py_virtualenv $1
