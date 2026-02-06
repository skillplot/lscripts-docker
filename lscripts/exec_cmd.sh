#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## execute functions from the lscripts framework as command
###----------------------------------------------------------
#
## References:
##  * https://stackoverflow.com/questions/1835943/how-to-determine-function-name-from-inside-a-function
##  * https://www.linux.com/news/debug-your-shell-scripts-bashdb/
##  * https://unix.stackexchange.com/questions/440816/how-can-i-install-bashdb-on-ubuntu-18-04
##  * https://unix.stackexchange.com/questions/19323/what-is-the-caller-command
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function __execute_lscripts_fn__() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  source ${LSCRIPTS}/core/argparse-v2.sh "$@"

  [[ "$#" -lt "1" ]] && lsd-mod.log.fail "Invalid number of paramerters: minimum required 1 parameter but given: $#"
  [[ -n "${args['cmd']+1}" ]] || lsd-mod.log.fail "Required paramerter missing (--cmd)!"
  
  # lsd-mod.log.debug "${FUNCNAME[0]}:: Total args: ${#args[@]}; Options: ${args[@]}"
  # lsd-mod.log.info "Total args: ${#args[@]}; Options: ${args[@]}"
  # lsd-mod.log.stacktrace "Total args: ${#args[@]}; Options: ${args[@]}"

  local __cmd__=${args['cmd']}
  # lsd-mod.log.debug "cmd: ${__cmd__}, Total param: $(("$#" - 1))"

  [[ "${__cmd__}" != ${FUNCNAME[0]} ]] && {
    [[ "$#" > "0" ]] && shift
    ${__cmd__} "$@"
  } || lsd-mod.log.error "Error in script execution or you tried invoking itself: ${FUNCNAME[0]}"
}


__execute_lscripts_fn__ "$@"
