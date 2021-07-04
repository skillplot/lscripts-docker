#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Lscripts software stack
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function stack-setup-all.main() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${LSCRIPTS}/_common_.sh"
  source "${LSCRIPTS}/config/stack-cfg.sh"

  _log_.warn "Install ${FUNCNAME[0]}; sudo access is required!"
  _fio_.yesno_yes "Continue" && {
      _log_.echo "${_stack_install_items[@]}"
      local item
      for item in "${_stack_install_items[@]}";do
        _log_.info ${item}
        local _item_filepath="${LSCRIPTS}/stack-setup-${item}.sh"

        _log_.echo "Checking for installer..." && \
        ls -1 "${_item_filepath}" 2>/dev/null && {
          _fio_.yesno_no "Install ${item}" && {
            _log_.ok "Executing installer... ${_item_filepath}" && \
            _log_.echo "Installing..."
            source ${_item_filepath} "$@"
          } || _log_.echo "Skipping ${item} installation!"
        } || _log_.error "Installer not found: ${item}!"
      done
    } || _log_.echo "Skipping ${FUNCNAME[0]} installation!"
}

stack-setup-all.main "$@"
