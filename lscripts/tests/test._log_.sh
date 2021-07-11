#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test::shell script utils/_log_.sh module
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test._log_.case-1() {
  local ll
  ##local N=8
  local N=${#_logger_[@]}
  for ll in $(seq ${N} -1 1); do
    ## Enable the loglevel
    export _LSCRIPTS__LOG_LEVEL_=${ll}

    # (>&2 echo -e "_LSCRIPTS__LOG_LEVEL_: ${_LSCRIPTS__LOG_LEVEL_}")
    (>&2 echo -e "${on_pur}Logger Initialized with _LSCRIPTS__LOG_LEVEL_: ${_LSCRIPTS__LOG_LEVEL_} or ${_logger_[${_LSCRIPTS__LOG_LEVEL_}]}${nocolor}")

    sleep 0.5s
    _log_.stacktrace "stacktrace"
    sleep 0.5s
    _log_.debug "debug"
    sleep 0.5s
    _log_.success "success"
    sleep 0.5s
    _log_.ok "ok"
    sleep 0.5s
    _log_.info "info"
    sleep 0.5s
    _log_.warn "warn"
    sleep 0.5s
    _log_.error "error"
    sleep 0.5s
  done
}


function test._log_.case-2() {
  _log_.fail "fail"
  echo "## This line and anything below should printed or executed!"
  echo "I never get's to see the Helllllllllll!"
}


function test._log_.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  test._log_.case-1
  test._log_.case-2
}


test._log_.main
