#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _dir_ functions
###----------------------------------------------------------


function lsd-mod.dir.get-datadirs-paths() {
  declare -a _lsd__data_dirs=(${_LSD__DATA_DIRS[@]})
  local _lsd__data_dirs_path
  local i
  for i in ${!_lsd__data_dirs[*]}; do
    _lsd__data_dirs_path="${_LSD__DATA_ROOT}/${_lsd__data_dirs[$i]}"
    _LSD_DATA_DIR_PATHS[$i]="${_lsd__data_dirs_path}"
  done
  echo ${_LSD_DATA_DIR_PATHS[@]}
}


function lsd-mod.dir.get-osdirs-paths() {
  declare -a _lsd__os_dirs=(${_LSD__OS_DIRS[@]})
  local _lsd__os_dirs_path
  local i
  for i in ${!_lsd__os_dirs[*]}; do
    _lsd__os_dirs_path="${_LSD__OS_ROOT}/${_lsd__os_dirs[$i]}"
    _LSD_OS_DIRS_PATHS[$i]="${_lsd__os_dirs_path}"
  done
  echo ${_LSD_OS_DIRS_PATHS[@]}
}


function lsd-mod.dir.mkdir-datadirs() {
  declare -a _lsd_data_dirs_paths=($(lsd-mod.dir.get-datadirs-paths))
  local i
  for i in ${!_lsd_data_dirs_paths[*]}; do
    lsd-mod.log.echo "${gre}${_lsd_data_dirs_paths[$i]}"
    [[ ! -d ${_lsd__data_dirs_path} ]] && [[ ! -L ${_lsd__data_dirs_path} ]] && {
      echo "mkdir -p ${_lsd__data_dirs_path}"
      echo "chown -R $(id -un):$(id -gn) ${_lsd__data_dirs_path}"
    }
  done
}


function lsd-mod.dir.mkdir-osdirs() {
  declare -a _lsd_os_dirs_paths=($(lsd-mod.dir.get-osdirs-paths))
  local i
  for i in ${!_lsd_os_dirs_paths[*]}; do
    lsd-mod.log.echo "${_lsd_os_dirs_paths[$i]}"
    [[ ! -d ${_lsd_os_dirs_paths} ]] && [[ ! -L ${_lsd_os_dirs_paths} ]] && {
      echo "mkdir -p ${_lsd_os_dirs_paths}"
      echo "chown -R $(id -un):$(id -gn) ${_lsd_os_dirs_paths}"
    }
  done
}


function lsd-mod.dir.mkdir-lscripts() {
  lsd-mod.dir.mkdir-datadirs
  lsd-mod.dir.mkdir-osdirs
}
