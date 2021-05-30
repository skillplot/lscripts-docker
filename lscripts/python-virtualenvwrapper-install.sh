#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Python virtualenv virtualenvwrapper setup
###----------------------------------------------------------
#
## References:
## **How can we run 3 different python applications on 3 different python versions on same machine?**
## * http://rafiqnayan.blogspot.com/2018/03/deploy-python-application-with-gunicorn.html
## * Best illustration: virtualenv, virtualenvwrapper, supervisor
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}

function python-virtualenvwrapper-uninstall() {
  _log_.warn "python-virtualenvwrapper uninstallion not allowed through this script!"
  return -1
}


function __python-virtualenvwrapper-getconfig_file() {
  local __PY_VIRTUALENVWRAPPER
  _log_.debug "/usr/local/bin/${PY_VIRTUALENVWRAPPER}"
  {
    ls -1 "/usr/local/bin/${PY_VIRTUALENVWRAPPER}" &>/dev/null && __PY_VIRTUALENVWRAPPER="/usr/local/bin/${PY_VIRTUALENVWRAPPER}"
  } || {
    ls -1 "${HOME}/.local/bin/${PY_VIRTUALENVWRAPPER}" &>/dev/null && __PY_VIRTUALENVWRAPPER="${HOME}/.local/bin/${PY_VIRTUALENVWRAPPER}"
  }
  _log_.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"

  echo ${__PY_VIRTUALENVWRAPPER}
}


