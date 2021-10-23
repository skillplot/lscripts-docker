#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Python utilities functions
###----------------------------------------------------------


function lsd-mod.python.virtualenvwrapper.getconfig_file() {
  local __PY_VIRTUALENVWRAPPER
  lsd-mod.log.debug "/usr/local/bin/${_LSD__PY_VIRTUALENVWRAPPER}"
  {
    ls -1 "/usr/local/bin/${_LSD__PY_VIRTUALENVWRAPPER}" &>/dev/null && __PY_VIRTUALENVWRAPPER="/usr/local/bin/${_LSD__PY_VIRTUALENVWRAPPER}"
  } || {
    ls -1 "${HOME}/.local/bin/${_LSD__PY_VIRTUALENVWRAPPER}" &>/dev/null && __PY_VIRTUALENVWRAPPER="${HOME}/.local/bin/${_LSD__PY_VIRTUALENVWRAPPER}"
  }
  lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"

  echo ${__PY_VIRTUALENVWRAPPER}
}


function lsd-mod.python.virtualenvwrapper.config() {
  ## Todo: not used and to be seen the utility of this function
  [[ -f ${_LSD__BASHRC_FILE} ]] || lsd-mod.log.fail "File does not exits,_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"

  local LINE
  LINE="export WORKON_HOME=${_LSD__PYVENV_PATH}"
  lsd-mod.fio.inject_in_file --file="${_LSD__BASHRC_FILE}" --line="${LINE}"

  __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
  lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
  LINE="source ${__PY_VIRTUALENVWRAPPER}"
  lsd-mod.fio.inject_in_file --file="${_LSD__BASHRC_FILE}" --line="${LINE}"

  source ${_LSD__BASHRC_FILE}
}


function lsd-mod.python.venv.name() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local scriptname=$(basename ${BASH_SOURCE[0]})

  source ${LSCRIPTS}/argparse.sh "$@"

  local py=python3
  local pyPath

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  # lsd-mod.log.echo "py: ${py}"
  # lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null && {
    ## this is the fullpath of the input python executable you want to use
    local __pyVer=$(${py} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
    local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  } 2>/dev/null
  echo "${py_env_name}"
}


function lsd-mod.python.venv.list() {
  ###----------------------------------------------------------
  ## List all the python vistual environment.
  ###----------------------------------------------------------
  [[ -d ${_LSD__PYVENV_PATH} ]] && {
    export WORKON_HOME=${_LSD__PYVENV_PATH}
    __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
    lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
    source "${__PY_VIRTUALENVWRAPPER}"

    local pyenv
    declare -a pyenvs=($(lsvirtualenv | tr -d [=]))

    lsd-mod.log.echo "${gre}Listing all of the python virtual environments:${nocolor}"
    lsd-mod.log.echo "${biyel}Total: ${#pyenvs[@]}${nocolor}"
    for pyenv in ${pyenvs[@]}; do echo -e "${gre}${pyenv}${nocolor}"; done 
  } || lsd-mod.log.error "_LSD__PYVENV_PATH does not exists: ${_LSD__PYVENV_PATH}"
}
