#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## lscripts.api
###----------------------------------------------------------


function lscripts.api.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local scriptname=$(basename ${BASH_SOURCE[0]})
  source ${LSCRIPTS}/lscripts.config.sh

  source ${LSCRIPTS}/core/argparse.sh "$@"

  lsd-mod.log.debug "executing script...: ${scriptname}"
  lsd-mod.log.echo "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"
  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] || lsd-mod.log.debug "Key does not exists: ${key}"
  done
  
  lsd-mod.log.debug "${FUNCNAME[0]}:: Total args: ${#args[@]}; Options: ${args[@]}"
  lsd-mod.log.info "Total args: ${#args[@]}; Options: ${args[@]}"

  local __key
  for __key in "${_LSD__PARAMS[@]}"; do
    [[ -n "${args[${__key}]+1}" ]] && {
      local __val=\""${args[${__key}]}"\"
      __param=_LSD__$(echo ${__key}| tr '[a-z]' '[A-Z]')
      __val=$(echo ${__val} | tr -d \")
      [[ ! -z ${__val} ]] && {
        lsd-mod.log.echo "_LSD__DEFAULTS::${_LSD__DEFAULTS[${__param}]} => ${bgre}${__val}"

        _LSD__DEFAULTS[${__param}]=${__val}
      }
    }
  done
}
