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
    _LSD__DATA_DIR_PATHS[$i]="${_lsd__data_dirs_path}"
  done
  echo ${_LSD__DATA_DIR_PATHS[@]}
}


function lsd-mod.dir.get-osdirs-paths() {
  declare -a _lsd__os_dirs=(${_LSD__OS_DIRS[@]})
  local _lsd__os_dirs_path
  local i
  for i in ${!_lsd__os_dirs[*]}; do
    _lsd__os_dirs_path="${_LSD__OS_ROOT}/${_lsd__os_dirs[$i]}"
    # lsd-mod.log.echo "_lsd__os_dirs_path: ${_lsd__os_dirs_path}"
    _LSD__OS_DIRS_PATHS[$i]="${_lsd__os_dirs_path}"
  done
  echo ${_LSD__OS_DIRS_PATHS[@]}
}


function lsd-mod.dir.admin.mkdir-datadirs() {
  declare -a _lsd__data_dir_paths=($(lsd-mod.dir.get-datadirs-paths))
  local i
  for i in ${!_lsd__data_dir_paths[*]}; do
    lsd-mod.log.echo "${gre}${_lsd__data_dir_paths[$i]}"
    [[ ! -d ${_lsd__data_dir_paths[$i]} ]] && [[ ! -L ${_lsd__data_dir_paths[$i]} ]] && {
      mkdir -p ${_lsd__data_dir_paths[$i]}
      chown -R $(id -un):$(id -gn) ${_lsd__data_dir_paths[$i]}
    }
  done
  echo "${_LSD__DATA_ROOT}"
}


function lsd-mod.dir.admin.mkdir-osdirs() {
  declare -a _lsd__os_dirs_paths=($(lsd-mod.dir.get-osdirs-paths))
  local i
  for i in ${!_lsd__os_dirs_paths[*]}; do
    lsd-mod.log.echo "${_lsd__os_dirs_paths[$i]}"
    [[ ! -d ${_lsd__os_dirs_paths[$i]} ]] && [[ ! -L ${_lsd__os_dirs_paths[$i]} ]] && {
      mkdir -p ${_lsd__os_dirs_paths[$i]}
      chown -R $(id -un):$(id -gn) ${_lsd__os_dirs_paths[$i]}
    }
  done
  echo "${_LSD__OS_ROOT}"
}


function lsd-mod.dir.admin.mkalias-datadirs() {
  declare -a _lsd__data_dir_paths=($(lsd-mod.dir.get-datadirs-paths))
  local _lsd__data_dir_path
  # lsd-mod.log.echo "_LSD__DATA_ALIAS_SH: ${_LSD__DATA_ALIAS_SH}"
  # lsd-mod.log.echo "_lsd__data_dir_paths: ${#_lsd__data_dir_paths[@]}"
  rm -f ${_LSD__DATA_ALIAS_SH}
  for _lsd__data_dir_path in ${_lsd__data_dir_paths[@]}; do
    # lsd-mod.log.echo "${_lsd__data_dir_path}"
    [[ -d ${_lsd__data_dir_path} ]] && {
      echo "alias lsdata__$(basename ${_lsd__data_dir_path})='"cd ${_lsd__data_dir_path}"'" >> ${_LSD__DATA_ALIAS_SH}
    }
  done
  echo ${_LSD__DATA_ALIAS_SH}
}


function lsd-mod.dir.admin.mkalias-osdirs() {
  declare -a _lsd__os_dirs_paths=($(lsd-mod.dir.get-osdirs-paths))
  local _lsd__os_dirs_path
  # lsd-mod.log.echo "_LSD__OS_ALIAS_SH: ${_LSD__OS_ALIAS_SH}"
  # lsd-mod.log.echo "_lsd__os_dirs_paths: ${#_lsd__os_dirs_paths[@]}"
  rm -f ${_LSD__OS_ALIAS_SH}
  for _lsd__os_dirs_path in ${_lsd__os_dirs_paths[@]}; do
    # lsd-mod.log.echo "${_lsd__os_dirs_path}"
    [[ -d ${_lsd__os_dirs_path} ]] && {
      echo "alias lsdos__$(basename ${_lsd__os_dirs_path})='"cd ${_lsd__os_dirs_path}"'" >> ${_LSD__OS_ALIAS_SH}
    }
  done
  echo ${_LSD__OS_ALIAS_SH}
}
