#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


function python.venvname.generate.main() {
  local py=python3
  local pip=pip3

  if [ ! -z $1 ]; then
    py=python$1
    pip=pip$1
  fi

  local pyPath=$(which ${py})
  local pipPath=$(which ${pip})
  local pipVer=$(${pip} --version)
  # _log_.debug "pipPath: ${pipVer}"
  local __pyVer=$(${py} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  # _log_.debug "pyPath: ${__pyVer}"
  # local timestamp=$(date +%Y-%m-%d) ## $(date +%Y%m%d%H%M%S)
  # local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  # local py_env_name="py_"${__pyVer}"_"${timestamp}
  local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  # _log_.debug "py_env_name: ${py_env_name}"
  echo ${py_env_name}
}

python.venvname.generate.main $1
