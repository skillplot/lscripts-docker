#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Execute and install lscripts-docker (lsd) toolkit and utilities
###----------------------------------------------------------


function lsd-mod.lscripts.exe.install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  lsd-mod.log.echo "HUSER (ID):HUSER_GRP (ID)::${HUSER}(${HUSER_ID}):${HUSER_GRP}(${HUSER_GRP_ID})"
  lsd-mod.log.echo "AUSER:AUSER_GRP::${AUSER}:${AUSER_GRP}"
  local _default=no
  local _que
  local _msg

  _que="Do you want to create user"
  _msg="Skipping creating user!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating No-login User: ${AUSER} and Group: ${AUSER_GRP}"
    lsd-system.admin.create-nologin-user --user=${AUSER} --group=${AUSER_GRP}
  } || lsd-mod.log.echo "${_msg}"

  _que="Do you want to create LSD-OS directories"
  _msg="Skipping creating LSD-OS directories!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating LSD-OS directories"
    ## create OS DIRS
    local _lsd__os_root=$(lsd-dir.admin.mkdir-osdirs)
    lsd-mod.log.echo "_lsd__os_root: ${_lsd__os_root}"
    ls -ltr ${_lsd__os_root} 2>/dev/null
  } || lsd-mod.log.echo "${_msg}"

  _que="Do you want to create LSD-Data directories"
  _msg="Skipping creating LSD-Data directories!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating LSD-Data directories"
    ## create Data DIRS
    local _lsd__data_root=$(lsd-dir.admin.mkdir-datadirs)
    lsd-mod.log.echo "_lsd__data_root: ${_lsd__data_root}"
    ls -ltr ${_lsd__data_root} 2>/dev/null
  } || lsd-mod.log.echo "${_msg}"
}


function lsd-mod.lscripts.exe.main() {
  ## create OS Alias
  local _lsd__os_alias_sh=$(lsd-dir.admin.mkalias-osdirs)
  # lsd-mod.log.echo "_lsd__os_alias_sh: ${_lsd__os_alias_sh}"
  [[ -f ${_lsd__os_alias_sh} ]] && source "${_lsd__os_alias_sh}"
  ###----------------------------------------------------------
  ## create Data Alias
  local _lsd__data_alias_sh=$(lsd-dir.admin.mkalias-datadirs)
  # lsd-mod.log.echo "_lsd__data_alias_sh: ${_lsd__data_alias_sh}"
  [[ -f ${_lsd__data_alias_sh} ]] && source "${_lsd__data_alias_sh}"
  ###----------------------------------------------------------
}
