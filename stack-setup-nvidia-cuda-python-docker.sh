#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install required softwares
###----------------------------------------------------------
#
## Todo:
##  - hard stop if minimum system requirements are not met
##  - Keep the install log
##  - save the user configurations key value pair
##  - save the specific software versions being installed
##  - dependency checks and sequencing of software being installed
#
## NOTE:
## - Ubuntu 180.4 LTS
## - Requires bash version 4+
## - `nvidia-container-runtime` for `Docker < 19.03`
## - `nvidia-container-toolkit` for `Docker 19.03+` => use this preferably
## - Nvidia Driver 440+
###----------------------------------------------------------


function stack-setup-nvidia-cuda-python-docker() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${LSCRIPTS}/lscripts/_common_.sh"

  declare -a _stack_install=(
    "nvidia-driver"
    "docker-ce"
    "docker-compose"
    "nvidia-container-toolkit"
    "python"
    "python-virtualenvwrapper"
    "cuda-stack"
  )

  declare -a _stack_verify=(
    "docker-compose"
    "docker-ce"
    "cuda-stack"
  )

  _log_.warn "Install ${FUNCNAME[0]}; sudo access is required!"
  _fio_.yesno_yes "Continue" && {
    local item
    for item in "${_stack_install[@]}";do
      _log_.info ${item}
      local _item_filepath="${LSCRIPTS}/lscripts/${item}-install.sh"

      _log_.echo "Checking for installer..." && \
      ls -1 "${_item_filepath}" 2>/dev/null && {
        _fio_.yesno_no "Install ${item}" && {
          _log_.ok "Executing installer... ${_item_filepath}" && \
          _log_.echo "Installing..."
          source "${_item_filepath}" || _log_.error "${_item_filepath}"
        } || _log_.echo "Skipping ${item} installation!"
      } || _log_.error "Installer not found: ${item}!"
    done
  } || _log_.echo "Skipping ${FUNCNAME[0]} installation!"
}

stack-setup-nvidia-cuda-python-docker
