#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## lscripts-docker installation
## TODO:
## * if directory already exists handling
###----------------------------------------------------------


function lsd-mod.fio.yesno_no() {
  ## default is No
  local msg
  [[ $# -eq 0 ]] && msg="Are you sure" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}? \e[1;37m\e[1;31m[y/N]\e[1;33m>\e[0m ")
  [[ $(read -e -p "${msg}"; echo ${REPLY}) == [Yy]* ]] && return 0 || return -1
}


###----------------------------------------------------------

function lsd-mod.banner.skillplot() {

(>&2 echo -e "
###--------------------------------------------------------------------------

   ▄▄▄▄▄   █  █▀ ▄█ █    █    █ ▄▄  █    ████▄    ▄▄▄▄▀ 
  █     ▀▄ █▄█   ██ █    █    █   █ █    █   █ ▀▀▀ █    
▄  ▀▀▀▀▄   █▀▄   ██ █    █    █▀▀▀  █    █   █     █    
 ▀▄▄▄▄▀    █  █  ▐█ ███▄ ███▄ █     ███▄ ▀████    █    .org 
             █    ▐     ▀    ▀ █        ▀        ▀      
            ▀                   ▀                       
>>> LSCRIPTS      : $(date +"%H:%M:%S, %d-%b-%Y, %A")
>>> Documentation : https://lscripts.skillplot.org
>>> Code          : https://github.com/skillplot/lscripts-docker
")
}


function lsd-mod.install_package_apt() {
  ## Function to install a package using apt (Debian/Ubuntu)
  sudo apt -y update
  sudo apt -y install "$1"
}

## Function to check if the input is non-empty
function lsd-mod.is_non_empty() {
  [ -n "$1" ]
}

function lsd-mod.is_valid_email() {
  ## Function to validate the email format
  local email_regex="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
  [[ "$1" =~ $email_regex ]]
}


function lsd-mod.get_valid_input() {
  ## Function to get a valid input (non-empty and matching the specified data type)
  local prompt="$1"
  local validation_func="$2"
  local input=""
  
  while true; do
    read -p "$prompt: " input
    if $(lsd-mod.is_non_empty "$input" && $validation_func "$input"); then
      break
    fi
  done
  
  echo "$input"
}


function lsd-mod.setup() {
  local codehub="$1"
  local datahub="$2"

  export _LSD__CODEHUB_ROOT__="${codehub}"
  export _LSD__DATAHUB_ROOT__="${datahub}"
  export _LSD__AIMLHUB_ROOT__="${_LSD__CODEHUB_ROOT__}/aihub"

  echo "_LSD__CODEHUB_ROOT__:: ${_LSD__CODEHUB_ROOT__}"
  echo "_LSD__DATAHUB_ROOT__:: ${_LSD__DATAHUB_ROOT__}"
  echo "_LSD__AIMLHUB_ROOT__:: ${_LSD__AIMLHUB_ROOT__}"

  declare -a _lsd_lines=(
    'export __CODEHUB_ROOT__="'${_LSD__CODEHUB_ROOT__}'"'
    'export __DATAHUB_ROOT__="'${_LSD__DATAHUB_ROOT__}'"'
    'export __AIMLHUB_ROOT__="'${_LSD__CODEHUB_ROOT__}/aihub'"'
    'export __LSCRIPTS_DOCKER="${__CODEHUB_ROOT__}/external/lscripts-docker"'
    '[ -f ${__LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${__LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh'
  )

  local FILE="$HOME/.bashrc"
  local i
  for i in ${!_lsd_lines[*]}; do
    echo "[$i]: ${_lsd_lines[$i]}"
    grep -qF "${_lsd_lines[$i]}" "$FILE" || echo "${_lsd_lines[$i]}" >> "$FILE"
  done

  ## create and set ownership for the required directories
  sudo mkdir -p \
    ${_LSD__CODEHUB_ROOT__}/external \
    ${_LSD__CODEHUB_ROOT__}/aihub \
    ${_LSD__CODEHUB_ROOT__}/ailab
  sudo chown -R $(id -un):$(id -gn) ${_LSD__CODEHUB_ROOT__}

  sudo mkdir -p ${_LSD__DATAHUB_ROOT__}
  sudo chown -R $(id -un):$(id -gn) ${_LSD__DATAHUB_ROOT__}
}


function lsd-mod.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

  lsd-mod.banner.skillplot

  ## Create and configure base directories for installation

  ## Default values
  local codehub="/codehub"
  local datahub="/datahub"
  local aihub=""
  
  while getopts c:d: flag
  do
    case "${flag}" in
      c) codehub=${OPTARG};;
      d) datahub=${OPTARG};;
    esac
  done

  ## Get a valid codehub root with default value
  [ -z "${codehub}" ] && codehub=$(lsd-mod.get_valid_input "Enter codehub root absolute basepath (default: ${codehub})" "lsd-mod.is_non_empty") && [ -z "${codehub}" ] && codehub="/codehub"

  ## Get a valid datahub root with default value
  [ -z "${datahub}" ] && datahub=$(lsd-mod.get_valid_input "Enter datahub root absolute basepath (default: ${datahub})" "lsd-mod.is_non_empty") && [ -z "${datahub}" ] && datahub="/datahub"

  lsd-mod.setup "${codehub}" "${datahub}"
  (>&2 echo -e "lscripts-docker installation path: ${codehub}! and datahub path is: ${datahub}.
###--------------------------------------------------------------------------")

  ## Install git and clone the repo
  local _default=no
  local _que="Install git and clone lscripts-docker repo from: https://github.com/skillplot/lscripts-docker"
  local _cmd="git"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    echo "Installing..."
    (>&2 echo -e "Installing lscripts-docker... root access is required!")
    lsd-mod.install_package_apt ${_cmd}

    ## clone repo
    git -C ${codehub}/external clone https://github.com/skillplot/lscripts-docker.git

  }

}


lsd-mod.main "$@"
