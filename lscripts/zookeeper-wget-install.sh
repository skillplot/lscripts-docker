#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='zookeeper.md'
###----------------------------------------------------------
## Zookeeper
###----------------------------------------------------------
#
## References:
## * https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-an-apache-zookeeper-cluster-on-ubuntu-18-04
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function zookeeper-uninstall() {
  lsd-mod.log.info "_prog: ${_prog}-uninstall"
}


function zookeeper-config() {
  lsd-mod.log.info "_prog: ${_prog}-config"

  [[ ! -L ${_LSD__EXTERNAL_HOME}/${PROG} ]] && ln -s ${PROG_DIR} ${_LSD__EXTERNAL_HOME}/${PROG}

  ls -l ${_LSD__EXTERNAL_HOME}/${PROG} || lsd-mod.log.fail "Installation does not exists: ${_LSD__EXTERNAL_HOME}/${PROG}"

  lsd-mod.log.info " username=${ZOOKEEPER_USERNAME} groupname=${ZOOKEEPER_GROUPNAME}"
  lsd-mod.system.create_nologin_user --username=${ZOOKEEPER_USERNAME} --groupname=${ZOOKEEPER_GROUPNAME}
  # su -l ${ZOOKEEPER_USERNAME}

  sudo chown -R ${ZOOKEEPER_USERNAME}:${ZOOKEEPER_GROUPNAME} ${PROG_DIR}
  ## -h flag to change the ownership of the link itself. Not specifying -h changes the ownership of the target of the link, which you explicitly did in the previous step.
  sudo chown -h ${ZOOKEEPER_USERNAME}:${ZOOKEEPER_GROUPNAME} ${_LSD__EXTERNAL_HOME}/${PROG}
}


function __zookeeper-install() {
  lsd-mod.log.info "_prog: ${_prog}-install"
  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh
}


function zookeeper-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  source ${LSCRIPTS}/partials/basepath.sh

  local _prog="zookeeper"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  ## program specific variables
  if [ -z "${ZOOKEEPER_VER}" ]; then
    # local ZOOKEEPER_VER="3.6.2"
    local ZOOKEEPER_VER="3.5.8"
    echo "Unable to get ZOOKEEPER_VER version, falling back to default version#: ${ZOOKEEPER_VER}"
  fi

  local PROG=${_prog}
  local DIR="apache-${PROG}-${ZOOKEEPER_VER}-bin"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"
  local FILE="${DIR}.tar.gz"

  ## local URL=https://mirrors.estointernet.in/apache/zookeeper/zookeeper-3.6.1/apache-zookeeper-3.6.1-bin.tar.gz
  # local URL=https://mirrors.estointernet.in/apache/zookeeper/zookeeper-${ZOOKEEPER_VER}/${FILE}

  ## https://mirrors.estointernet.in/apache/zookeeper/stable/apache-zookeeper-3.5.8-bin.tar.gz
  local URL=https://mirrors.estointernet.in/apache/zookeeper/stable/${FILE}

  local ZOOKEEPER_USERNAME=zk
  local ZOOKEEPER_GROUPNAME=zk
  local ZOOKEEPER_HOME=${_LSD__EXTERNAL_HOME}/${_prog}

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
      source "${LSCRIPTS}/${_prog}-verify.sh" --home=${ZOOKEEPER_HOME} --username=${ZOOKEEPER_USERNAME}
    } || lsd-mod.log.echo "${_msg}"
}

zookeeper-wget-install.main "$@"
