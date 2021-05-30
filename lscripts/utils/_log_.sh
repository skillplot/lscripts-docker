#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Loggers - inspired from python logging module
#
## References:
## * https://unix.stackexchange.com/questions/19323/what-is-the-caller-command
## * https://stackoverflow.com/a/17804850
#
## @Usage
## export _LSCRIPTS__LOG_LEVEL_=7 ## enable
## defaults to debugging mode
#
## Todo:
## * make the timestamp prefix optional
## * make `caller` optional; need to think if compelete script name is ok?
###----------------------------------------------------------


## do not set the _log_.debug here, use environment variable, True=1; False=0
[[ ! -z ${_LSCRIPTS__DEBUG_} ]] || _LSCRIPTS__DEBUG_=1

## do not set the log level here, use environment variable
[[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] || _LSCRIPTS__LOG_LEVEL_=8

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

# (>&2 echo -e "${on_ibla}Logger Initialized with _LSCRIPTS__LOG_LEVEL_: ${_LSCRIPTS__LOG_LEVEL_} or ${_logger_[${_LSCRIPTS__LOG_LEVEL_}]}${nocolor}")

### -------------------------------------------

function _log_.echo() {
  (>&2 echo -e "${bred}$*${nocolor}")
}

function _log_.epoch() {
  echo "$(date +%s)"
}

function _log_.get_print_time_msg() {
  local END_TIME=$(_log_.epoch)
  local ELAPSED_TIME=$(echo "${END_TIME} - ${__LSCRIPTS_START_TIME}" | bc -l)
  local MESSAGE="Took ${ELAPSED_TIME} seconds"
  echo "${MESSAGE}"
}

function _log_.__print_delim() {
  echo '${ucya}============================${nocolor}'
}

function _log_.__failure() {
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 1 ]] && \
    (>&2 echo -e "[${on_ired}FAIL    - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${on_ired}$*${nocolor}")
    # (>&2 echo -e "[${on_ired}FAIL    - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${on_ired}$*${nocolor}")
}

function _log_.fail() {
  ## failure is critical _log_.error and results script termination - hard stop
  type bc &>/dev/null && {
    _log_.__failure "$1\n$(_log_.get_print_time_msg)"
  } || _log_.__failure "$1"
  exit -1
}

function _log_.error() {
  ## _log_.error is bearable _log_.error and does not terminate the script execution
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 2 ]] && \
    (>&2 echo -e "[${bired}ERROR   - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bired}$*${nocolor}")
    # (>&2 echo -e "[${bired}ERROR   - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bired}$*${nocolor}")
}

function _log_.warn() {
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 3 ]] && \
    (>&2 echo -e "[${biyel}WARNING - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${biyel}$*${nocolor}")
    # (>&2 echo -e "[${biyel}WARNING - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${biyel}$*${nocolor}")
}

function _log_.info() {
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 4 ]] && \
    # ${FUNCNAME[0]}
    (>&2 echo -e "[${bblu}INFO    - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bblu}$*${nocolor}")
    # (>&2 echo -e "[${bblu}INFO    - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bblu}$*${nocolor}")
}

function _log_.ok() {
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 5 ]] && \
    (>&2 echo -e "[${bgre}OK      - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bgre}$*${nocolor}")
    # (>&2 echo -e "[${bgre}OK      - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bgre}$*${nocolor}")
}

function _log_.__successful() {
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 5 ]] && \
    (>&2 echo -e "[${gre}SUCCESS - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${gre}$*${nocolor}")
    # (>&2 echo -e "[${gre}SUCCESS - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${gre}$*${nocolor}")
}

function _log_.success() {
  [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
    [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 6 ]]\
     && _log_.__successful "$1\n$(_log_.get_print_time_msg)"
}

function _log_.debug() {
  [[ ${_LSCRIPTS__DEBUG_} -eq 0 ]] || {
    [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
      [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 7 ]] && \
      # (>&2 echo -e "[${bcya}DEBUG - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bcya}$*${nocolor}")
      (>&2 echo -e "[${bcya}DEBUG - $(date -d now)${nocolor}]:${bwhi}[Line# ${BASH_LINENO}]:${nocolor}${bcya}$*${nocolor}")
      # (>&2 echo -e "[${bcya}DEBUG - $(date -d now)${nocolor}]:${bwhi}Line# $(caller 0) => ${nocolor}${bcya}$*${nocolor}")
  }
}

function _log_.stacktrace() {
  [[ ${_LSCRIPTS__DEBUG_} -eq 0 ]] || {
    [[ ! -z ${_LSCRIPTS__LOG_LEVEL_} ]] && \
      [[ ${_LSCRIPTS__LOG_LEVEL_} -ge 8 ]] && \
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
