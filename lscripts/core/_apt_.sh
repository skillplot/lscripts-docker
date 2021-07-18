#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## apt utility functions
###----------------------------------------------------------


function lsd-mod.apt.get__vars() {
  lsd-mod.log.echo "Nothing here yet!"
}


function lsd-mod.apt.search() {
  local __error_msg="
  Usage:
    lsd-mod.apt.search <search-phrase>
  "
  local _str=${1? "${__error_msg}" }
  [[ "$#" -ne "1" ]] && lsd-mod.log.error "Invalid number of parameters: required 1 given $#\n ${__error_msg}"

  # local _str=$1
  lsd-mod.log.echo "Searching apt-cache for: ${_str}\n"

  local output=$(apt-cache search ${_str} | cut -d' ' -f1 | tr '\n' ' ')
  apt-cache policy ${output}
  echo "${output}"
}


function lsd-mod.apt.guess() {
  local __error_msg="
  Usage:
    lsd-mod.apt.guess <search-phrase>
  "
  local _str=${1? "${__error_msg}" }

  [[ "$#" -ne "1" ]] && lsd-mod.log.error "Invalid number of parameters: required 1 given $#\n ${__error_msg}"

  lsd-mod.log.echo "Searching apt-cache for: ${_str}"

  local __msg="Because...Installing blidfold is risky\n
    You can install it with the following command.\n

    We did the best guess, you can further look into all the\n
    packages available.\n
    lsd-apt.search <search-phrase>
    "
  lsd-mod.log.echo ${__msg}

  local output=$(lsd-mod.apt.search ${_str})
  output=$( echo "${output}" | grep -e"^${_str}" | tr ':\n' ' ' | tr -s ' ');
  lsd-mod.log.echo "${bgre}sudo apt -y install ${output}${nocolor}"
}


function lsd-mod.apt.get-repo() {
  local _type=${1:-'ls'}
  ## lsd-mod.log.debug "_type: ${_type}"
  local _aptfile
  local _entry
  local _user
  local _ppa
  for _aptfile in $(find /etc/apt/ -name \*.list); do
      grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" ${_aptfile} | while read _entry ; do
          _user=$(echo ${_entry} | cut -d/ -f4)
          _ppa=$(echo ${_entry} | cut -d/ -f5)
          [[ "${_type}" == "ls" ]] && echo "sudo apt-add-repository -y ppa:${_user}/${_ppa}"
          [[ "${_type}" == "rm" ]] && echo "sudo apt-add-repository --remove ppa:${_user}/${_ppa}"
      done
  done

}


function lsd-mod.apt.add-repo() {
  local __error_msg="
  Utility to add PPA repositories in your debian machine

  Usage:
    lsd-mod.apt.add-repo ppa:user/ppa-name
  "
  local _ppa=${1? "${__error_msg}" }
  [[ "$#" -ne "1" ]] && lsd-mod.log.error "Invalid number of parameters: required 1 given $#\n ${__error_msg}"

  local _nm=$(uname -a && date)
  local _name=$(echo ${_nm} | md5sum | cut -f1 -d" ")
  local _ppa_name=$(echo "${_ppa}" | cut -d":" -f2 -s)
  
  # local _name=$(echo $(uname -a && date) | md5sum | cut -f1 -d" ")

  lsd-mod.log.echo "_nm: ${_nm}"
  lsd-mod.log.echo "_name: ${_name}"
  lsd-mod.log.echo "_ppa_name: ${_ppa_name}"

  [[ ! -z "${_ppa_name}" ]] && {
    echo "deb http://ppa.launchpad.net/${_ppa_name}/ubuntu lucid main" >> /etc/apt/sources.list

    apt -y update >> /dev/null 2> /tmp/${_name}_apt_add_key.txt

    local _key=$(cat /tmp/${_name}_apt_add_key.txt | cut -d":" -f6 | cut -d" " -f3)

    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${_key}
    rm -rf /tmp/${_name}_apt_add_key.txt
  } || {
    lsd-mod.log.error "PPA name not found"
    lsd-mod.log.echo "Utility to add PPA repositories in your debian machine"
    lsd-mod.log.echo "ppa:user/ppa-name"
  }
}


function lsd-mod.apt.deprecated.add-repo() {
  local __error_msg="
  Usage:
    lsd-mod.apt.add-repo <url> <file>

  Example:
  lsd-mod.apt.add-repo 'deb https://qgis.org/debian' qgis3.list
  "
  local _url=${1? "${__error_msg}" }
  local _file=${2? "${__error_msg}" }

  [[ "$#" -ne "2" ]] && lsd-mod.log.error "Invalid number of parameters: required 2 given $#\n ${__error_msg}"

  lsd-mod.log.echo "_url: ${_url}"
  lsd-mod.log.echo "_file: ${_file}"
  lsd-mod.log.echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"

  ls -1 "/etc/apt/sources.list.d/${_file}" &>/dev/null && {
    sudo sh -c 'echo "${_url} ${LINUX_CODE_NAME} main" > /etc/apt/sources.list.d/"${_file}"'
  } || lsd-mod.log.error "File does not exists: /etc/apt/sources.list.d/${_file}"
}
