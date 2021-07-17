#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## apt utility functions
###----------------------------------------------------------


function _apt_.get__vars() {
  _log_.echo "Nothing here yet!"
}


function _apt_.search() {
  local __error_msg="
  Usage:
    _apt_.search <search-phrase>
  "
  local _str=${1? "${__error_msg}" }
  [[ "$#" -ne "1" ]] && _log_.error "Invalid number of parameters: required 1 given $#\n ${__error_msg}"

  # local _str=$1
  _log_.echo "Searching apt-cache for: ${_str}\n"

  local output=$(apt-cache search ${_str} | cut -d' ' -f1 | tr '\n' ' ')
  apt-cache policy ${output}
  echo "${output}"
}


function _apt_.guess() {
  local __error_msg="
  Usage:
    _apt_.guess <search-phrase>
  "
  local _str=${1? "${__error_msg}" }

  [[ "$#" -ne "1" ]] && _log_.error "Invalid number of parameters: required 1 given $#\n ${__error_msg}"

  _log_.echo "Searching apt-cache for: ${_str}"

  local __msg="Because...Installing blidfold is risky\n
    You can install it with the following command.\n

    We did the best guess, you can further look into all the\n
    packages available.\n
    lsd-apt.search <search-phrase>
    "
  _log_.echo ${__msg}

  local output=$(_apt_.search ${_str})
  output=$( echo "${output}" | grep -e"^${_str}" | tr ':\n' ' ' | tr -s ' ');
  _log_.echo "${bgre}sudo apt -y install ${output}${nocolor}"
}


function _apt_.add-repo() {
  local __error_msg="
  Usage:
    _apt_.add-repo <url> <file>

  Example:
  _apt_.add-repo 'deb https://qgis.org/debian' qgis3.list
  "
  local _url=${1? "${__error_msg}" }
  local _file=${2? "${__error_msg}" }

  [[ "$#" -ne "2" ]] && _log_.error "Invalid number of parameters: required 2 given $#\n ${__error_msg}"

  _log_.echo "_url: ${_url}"
  _log_.echo "_file: ${_file}"
  _log_.echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"

  ls -1 "/etc/apt/sources.list.d/${_file}" &>/dev/null && {
    sudo sh -c 'echo "${_url} ${LINUX_CODE_NAME} main" > /etc/apt/sources.list.d/"${_file}"'
  } || _log_.error "File does not exists: /etc/apt/sources.list.d/${_file}"
}
