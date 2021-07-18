#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## stack utility functions
###----------------------------------------------------------


function lsd-mod.stack.list() {
  ## References:
  ## * https://unix.stackexchange.com/a/625927
  ## * https://stackoverflow.com/questions/16553089/dynamic-variable-names-in-bash
  ## * http://mywiki.wooledge.org/BashFAQ/006
  ## * https://wiki.bash-hackers.org/syntax/arrays#indirection

  # ${1:+:} return 1

  # local error_msg="Usage: bash $0 <stack-name>"
  # : ${1? "${error_msg}" }

  local _name=$1
  [[ ! -z ${_name} ]] || _name="items"
  declare -n array="_stack_install_${_name}" 2>/dev/null && {
    lsd-mod.log.echo "\n${_name} ${gre}arrayname is ${red}${!array} ${gre}with total items to be installed: ${red}${#array[@]} in the given order."
    lsd-mod.log.echo "${gre}During installation it will prompt for Yes[Y] or No[N] before continuing the installation."
    lsd-mod.log.echo "${gre}sudo access would be required for any installation.\n"
    # lsd-mod.log.info "$1:: ${array[@]}"
    # lsd-mod.log.info "$1:: ${!array[@]}"

    local item
    for item in "${!array[@]}";do
      lsd-mod.log.echo "[${item}]: ${array[${item}]}"
      # lsd-mod.log.echo "[${item}]: ${!array[${item}]}"
      # local _item_filepath="${LSCRIPTS}/stack-setup-${item}.sh"
      # # lsd-mod.log.echo "Checking for installer..." && \
      # ls -1 "${_item_filepath}" &>/dev/null && {
      #   ## create alias
      #   alias lsd-stack.${item}="source ${_item_filepath} || lsd-mod.log.error ${_item_filepath}"
      # } || lsd-mod.log.error "Installer not found: ${item}!"
    done
    lsd-mod.log.echo "\n${gre}You can get more details by executing command:\n${bred}lsd-stack.list <name_of_the_item>\n"


  } || lsd-mod.log.info "${_name} is either invalid value. Or, it's directly installable, ${red}refer: lsd-install.${_name}"
}

