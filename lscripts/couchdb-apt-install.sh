#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## couchdb - NoSQL Database
###----------------------------------------------------------
#
## References:
## * https://couchdb.apache.org/
## * https://docs.couchdb.org/en/stable/install/unix.html#installing-the-apache-couchdb-packages
## * https://docs.couchdb.org/en/stable/install/unix.html
## * https://github.com/apache/couchdb/issues/1856
## * https://www.rosehosting.com/blog/how-to-install-apache-couchdb-on-ubuntu-18-04/
## * http://127.0.0.1:5984/_utils/
###----------------------------------------------------------


function couchdb-addrepo-key() {
  # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8756C4F765C9AC3CB6B85D62379CE192D401AB61
  curl -sSL https://couchdb.apache.org/repo/bintray-pubkey.asc | sudo apt-key add -
}


function couchdb-addrepo() {
  echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"
  # sudo sh -c 'echo "deb https://apache.bintray.com/couchdb-deb bionic main" > /etc/apt/sources.list.d/couchdb.list'
  sudo sh -c "echo \"deb https://apache.bintray.com/couchdb-deb ${LINUX_CODE_NAME} main\" > /etc/apt/sources.list.d/couchdb.list"
  # cat /etc/apt/sources.list.d/couchdb.list
}


function __couchdb-install() {
  # echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"
  # couchdb-addrepo

  # couchdb-addrepo-key

  sudo apt -y update
  # sudo apt -y install couchdb

}


function couchdb-apt-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"

  local _default=no
  local _que
  local _msg
  local _prog

  _prog="couchdb"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Uninstalling..." && \
          ${_prog}-uninstall \
    || _log_.echo "${_msg}"

  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Adding ${_prog} repo..." && \
          ${_prog}-addrepo \
    || _log_.echo "${_msg}"

  _que="Add/Update ${_prog} repo Key"
  _msg="Skipping adding/updating ${_prog} repo!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Adding/Updating ${_prog} repo key..." && \
          ${_prog}-addrepo-key \
    || _log_.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && \
    _log_.echo "Installing..." && \
    __${_prog}-install \
    || _log_.echo "${_msg}"

}

couchdb-apt-install
