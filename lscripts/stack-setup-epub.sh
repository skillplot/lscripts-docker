#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install epublishing Stack - TeX/LaTeX,pandoc,epub
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function stack-setup-epub.main() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${LSCRIPTS}/_common_.sh"

  lsd-mod.log.warn "Install ${FUNCNAME[0]}; sudo access is required!"
  lsd-mod.fio.yesno_no "Continue" && {
    local item
    for item in "${_stack_install_epub[@]}";do
      lsd-mod.log.info ${item}
      local _item_filepath="${LSCRIPTS}/${item}-install.sh"

      lsd-mod.log.echo "Checking for installer..." && \
      ls -1 "${_item_filepath}" 2>/dev/null && {
        lsd-mod.fio.yesno_no "Install ${item}" && {
          lsd-mod.log.ok "Executing installer... ${_item_filepath}" && \
          source ${_item_filepath} "$@"
        } || lsd-mod.log.echo "Skipping ${item} installation!"
      } || lsd-mod.log.error "Installer not found: ${item}!"
    done
  } || lsd-mod.log.echo "Skipping ${FUNCNAME[0]} installation!"
}

stack-setup-epub.main "$@"
