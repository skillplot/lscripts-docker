#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='kafka.md'
###----------------------------------------------------------
## kafka
###----------------------------------------------------------
#
## References:
## * https://www.digitalocean.com/community/tutorials/how-to-install-apache-kafka-on-ubuntu-18-04
#
## `wget -c https://www.apache.org/dist/kafka/2.5.0/kafka_2.13-2.50.tgz`
##----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function kafka-uninstall() {
  lsd-mod.log.info "_prog: ${_prog}-uninstall"
}


function kafka-config() {
  lsd-mod.log.info "_prog: ${_prog}-config"

  [[ ! -L ${_LSD__EXTERNAL_HOME}/${PROG} ]] && ln -s ${PROG_DIR} ${_LSD__EXTERNAL_HOME}/${PROG}

  ls -l ${_LSD__EXTERNAL_HOME}/${PROG} || lsd-mod.log.fail "Installation does not exists: ${_LSD__EXTERNAL_HOME}/${PROG}"

  lsd-mod.log.info " user=${KAFKA_USERNAME} group=${KAFKA_GROUPNAME}"
  lsd-mod.system.admin.create-nologin-user --user=${KAFKA_USERNAME} --group=${KAFKA_GROUPNAME}
  # su -l ${KAFKA_USERNAME}

  sudo chown -R ${KAFKA_USERNAME}:${KAFKA_GROUPNAME} ${PROG_DIR}
  ## -h flag to change the ownership of the link itself. Not specifying -h changes the ownership of the target of the link, which you explicitly did in the previous step.
  sudo chown -h ${KAFKA_USERNAME}:${KAFKA_GROUPNAME} ${_LSD__EXTERNAL_HOME}/${PROG}
}


function __kafka-install() {
  lsd-mod.log.info "_prog: ${_prog}-install"
  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh
}


function kafka-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  source ${LSCRIPTS}/partials/basepath.sh

  local _prog="kafka"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  ## program specific variables
  if [ -z "${KAFKA_VER}" ]; then
    local KAFKA_REL="2.5.0"
    local KAFKA_VER="2.13"
    echo "Unable to get KAFKA_VER version, falling back to default version#: ${KAFKA_VER}"
  fi

  # local PROG='kafka'
  local PROG=${_prog}
  local DIR="${PROG}-${KAFKA_VER}"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${PROG}_${KAFKA_VER}-${KAFKA_REL}"
  local FILE="${PROG}_${KAFKA_VER}-${KAFKA_REL}.tgz"

  local URL="https://www.apache.org/dist/kafka/${KAFKA_REL}/${FILE}"

  local KAFKA_HOME=${_LSD__EXTERNAL_HOME}/${_prog}
  local KAFKA_USERNAME=kafka
  local KAFKA_GROUPNAME=kafka

  declare -gA __ENVVARS=()
  __ENVVARS['KAFKA_HOME']=${KAFKA_HOME}
  __ENVVARS['KAFKA_USERNAME']=${KAFKA_USERNAME}
  __ENVVARS['KAFKA_GROUPNAME']=${KAFKA_GROUPNAME}
  __ENVVARS['CFGFILE']=${KAFKA_GROUPNAME}

  function create_env_file() {
    lsd-mod.log.info "create env"
    local env_file=${__ENVVARS['CFGFILE']}
    local env
    local _line
    
    lsd-mod.log.info "env_file: ${env_file}"
    for env in "${!__ENVVARS[@]}"; do
      _line="${env}"=${__ENVVARS[${env}]}
      lsd-mod.log.info ${_line}
      echo "${_line}" >> ${env_file}
    done
  }

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install \
    || lsd-mod.log.echo "${_msg}"


  _que="Configure ${_prog} now (recommended)"
  _msg="Skipping ${_prog} configuration. This is critical for proper python environment working!"
  lsd-mod.fio.yesno_no "${_que}" && \
      lsd-mod.log.echo "Configuring..." && \
      ${_prog}-config \
    || lsd-mod.log.echo "${_msg}"


  _que="Verify ${_prog} now"
  _msg="Skipping ${_prog} verification!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Verifying..."
      source "${LSCRIPTS}/${_prog}-verify.sh" --home=${KAFKA_HOME} --username=${KAFKA_USERNAME}
    } || lsd-mod.log.echo "${_msg}"
}

kafka-wget-install.main "$@"
