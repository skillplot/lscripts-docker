#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Create install scripts alias
###----------------------------------------------------------


function lscripts.install.itemwise() {
  local _item
  local _item_filepath
  for _item in "${_stack_install_itemwise[@]}";do
    # _log_.info ${_item}
    _item_filepath="${LSCRIPTS}/${_item}-install.sh"
    # _log_.echo "Checking for installer..." && \
    ls -1 "${_item_filepath}" &>/dev/null && {
      ## create alias
      alias lsd-install.${_item}="source ${_item_filepath} $@"
    } || _log_.error "Installer not found: ${_item}!"
  done

  ## For 'itemwise' stack:
  _item='itemwise'
  _item_filepath="${LSCRIPTS}/stack-setup-${_item}.sh"
  ls -1 "${_item_filepath}" &>/dev/null && {
    ## create alias
    alias lsd-stack.${_item}="source ${_item_filepath} $@"
  } || _log_.error "Installer not found: ${_item}!"
}


function lscripts.install.stack-setup() {
  local _item
  local _item_filepath
  for _item in "${_stack_install_items[@]}";do
    # _log_.info ${_item}
    _item_filepath="${LSCRIPTS}/stack-setup-${_item}.sh"
    # _log_.echo "Checking for installer..." && \
    ls -1 "${_item_filepath}" &>/dev/null && {
      ## create alias
      alias lsd-stack.${_item}="source ${_item_filepath} $@"
    } || _log_.error "Installer not found: ${_item}!"
  done

  ## For 'all' stack:
  _item='all'
  _item_filepath="${LSCRIPTS}/stack-setup-${_item}.sh"
  ls -1 "${_item_filepath}" &>/dev/null && {
    ## create alias
    alias lsd-stack.${_item}="source ${_item_filepath} $@"
  } || _log_.error "Installer not found: ${_item}!"
}


function lscripts.install.main() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${LSCRIPTS}/config/stack-cfg.sh"
  source "${LSCRIPTS}/_common_.sh"
  # _log_.warn "Create installer alias ${FUNCNAME[0]}!"

  lscripts.install.stack-setup
  lscripts.install.itemwise
}

lscripts.install.main
