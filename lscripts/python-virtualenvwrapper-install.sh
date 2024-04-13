#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
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


function python-virtualenvwrapper-config() {
  $(lsd-mod.python.virtualenvwrapper.config "$@")
}


function python-virtualenvwrapper-test() {
  $(lsd-mod.python.virtualenvwrapper.test "$@")
}


function python-virtualenvwrapper-create() {
  $(lsd-mod.python.virtualenvwrapper.create "$@")
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

  source ${LSCRIPTS}/core/argparse.sh "$@"

  local _prog="python-virtualenvwrapper"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Installing..."
      __${_prog}-install "$@"
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
      ${_prog}-test "$@"
  } || lsd-mod.log.echo "${_msg}"

  _que="Create python virtualenv now"
  _msg="Skipping python virtualenv creation!"
  lsd-mod.fio.yesno_yes "${_que}" && {
    lsd-mod.log.echo "Creating..."
    ${_prog}-create "$@"
  } || lsd-mod.log.echo "${_msg}"

}

python-virtualenvwrapper-install.main "$@"
