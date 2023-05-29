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


function lsd-mod.python.list() {
  ls -1 /usr/bin/python[1-9].[1-9] && ls -1 /usr/local/bin/python[1-9].[1-9]
}


function lsd-mod.python.find_vers() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

  local version
  [[ -n "${args['version']+1}" ]] && version=${args['version']}

  [[ -z ${version} ]] && {
    local _versions=$(curl -s https://www.python.org/ftp/python/  | sed 's/^.*">//;s/<.*//' | sed 's/\///' | grep ^[1-9].[1-9])
    echo "${_versions}"
  } || {
    lsd-mod.log.echo "searching for version: ${version}"
    local _match=$(curl -s https://www.python.org/ftp/python/  | sed 's/^.*">//;s/<.*//' | sed 's/\///' | grep ^[1-9].[1-9] | grep ${version})
    [[ -z ${_match} ]] && echo "-1" || echo "${_match}"
  }
}


function lsd-mod.python.path() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local scriptname=$(basename ${BASH_SOURCE[0]})

  source ${LSCRIPTS}/argparse.sh "$@"

  local py=python3
  local pyPath

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.echo "py: ${py}"
  lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null
  echo "${pyPath}"
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


function lsd-mod.python.virtualenvwrapper.test() {
  lsd-mod.log.warn "Testing Usage and Installation: "

  local py=python3
  local pyPath
  local __PY_VIRTUALENVWRAPPER

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.echo "py: ${py}"
  lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null

  # pyPath=$(lsd-mod.python.path)
  lsd-mod.log.debug "Creating...pyPath: ${pyPath}"

  local __pyVer=$(${pyPath} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  local py_env_name="test_py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  lsd-mod.log.debug "Creating...py_env_name: ${py_env_name}"

  lsd-mod.log.debug "_LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
  [[ -d ${_LSD__PYVENV_PATH} ]] || {
    lsd-mod.log.info "_LSD__PYVENV_PATH Does not exists: ${_LSD__PYVENV_PATH}"

    local _que="Do you want to Create _LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
    local _msg="Skipping _LSD__PYVENV_PATH creation!"
    lsd-mod.fio.yesno_yes "${_que}" && {
      lsd-mod.log.echo "Creating _LSD__PYVENV_PATH..."
      mkdir -p ${_LSD__PYVENV_PATH}
    } || lsd-mod.log.echo "${_msg}"
  }

  [[ -d ${_LSD__PYVENV_PATH} ]] && {
    export WORKON_HOME=${_LSD__PYVENV_PATH}
    __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
    lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
    source "${__PY_VIRTUALENVWRAPPER}"

    lsd-mod.log.info "Creating py_env_name: ${py_env_name} folder inside: ${_LSD__PYVENV_PATH}"
    ## creates the my_project folder inside ${_LSD__PYVENV_PATH}
    mkvirtualenv -p $(which ${pyPath}) ${py_env_name} &>/dev/null && {
      lsd-mod.log.info "lsvirtualenv: ## List all of the environments."
      lsvirtualenv
    
      lsd-mod.log.info "cdvirtualenv: ## Navigate into the directory of the currently activated virtual environment, so you can browse its site-packages."
      cdvirtualenv
    
      lsd-mod.log.info "cdsitepackages: ## Like the above, but directly into site-packages directory."
      cdsitepackages
    
      lsd-mod.log.info "lssitepackages: ## Shows contents of site-packages directory."
      lssitepackages
      #
      lsd-mod.log.info "workon <py_env_name>: ## workon also deactivates whatever environment you are currently in, so you can quickly switch between environments."
      lsd-mod.log.info "workon ${py_env_name}"
      workon ${py_env_name}
      ##
      lsd-mod.log.info "deactivate: ## Deactivates whatever environment you are currently in."
      deactivate
      #
      ## Rename
      ## https://stackoverflow.com/questions/9540040/rename-an-environment-with-virtualenvwrapper
      lsd-mod.log.info "cpvirtualenv <py_env_name> new_<py_env_name>: ## copy the virtualenv environment. Used as workaround for renaming."
      cpvirtualenv ${py_env_name} new_${py_env_name}
      deactivate
      rmvirtualenv ${py_env_name}
    
      ## Remove
      lsd-mod.log.info "rmvirtualenv new_<py_env_name>: ## Removes the virtualenv environment."
      rmvirtualenv new_${py_env_name}
    } || lsd-mod.log.error "python virtualenvwrapper is not installed / configured properly. check: WORKON_HOME: ${WORKON_HOME}"
  } || lsd-mod.log.error "_LSD__PYVENV_PATH does not exists: ${_LSD__PYVENV_PATH}"
}


function lsd-mod.python.virtualenvwrapper.create() {
  local py=python3
  local pyPath
  local __PY_VIRTUALENVWRAPPER

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.echo "py: ${py}"
  lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null

  # pyPath=$(lsd-mod.python.path)
  lsd-mod.log.debug "Creating...pyPath: ${pyPath}"

  local __pyVer=$(${pyPath} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  # local _timestamp=$(lsd-mod.date.get__timestamp)
  # local _timestamp="$(date -d now +'%d%m%y_%H%M%S')"
  local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  lsd-mod.log.debug "Creating...py_env_name: ${py_env_name}"

  lsd-mod.log.debug "_LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
  [[ -d ${_LSD__PYVENV_PATH} ]] || lsd-mod.log.fail "Does not exists _LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"

  export WORKON_HOME=${_LSD__PYVENV_PATH}
  __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
  lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
  source "${__PY_VIRTUALENVWRAPPER}"

  local _cmd='lsvirtualenv'
  type ${_cmd} &>/dev/null && {
    lsvirtualenv | grep ${py_env_name}
    [[ $? -eq 0 ]] || {
      lsd-mod.log.warn "Creating: ${py_env_name} folder inside: ${_LSD__PYVENV_PATH}"
      mkvirtualenv -p $(which ${pyPath}) ${py_env_name} &>/dev/null && workon ${py_env_name} || lsd-mod.log.error "Internal lsd-mod.log.error in mkvirtualenv!"
    }
  } 1>&2 || {
    lsd-mod.log.error "${_cmd} not installed or corrupted!"
    # return -1
  }
}
