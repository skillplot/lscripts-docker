#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## lscripts configuration debugger
###----------------------------------------------------------
#
## References:
## * https://codeburst.io/linux-environment-variables-53cea0245dc9
## * https://www.linuxtechi.com/variables-in-shell-scripting/
## * https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
## * https://askubuntu.com/questions/275965/how-to-list-all-variables-names-and-their-current-values
## * https://unix.stackexchange.com/questions/176001/how-can-i-list-all-shell-variables
## * https://stackoverflow.com/questions/1305237/how-to-list-variables-declared-in-script-in-bash
## * https://stackoverflow.com/questions/511694/Get-list-of-variables-whose-name-matches-a-certain-pattern
###----------------------------------------------------------


function _debug_.main() {
  local sourced
  # [[ $_ != $0 ]] && echo "Script is being sourced" || echo "Script is a subshell"
  [[ "${BASH_SOURCE[0]}" != "${0}" ]] && (>&2 echo -e "script ${BASH_SOURCE[0]} is being sourced ...") || (>&2 echo -e "Script is a subshell")
  [[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0


  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  lsd-mod.log.info "BASEDIR is: ${_LSD__HOME}"
  lsd-mod.log.info "_LSD__DOCKER_DATA_ROOT is: ${_LSD__DOCKER_DATA_ROOT}"
  lsd-mod.log.info "_LSD__DOCKER_MOBILE_ROOT is: ${_LSD__DOCKER_MOBILE_ROOT}"
  lsd-mod.log.info "DOCKER_ROOT_BASEDIR is: ${DOCKER_ROOT_BASEDIR}"

  [[ ! -f ${CUDACFG_FILEPATH} ]] || lsd-mod.log.ok "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"
  [[ ! -f ${AI_PYCUDA_FILE} ]] || lsd-mod.log.ok "AI_PYCUDA_FILE: ${AI_PYCUDA_FILE}"

  lsd-mod.log.info "USER_BASHRC_FILE: ${USER_BASHRC_FILE}"
  ## Un-comment for testing 
  lsd-mod.fio.debug_logger


  # declare -p
  # # ( set -o posix ; set ) | less
  # ( set -o posix ; set )
  # compgen -v

  # eval "printf '%q\n' $(printf ' "${!%s@}"' _ {a..z} {A..Z})"

  # compgen -v | while read line; do echo $line=${!line};done  

  # echo "$(compgen -A variable | grep CUD)"

  # declare -a all_vars=( $(compgen -v) )
  # lsd-mod.log.info "all_vars: ${all_vars[@]}"
  # lsd-mod.log.info "Total all_vars: ${#all_vars[@]}"
}

_debug_.main


