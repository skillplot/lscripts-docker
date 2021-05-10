#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install epublishing Stack - TeX/LaTeX, pandoc,
## epub, and editors
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function stack-setup-epub() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _default=yes
  local _que
  local _msg
  local _prog


  _prog="epub-stack"
  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  _prog='latex'
  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Installing..."
    source ${LSCRIPTS}/${_prog}-apt-install.sh
  } || _log_.echo "${_msg}" && _default=no


  _prog='pandoc'
  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Installing..."
    source ${LSCRIPTS}/${_prog}-wget-dpkg-install.sh
  } || _log_.echo "${_msg}" && _default=no


  _prog='markdown-editors'
  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Installing..."
    source ${LSCRIPTS}/${_prog}-install.sh
  } || _log_.echo "${_msg}" && _default=no


  _prog='latex-editors'
  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Installing..."
    source ${LSCRIPTS}/${_prog}-apt-install.sh
  } || _log_.echo "${_msg}" && _default=no


  _prog='epub-editors'
  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Installing..."
    source ${LSCRIPTS}/${_prog}-apt-install.sh
  } || _log_.echo "${_msg}" && _default=no


  _prog='epub-readers'
  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && {
    _log_.echo "Installing..."
    source ${LSCRIPTS}/${_prog}-apt-install.sh
  } || _log_.echo "${_msg}" && _default=no

}

stack-setup-epub
