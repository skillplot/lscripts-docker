#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _dir_ functions
###----------------------------------------------------------



function lsd-mod.dir.basepath.get__vars() {
  lsd-mod.log.echo "_LSD__COMMON: ${_LSD__COMMON}"
  lsd-mod.log.echo "_LSD__APPS: ${_LSD__APPS}"
  lsd-mod.log.echo "_LSD__LSCRIPTS: ${_LSD__LSCRIPTS}"
  lsd-mod.log.echo "_LSD__TFRECORDS: ${_LSD__TFRECORDS}"
  lsd-mod.log.echo "_LSD__WWW_LOGS: ${_LSD__WWW_LOGS}"
  lsd-mod.log.echo "_LSD__IS_TIMESTAMP_DATA_DIR: ${_LSD__IS_TIMESTAMP_DATA_DIR}"
  lsd-mod.log.echo "_LSD__BASENAME: ${_LSD__BASENAME}"
  lsd-mod.log.echo "_LSD__BASENAME_OS: ${_LSD__BASENAME_OS}"
  lsd-mod.log.echo "_LSD__ROOT: ${_LSD__ROOT}"
  lsd-mod.log.echo "_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"
  lsd-mod.log.echo "_LSD__HOME: ${_LSD__HOME}"
  lsd-mod.log.echo "_LSD__VM_ROOT: ${_LSD__VM_ROOT}"
  lsd-mod.log.echo "_LSD__OS_ROOT: ${_LSD__OS_ROOT}"
  lsd-mod.log.echo "_LSD__CONFIG_ROOT: ${_LSD__CONFIG_ROOT}"
  lsd-mod.log.echo "_LSD__DATA_ROOT: ${_LSD__DATA_ROOT}"
  lsd-mod.log.echo "_LSD__MOBILE_ROOT: ${_LSD__MOBILE_ROOT}"
  lsd-mod.log.echo "_LSD__VM_HOME: ${_LSD__VM_HOME}"
  lsd-mod.log.echo "_LSD__PYVENV_HOME: ${_LSD__PYVENV_HOME}"
  lsd-mod.log.echo "_LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
  lsd-mod.log.echo "_LSD__WSGIPYTHONPATH: ${_LSD__WSGIPYTHONPATH}"
  lsd-mod.log.echo "_LSD__WSGIPYTHONHOME: ${_LSD__WSGIPYTHONHOME}"
  lsd-mod.log.echo "_LSD__ANDROID_HOME: ${_LSD__ANDROID_HOME}"
  lsd-mod.log.echo "_LSD__APACHE_HOME: ${_LSD__APACHE_HOME}"
  lsd-mod.log.echo "_LSD__WWW_HOME: ${_LSD__WWW_HOME}"
  lsd-mod.log.echo "_LSD__DOWNLOADS_HOME: ${_LSD__DOWNLOADS_HOME}"
  lsd-mod.log.echo "_LSD__EXTERNAL_HOME: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.echo "_LSD__BIN_HOME: ${_LSD__BIN_HOME}"
  lsd-mod.log.echo "_LSD__CONFIG_HOME: ${_LSD__CONFIG_HOME}"
  lsd-mod.log.echo "_LSD__DATA_HOME: ${_LSD__DATA_HOME}"
  lsd-mod.log.echo "_LSD__LOGS_HOME: ${_LSD__LOGS_HOME}"
  lsd-mod.log.echo "_LSD__MOBILE_HOME: ${_LSD__MOBILE_HOME}"
  lsd-mod.log.echo "_LSD__TMP_HOME: ${_LSD__TMP_HOME}"
  lsd-mod.log.echo "_LSD__AID: ${_LSD__AID}"
  lsd-mod.log.echo "_LSD__ANT: ${_LSD__ANT}"
  lsd-mod.log.echo "_LSD__AUTH: ${_LSD__AUTH}"
  lsd-mod.log.echo "_LSD__ROS: ${_LSD__ROS}"
  lsd-mod.log.echo "_LSD__CFG: ${_LSD__CFG}"
  lsd-mod.log.echo "_LSD__CLOUD: ${_LSD__CLOUD}"
  lsd-mod.log.echo "_LSD__DATABASE: ${_LSD__DATABASE}"
  lsd-mod.log.echo "_LSD__DOCKER: ${_LSD__DOCKER}"
  lsd-mod.log.echo "_LSD__DOCS: ${_LSD__DOCS}"
  lsd-mod.log.echo "_LSD__DOWNLOADS: ${_LSD__DOWNLOADS}"
  lsd-mod.log.echo "_LSD__DIST: ${_LSD__DIST}"
  lsd-mod.log.echo "_LSD__EXTERNAL: ${_LSD__EXTERNAL}"
  lsd-mod.log.echo "_LSD__KBANK: ${_LSD__KBANK}"
  lsd-mod.log.echo "_LSD__LOGS: ${_LSD__LOGS}"
  lsd-mod.log.echo "_LSD__MOBILE: ${_LSD__MOBILE}"
  lsd-mod.log.echo "_LSD__NPM: ${_LSD__NPM}"
  lsd-mod.log.echo "_LSD__PIP: ${_LSD__PIP}"
  lsd-mod.log.echo "_LSD__PRACTICE: ${_LSD__PRACTICE}"
  lsd-mod.log.echo "_LSD__PUBLIC: ${_LSD__PUBLIC}"
  lsd-mod.log.echo "_LSD__PLUGINS: ${_LSD__PLUGINS}"
  lsd-mod.log.echo "_LSD__WWW: ${_LSD__WWW}"
  lsd-mod.log.echo "_LSD__RELEASE: ${_LSD__RELEASE}"
  lsd-mod.log.echo "_LSD__REPORTS: ${_LSD__REPORTS}"
  lsd-mod.log.echo "_LSD__RUBY: ${_LSD__RUBY}"
  lsd-mod.log.echo "_LSD__SAMPLES: ${_LSD__SAMPLES}"
  lsd-mod.log.echo "_LSD__SITE: ${_LSD__SITE}"
  lsd-mod.log.echo "_LSD__TOOLS: ${_LSD__TOOLS}"
  lsd-mod.log.echo "_LSD__UPLOADS: ${_LSD__UPLOADS}"
  lsd-mod.log.echo "_LSD__WORKSPACE: ${_LSD__WORKSPACE}"
  lsd-mod.log.echo "_LSD__3DMODELS: ${_LSD__3DMODELS}"
  lsd-mod.log.echo "_LSD__EBOOKSLIB: ${_LSD__EBOOKSLIB}"
  lsd-mod.log.echo "_LSD__PHOTOGRAMMETRY: ${_LSD__PHOTOGRAMMETRY}"
  lsd-mod.log.echo "_LSD__REF: ${_LSD__REF}"
  lsd-mod.log.echo "_LSD__SOFTWARES: ${_LSD__SOFTWARES}"
  lsd-mod.log.echo "_LSD__TEAM: ${_LSD__TEAM}"
  lsd-mod.log.echo "_LSD__TECHNOTES: ${_LSD__TECHNOTES}"
  lsd-mod.log.echo "_LSD__TECHNOTES_RESEARCH: ${_LSD__TECHNOTES_RESEARCH}"
  lsd-mod.log.echo "_LSD__DOCKER_HUB_REPO: ${_LSD__DOCKER_HUB_REPO}"
  lsd-mod.log.echo "_LSD__DOCKER_BASENAME: ${_LSD__DOCKER_BASENAME}"
  lsd-mod.log.echo "_LSD__DOCKER_ROOT: ${_LSD__DOCKER_ROOT}"
  lsd-mod.log.echo "_LSD__DOCKER_CONFIG_ROOT__: ${_LSD__DOCKER_CONFIG_ROOT__}"
  lsd-mod.log.echo "_LSD__DOCKER_DATA_ROOT: ${_LSD__DOCKER_DATA_ROOT}"
  lsd-mod.log.echo "_LSD__DOCKER_MOBILE_ROOT: ${_LSD__DOCKER_MOBILE_ROOT}"
  lsd-mod.log.echo "_LSD__DOCKER_OS_ROOT: ${_LSD__DOCKER_OS_ROOT}"
  lsd-mod.log.echo "_LSD__DOCKER_VM_ROOT: ${_LSD__DOCKER_VM_ROOT}"
  lsd-mod.log.echo "_LSD__DOCKER_VM_HOME: ${_LSD__DOCKER_VM_HOME}"
  lsd-mod.log.echo "_LSD__OS_USR_ROOT: ${_LSD__OS_USR_ROOT}"
  lsd-mod.log.echo "_LSD__OS_LIB: ${_LSD__OS_LIB}"
  lsd-mod.log.echo "_LSD__OS_SRC: ${_LSD__OS_SRC}"
  lsd-mod.log.echo "_LSD__OS_DOC: ${_LSD__OS_DOC}"
  lsd-mod.log.echo "_LSD__OS_LOCALE: ${_LSD__OS_LOCALE}"
  lsd-mod.log.echo "_LSD__OS_INCLUDE: ${_LSD__OS_INCLUDE}"
  lsd-mod.log.echo "_LSD__OS_USR_HOME: ${_LSD__OS_USR_HOME}"
  lsd-mod.log.echo "_LSD__OS_DEV: ${_LSD__OS_DEV}"
  lsd-mod.log.echo "_LSD__OS_MNT: ${_LSD__OS_MNT}"
  lsd-mod.log.echo "_LSD__OS_TMP: ${_LSD__OS_TMP}"
  lsd-mod.log.echo "_LSD__OS_BIN: ${_LSD__OS_BIN}"
  lsd-mod.log.echo "_LSD__OS_ETC: ${_LSD__OS_ETC}"
  lsd-mod.log.echo "_LSD__OS_SHARE: ${_LSD__OS_SHARE}"
  lsd-mod.log.echo "_LSD__OS_VAR: ${_LSD__OS_VAR}"
  lsd-mod.log.echo "_LSD__OS_LOGS: ${_LSD__OS_LOGS}"
  lsd-mod.log.echo "_LSD__OS_CACHE: ${_LSD__OS_CACHE}"
  lsd-mod.log.echo "_LSD__OS_CRASH: ${_LSD__OS_CRASH}"
  lsd-mod.log.echo "_LSD__OS_LOCK: ${_LSD__OS_LOCK}"
  lsd-mod.log.echo "_LSD__OS_SPOOL: ${_LSD__OS_SPOOL}"
  lsd-mod.log.echo "_LSD__OS_ALIAS_SH: ${_LSD__OS_ALIAS_SH}"
  lsd-mod.log.echo "_LSD__DATA_ALIAS_SH: ${_LSD__DATA_ALIAS_SH}"

  lsd-mod.log.echo "_LSD__ENVVARS: ${#_LSD__ENVVARS[@]}: ${_LSD__ENVVARS[@]}"
  lsd-mod.log.echo "_LSD__OS_DIRS: ${#_LSD__OS_DIRS[@]}: ${_LSD__OS_DIRS[@]}"
  lsd-mod.log.echo "_LSD__DATA_DIRS: ${#_LSD__DATA_DIRS[@]}: ${_LSD__DATA_DIRS[@]}"
  lsd-mod.log.echo "_LSD__ENVVARS: ${#_LSD__ENVVARS[@]}: ${_LSD__ENVVARS[@]}"
  lsd-mod.log.echo "_LSD__DATA_DIRS_PATHS: ${#_LSD__DATA_DIRS_PATHS[@]}: ${_LSD__DATA_DIRS_PATHS[@]}"
  lsd-mod.log.echo "_LSD__OS_DIRS_PATHS: ${#_LSD__OS_DIRS_PATHS[@]}: ${_LSD__OS_DIRS_PATHS[@]}"
}


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
