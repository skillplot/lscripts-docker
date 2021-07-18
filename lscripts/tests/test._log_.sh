#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test::shell script core/lsd-mod.log.sh module
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test.lsd-mod.log.case-1() {
  local ll
  ##local N=8
  local N=${#_logger_[@]}
  for ll in $(seq ${N} -1 1); do
    ## Enable the loglevel
    export LSCRIPTS__LOG_LEVEL=${ll}

    # (>&2 echo -e "LSCRIPTS__LOG_LEVEL: ${LSCRIPTS__LOG_LEVEL}")
    (>&2 echo -e "${on_pur}Logger Initialized with LSCRIPTS__LOG_LEVEL: ${LSCRIPTS__LOG_LEVEL} or ${_logger_[${LSCRIPTS__LOG_LEVEL}]}${nocolor}")

    sleep 0.5s
    lsd-mod.log.stacktrace "stacktrace"
    sleep 0.5s
    lsd-mod.log.debug "debug"
    sleep 0.5s
    lsd-mod.log.success "success"
    sleep 0.5s
    lsd-mod.log.ok "ok"
    sleep 0.5s
    lsd-mod.log.info "info"
    sleep 0.5s
    lsd-mod.log.warn "warn"
    sleep 0.5s
    lsd-mod.log.error "error"
    sleep 0.5s
  done
}


function test.lsd-mod.log.case-2() {
  lsd-mod.log.fail "fail"
  echo "## This line and anything below should printed or executed!"
  echo "I never get's to see the Helllllllllll!"
}


function test.lsd-mod.log.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  test.lsd-mod.log.case-1
  test.lsd-mod.log.case-2
}


test.lsd-mod.log.main
