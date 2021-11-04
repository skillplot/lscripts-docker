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


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }

function python-virtualenvwrapper-uninstall() {
  lsd-mod.log.warn "python-virtualenvwrapper uninstallion not allowed through this script!"
  # return -1
}


function python-virtualenvwrapper-test() {
  lsd-mod.log.warn "Testing Usage and Installation: "

  local pyVer=$1
  local PYTHON
  local __PY_VIRTUALENVWRAPPER

  PYTHON=python${pyVer}

  local __pyVer=$(${PYTHON} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  local py_env_name="test_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
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
    mkvirtualenv -p $(which ${PYTHON}) ${py_env_name} &>/dev/null && {
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


function python-virtualenvwrapper-create() {
  local pyVer=$1
  local PYTHON
  local __PY_VIRTUALENVWRAPPER

  PYTHON=python${pyVer}

  local __pyVer=$(${PYTHON} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
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
      mkvirtualenv -p $(which ${PYTHON}) ${py_env_name} &>/dev/null && workon ${py_env_name} || lsd-mod.log.error "Internal lsd-mod.log.error in mkvirtualenv!"
    }
  } 1>&2 || {
    lsd-mod.log.error "${_cmd} not installed or corrupted!"
    # return -1
  }
}


function __python-virtualenvwrapper-install() {
  [[ -f ${_LSD__BASHRC_FILE} ]] || lsd-mod.log.fail "File does not exits,_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"

  local pyVer=$1
  local PYTHON

  PYTHON=python${pyVer}

  lsd-mod.log.info "Installing virtualenv and virtualenvwrapper..."
  ${PYTHON} -m pip install setuptools wheel
  ${PYTHON} -m pip install virtualenv virtualenvwrapper

  ${PYTHON} -m virtualenv --version

  lsd-mod.log.info "Creating _LSD__VM_HOME: ${_LSD__VM_HOME} and _LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"

  [[ ! -z ${_LSD__VM_HOME} ]] && sudo mkdir -p ${_LSD__VM_HOME} &>/dev/null  || lsd-mod.log.fail "Unable to create _LSD__VM_HOME: ${_LSD__VM_HOME}"

  [[ ! -z ${USR} ]] && [[ ! -z ${GRP} ]] && \
    sudo chown ${USR}:${GRP} ${_LSD__VM_HOME} &>/dev/null || lsd-mod.log.fail "Unable to set permission _LSD__VM_HOME: ${_LSD__VM_HOME}"
}

function python-virtualenvwrapper-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="python-virtualenvwrapper"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  [[ ! -z $1 ]] && pyVer=$1 && lsd-mod.log.info "pyVer: ${pyVer}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Installing..."
      __${_prog}-install ${pyVer}
  } || lsd-mod.log.echo "${_msg}"

  _que="Configure ${_prog} now (recommended)"
  _msg="Skipping ${_prog} configuration. This is critical for proper ${_prog} working!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Configuring..."
      ${_prog}-config
    } || lsd-mod.log.echo "${_msg}"

  _que="Test creation of python virtualenv now"
  _msg="Skipping testing!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Testing..."
      ${_prog}-test ${pyVer}
  } || lsd-mod.log.echo "${_msg}"

  _que="Create python virtualenv now"
  _msg="Skipping python virtualenv creation!"
  lsd-mod.fio.yesno_yes "${_que}" && {
    lsd-mod.log.echo "Creating..."
    ${_prog}-create ${pyVer}
  } || lsd-mod.log.echo "${_msg}"

}

python-virtualenvwrapper-install.main "$@"
