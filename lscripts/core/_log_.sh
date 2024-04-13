#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Loggers - inspired from python logging module
#
## References:
## * https://unix.stackexchange.com/questions/19323/what-is-the-caller-command
## * https://stackoverflow.com/a/17804850
#
## @Usage
## export LSCRIPTS__DEBUG=0 ## enable
## export LSCRIPTS__LOG_LEVEL=7 ## enable
## defaults to debugging mode
#
## Todo:
## * make the timestamp prefix optional
## * make `caller` optional; need to think if compelete script name is ok?
###----------------------------------------------------------


## do not set the lsd-mod.log.debug here, use environment variable, True=1; False=0
[[ ! -z ${LSCRIPTS__DEBUG} ]] || LSCRIPTS__DEBUG=1

## do not set the log level here, use environment variable
[[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] || LSCRIPTS__LOG_LEVEL=8

local __LSCRIPTS_START_TIME=$(date +%s)
declare -A _logger_=(
  [1]="CRITICAL"
  [2]="ERROR"
  [3]="WARNING"
  [4]="INFO"
  [5]="OK"
  [6]="SUCCESS"
  [7]="DEBUG"
  [8]="STACKTRACE"
)

# (>&2 echo -e "${on_ibla}Logger Initialized with LSCRIPTS__LOG_LEVEL: ${LSCRIPTS__LOG_LEVEL} or ${_logger_[${LSCRIPTS__LOG_LEVEL}]}${nocolor}")

### -------------------------------------------

function lsd-mod.log.echo() {
  (>&2 echo -e "${bred}$*${nocolor}")
}


function lsd-mod.log.epoch() {
  echo "$(date +%s)"
}


function lsd-mod.log.get_print_time_msg() {
  local END_TIME=$(lsd-mod.log.epoch)
  local ELAPSED_TIME=$(echo "${END_TIME} - ${__LSCRIPTS_START_TIME}" | bc -l)
  local MESSAGE="Took ${ELAPSED_TIME} seconds"
  echo "${MESSAGE}"
}


function lsd-mod.log.__print_delim() {
  echo '${ucya}============================${nocolor}'
}


function lsd-mod.log.__failure() {
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 1 ]] && \
    (>&2 echo -e "[${on_ired}FAIL    - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${on_ired}$*${nocolor}")
    # (>&2 echo -e "[${on_ired}FAIL    - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${on_ired}$*${nocolor}")
}


function lsd-mod.log.fail() {
  ## failure is critical lsd-mod.log.error and results script termination - hard stop
  type bc &>/dev/null && {
    # lsd-mod.log.__failure "$1\n$(lsd-mod.log.get_print_time_msg)"
    [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
      [[ ${LSCRIPTS__LOG_LEVEL} -ge 1 ]] && \
      (>&2 echo -e "[${on_ired}FAIL    - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${on_ired}$*${nocolor}\n$(lsd-mod.log.get_print_time_msg)")
  # } || lsd-mod.log.__failure "$1"
  } || {
    [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
      [[ ${LSCRIPTS__LOG_LEVEL} -ge 1 ]] && \
      (>&2 echo -e "[${on_ired}FAIL    - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${on_ired}$*${nocolor}")
  }
  exit -1
}


function lsd-mod.log.error() {
  ## lsd-mod.log.error is bearable lsd-mod.log.error and does not terminate the script execution
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 2 ]] && \
    (>&2 echo -e "[${bired}ERROR   - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bired}$*${nocolor}")
    # (>&2 echo -e "[${bired}ERROR   - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bired}$*${nocolor}")
}


function lsd-mod.log.warn() {
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 3 ]] && \
    (>&2 echo -e "[${biyel}WARNING - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${biyel}$*${nocolor}")
    # (>&2 echo -e "[${biyel}WARNING - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${biyel}$*${nocolor}")
}


function lsd-mod.log.info() {
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 4 ]] && \
    # ${FUNCNAME[0]}
    (>&2 echo -e "[${bblu}INFO    - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bblu}$*${nocolor}")
    # (>&2 echo -e "[${bblu}INFO    - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bblu}$*${nocolor}")
}


function lsd-mod.log.ok() {
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 5 ]] && \
    (>&2 echo -e "[${bgre}OK      - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bgre}$*${nocolor}")
    # (>&2 echo -e "[${bgre}OK      - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bgre}$*${nocolor}")
}


function lsd-mod.log.__successful() {
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 5 ]] && \
    (>&2 echo -e "[${gre}SUCCESS - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${gre}$*${nocolor}")
    # (>&2 echo -e "[${gre}SUCCESS - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${gre}$*${nocolor}")
}


function lsd-mod.log.success() {
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
    [[ ${LSCRIPTS__LOG_LEVEL} -ge 6 ]]\
     && lsd-mod.log.__successful "$1\n$(lsd-mod.log.get_print_time_msg)"
}


function lsd-mod.log.debug() {
  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
      [[ ${LSCRIPTS__LOG_LEVEL} -ge 7 ]] && \
      # (>&2 echo -e "[${bcya}DEBUG - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bcya}$*${nocolor}")
      (>&2 echo -e "[${bcya}DEBUG - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bcya}$*${nocolor}")
      # (>&2 echo -e "[${bcya}DEBUG - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bcya}$*${nocolor}")
  }
}


function lsd-mod.log.stacktrace() {
  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] && \
      [[ ${LSCRIPTS__LOG_LEVEL} -ge 8 ]] && \
      (>&2
        echo -e "${on_blu}[STACKTRACE   - $(date -d now)]:${nocolor}"
        local frame=0
        local _out=$(caller ${frame})
        while true; do
          _out=$(caller ${frame})
          [[ -z ${_out} ]] && break
          [[ ${frame} -eq 0 ]] && echo -e "${on_blu}Line# $(caller 0) ${nocolor}${igre}$*${nocolor}" \
            || echo -e "${on_blu}Line#${_out}${nocolor}"
          ((frame++));
        done
      )
  }
}