function python-virtualenvwrapper-test() {
  _log_.warn "Testing Usage and Installation: "

  local pyVer=$1
  local PYTHON
  local __PY_VIRTUALENVWRAPPER

  PYTHON=python${pyVer}

  local __pyVer=$(${PYTHON} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  local py_env_name="test_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  _log_.debug "Creating...py_env_name: ${py_env_name}"

  _log_.debug "PY_VENV_PATH: ${PY_VENV_PATH}"
  [[ -d ${PY_VENV_PATH} ]] || {
    _log_.info "PY_VENV_PATH Does not exists: ${PY_VENV_PATH}"

    local _que="Do you want to Create PY_VENV_PATH: ${PY_VENV_PATH}"
    local _msg="Skipping PY_VENV_PATH creation!"
    _fio_.yesno_yes "${_que}" && {
      _log_.echo "Creating PY_VENV_PATH..."
      mkdir -p ${PY_VENV_PATH}
    } || _log_.echo "${_msg}"
  }

  [[ -d ${PY_VENV_PATH} ]] && {
    export WORKON_HOME=${PY_VENV_PATH}
    __PY_VIRTUALENVWRAPPER=$(__python-virtualenvwrapper-getconfig_file)
    _log_.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
    source "${__PY_VIRTUALENVWRAPPER}"

    _log_.info "Creating py_env_name: ${py_env_name} folder inside: ${PY_VENV_PATH}"
    ## creates the my_project folder inside ${PY_VENV_PATH}
    mkvirtualenv -p $(which ${PYTHON}) ${py_env_name} &>/dev/null && {
      _log_.info "lsvirtualenv: ## List all of the environments."
      lsvirtualenv
    
      _log_.info "cdvirtualenv: ## Navigate into the directory of the currently activated virtual environment, so you can browse its site-packages."
      cdvirtualenv
    
      _log_.info "cdsitepackages: ## Like the above, but directly into site-packages directory."
      cdsitepackages
    
      _log_.info "lssitepackages: ## Shows contents of site-packages directory."
      lssitepackages
      #
      _log_.info "workon <py_env_name>: ## workon also deactivates whatever environment you are currently in, so you can quickly switch between environments."
      _log_.info "workon ${py_env_name}"
      workon ${py_env_name}
      ##
      _log_.info "deactivate: ## Deactivates whatever environment you are currently in."
      deactivate
      #
      ## Rename
      ## https://stackoverflow.com/questions/9540040/rename-an-environment-with-virtualenvwrapper
      _log_.info "cpvirtualenv <py_env_name> new_<py_env_name>: ## copy the virtualenv environment. Used as workaround for renaming."
      cpvirtualenv ${py_env_name} new_${py_env_name}
      deactivate
      rmvirtualenv ${py_env_name}
    
      ## Remove
      _log_.info "rmvirtualenv new_<py_env_name>: ## Removes the virtualenv environment."
      rmvirtualenv new_${py_env_name}
    } || _log_.error "python virtualenvwrapper is not installed / configured properly. check: WORKON_HOME: ${WORKON_HOME}"
  } || _log_.error "PY_VENV_PATH does not exists: ${PY_VENV_PATH}"
}


function python-virtualenvwrapper-create() {
  local pyVer=$1
  local PYTHON
  local __PY_VIRTUALENVWRAPPER

  PYTHON=python${pyVer}

  local __pyVer=$(${PYTHON} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  _log_.debug "Creating...py_env_name: ${py_env_name}"

  _log_.debug "PY_VENV_PATH: ${PY_VENV_PATH}"
  [[ -d ${PY_VENV_PATH} ]] || _log_.fail "Does not exists PY_VENV_PATH: ${PY_VENV_PATH}"

  export WORKON_HOME=${PY_VENV_PATH}
  __PY_VIRTUALENVWRAPPER=$(__python-virtualenvwrapper-getconfig_file)
  _log_.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
  source "${__PY_VIRTUALENVWRAPPER}"

  lsvirtualenv | grep ${py_env_name}
  [[ $? -eq 0 ]] || {
    _log_.warn "Creating: ${py_env_name} folder inside: ${PY_VENV_PATH}"
    mkvirtualenv -p $(which ${PYTHON}) ${py_env_name} &>/dev/null && workon ${py_env_name} || _log_.error "Internal _log_.error in mkvirtualenv!"
  }
}

function python-virtualenvwrapper-config() {
  [[ -f ${USER_BASHRC_FILE} ]] || _log_.fail "File does not exits,USER_BASHRC_FILE: ${USER_BASHRC_FILE}"

  local LINE
  LINE="export WORKON_HOME=${PY_VENV_PATH}"
  _fio_.inject_in_file --file="${USER_BASHRC_FILE}" --line="${LINE}"

  __PY_VIRTUALENVWRAPPER=$(__python-virtualenvwrapper-getconfig_file)
  _log_.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
  LINE="source ${__PY_VIRTUALENVWRAPPER}"
  _fio_.inject_in_file --file="${USER_BASHRC_FILE}" --line="${LINE}"

  source ${USER_BASHRC_FILE}
}

function __python-virtualenvwrapper-install() {
  [[ -f ${USER_BASHRC_FILE} ]] || _log_.fail "File does not exits,USER_BASHRC_FILE: ${USER_BASHRC_FILE}"

  local pyVer=$1
  local PYTHON

  PYTHON=python${pyVer}

  _log_.info "Installing virtualenv and virtualenvwrapper..."
  ${PYTHON} -m pip install setuptools wheel
  ${PYTHON} -m pip install virtualenv virtualenvwrapper

  ${PYTHON} -m virtualenv --version

  _log_.info "Creating VM_HOME: ${VM_HOME} and PY_VENV_PATH: ${PY_VENV_PATH}"

  [[ ! -z ${VM_HOME} ]] && sudo mkdir -p ${VM_HOME} &>/dev/null  || _log_.fail "Unable to create VM_HOME: ${VM_HOME}"

  [[ ! -z ${USR} ]] && [[ ! -z ${GRP} ]] && \
    sudo chown ${USR}:${GRP} ${VM_HOME} &>/dev/null || _log_.fail "Unable to set permission VM_HOME: ${VM_HOME}"
}

function python-virtualenvwrapper-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _prog="python-virtualenvwrapper"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  [[ ! -z $1 ]] && pyVer=$1 && _log_.info "pyVer: ${pyVer}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Installing..."
      __${_prog}-install ${pyVer}
  } || _log_.echo "${_msg}"

  _que="Configure ${_prog} now (recommended)"
  _msg="Skipping ${_prog} configuration. This is critical for proper ${_prog} working!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Configuring..."
      ${_prog}-config
    } || _log_.echo "${_msg}"

  _que="Test creation of python virtualenv now"
  _msg="Skipping testing!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Testing..."
      ${_prog}-test ${pyVer}
  } || _log_.echo "${_msg}"

  _que="Create python virtualenv now"
  _msg="Skipping python virtualenv creation!"
  _fio_.yesno_yes "${_que}" && {
    _log_.echo "Creating..."
    ${_prog}-create ${pyVer}
  } || _log_.echo "${_msg}"

}

python-virtualenvwrapper-install.main "$@"
