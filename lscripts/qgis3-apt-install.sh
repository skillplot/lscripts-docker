#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## qGIS 3
###----------------------------------------------------------
#
## References:
## * https://github.com/qgis/QGIS
## * https://qgis.org/en/site/forusers/alldownloads.html#debian-ubuntu
## * https://qgis.org/en/site/getinvolved/index.html
## * https://scriptndebug.wordpress.com/2018/02/27/installing-qgis-3-on-ubuntu-16-04/
## * https://gis.stackexchange.com/questions/272545/installing-qgis-3-0-on-ubuntu
#
## Build from source:
## * https://www.lutraconsulting.co.uk/blog/2017/08/06/qgis3d-build/
## * https://qgis.org/en/site/forusers/alldownloads.html#debian-ubuntu
#
## `wget -O - https://qgis.org/downloads/qgis-2017.gpg.key | gpg --import`
## `gpg --fingerprint CAEB3DC3BDF7FB45`
## `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45`
#
## `sudo apt autoremove qgis`
## `sudo apt --purge remove qgis python-qgis qgis-plugin-grass`
## `sudo apt autoremove`
## `sudo apt update`
## `sudo apt install qgis python-qgis qgis-plugin-grass saga`
#
## Download:
## * https://qgis.org/debian/dists/bionic/main/
#
## Build Instructions
## * https://htmlpreview.github.io/?https://github.com/qgis/QGIS/blob/master/doc/INSTALL.html#toc11
#
## add Ubuntu 18.04 specific repository of QGIS 3
## * https://linuxhint.com/install-qgis3-geospatial-ubuntu/
##----------------------------------------------------------


function qgis3-uninstall() {
  sudo apt -y remove qgis python-qgis qgis-plugin-grass
}


function qgis3-addrepo-key() {
  ## import the GPG key of QGIS 3 
  # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 51F523511C7028C3
  # wget -O - https://qgis.org/downloads/qgis-2017.gpg.key | sudo gpg --import

  # # verify whether the GPG key was imported correctly
  # gpg --fingerprint CAEB3DC3BDF7FB45
  # # add the GPG key of QGIS 3 to apt package manager:
  # gpg --export --armor CAEB3DC3BDF7FB45 | sudo apt-key add -

  ## https://gis.stackexchange.com/questions/332245/error-adding-qgis-org-repository-public-key-to-apt-keyring/332247  
  ## https://www.qgis.org/en/site/forusers/alldownloads.html

  # ## 2019
  # wget -O - https://qgis.org/downloads/qgis-2019.gpg.key | sudo gpg --import
  # ## verify whether the GPG key was imported correctly
  # gpg --fingerprint 51F523511C7028C3
  # ## add the GPG key of QGIS 3 to apt package manager:
  # gpg --export --armor 51F523511C7028C3 | sudo apt-key add -


  ## 2020
  wget -O - https://qgis.org/downloads/qgis-2020.gpg.key | sudo gpg --import
  gpg --fingerprint F7E06F06199EF2F2
  gpg --export --armor F7E06F06199EF2F2 | sudo apt-key add -

}


function qgis3-addrepo() {
  echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"
  # sudo sh -c 'echo "deb https://qgis.org/debian bionic main" > /etc/apt/sources.list.d/qgis3.list'
  sudo sh -c "echo \"deb https://qgis.org/debian ${LINUX_CODE_NAME} main\" > /etc/apt/sources.list.d/qgis3.list"
  # cat /etc/apt/sources.list.d/qgis3.list
}


function __qgis3-install() {
  qgis3-addrepo

  qgis3-addrepo-key

  sudo apt -y update
  sudo apt -y install qgis python-qgis qgis-plugin-grass

}


function qgis3-apt-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local _default=no
  local _que
  local _msg
  local _prog

  _prog="qgis3"

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

qgis3-apt-install
