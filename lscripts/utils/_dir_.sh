#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _dir_ functions
###----------------------------------------------------------


function _dir_.get_lsd_data_dirs_paths() {
  declare -a _lsd__data_dirs=(${_LSD__DATA_DIRS[@]})
  local _lsd__data_dirs_path
  local i
  for i in ${!_lsd__data_dirs[*]}; do
    _lsd__data_dirs_path="${_LSD__DATA_ROOT}/${_lsd__data_dirs[$i]}"
    _LSD_DATA_DIR_PATHS[$i]="${_lsd__data_dirs_path}"
    ##
    # if [ ! -d ${_lsd__data_dirs_path} ]; then
    #   mkdir -p ${_lsd__data_dirs_path}
    #   # chown -R $(id -un):$(id -gn) ${_lsd__data_dirs_path}
    # fi
  done
  echo ${_LSD_DATA_DIR_PATHS[@]}
}


function _dir_.get_lsd_os_dirs_paths() {
  declare -a _lsd__os_dirs=(${_LSD__OS_DIRS[@]})
  local _lsd__os_dirs_path
  local i
  for i in ${!_lsd__os_dirs[*]}; do
    _lsd__os_dirs_path="${_LSD__OS_ROOT}/${_lsd__os_dirs[$i]}"
    _LSD_OS_DIRS_PATHS[$i]="${_lsd__os_dirs_path}"
  done
  echo ${_LSD_OS_DIRS_PATHS[@]}
}
