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


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function stack-setup-nvidia_cuda_python_docker.main() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${LSCRIPTS}/_common_.sh"

  lsd-mod.log.warn "Install ${FUNCNAME[0]}; sudo access is required!"
  lsd-mod.fio.yesno_yes "Continue" && {
    local item
    for item in "${_stack_install_nvidia_cuda_python_docker[@]}";do
      lsd-mod.log.info ${item}
      local _item_filepath="${LSCRIPTS}/${item}-install.sh"

      lsd-mod.log.echo "Checking for installer..." && \
      ls -1 "${_item_filepath}" 2>/dev/null && {
        lsd-mod.fio.yesno_no "Install ${item}" && {
          lsd-mod.log.ok "Executing installer... ${_item_filepath}" && \
          lsd-mod.log.echo "Installing..."
          source ${_item_filepath} "$@"
        } || lsd-mod.log.echo "Skipping ${item} installation!"
      } || lsd-mod.log.error "Installer not found: ${item}!"
    done
  } || lsd-mod.log.echo "Skipping ${FUNCNAME[0]} installation!"
}

stack-setup-nvidia_cuda_python_docker.main "$@"
