#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Apache2 installation with custom configure
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function apache2-uninstall() {
  lsd-mod.log.warn "apache2 will be uninstalled and configuration will be removed!"

  # lsd-mod.log.info "remove the package and retain the configuration files."
  # sudo apt remove apache2

  lsd-mod.log.warn "uninstalling the package and remove the configuration files associated with it."
  sudo apt purge apache2 apache2-data apache2-utils apache2.2-bin apache2-common
}


function apache2-config() {
  source "${LSCRIPTS}/apache2-config.sh"
}


function apache2-modules() {
  if [ -z "${PHP_VER}" ]; then
    local PHP_VER="7.2"
    echo "Unable to get PHP version, falling back to default version#: ${PHP_VER}"
  fi

  ## Install PHP and MySQL modules for Apache2
  # sudo apt -y install php libapache2-mod-php php-mcrypt php-mysql libapache2-mod-php${PHP_VER}

  sudo apt -y install libapache2-mod-php${PHP_VER}
  sudo apt -y install libapache2-mod-wsgi
  sudo apt -y install libapache2-mod-wsgi-py3
}


function __apache2-install() {
  sudo apt -y install apache2
}


function apache2-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="apache2"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install \
    || lsd-mod.log.echo "${_msg}"

  _que="Install modules for ${_prog}"
  _msg="Skipping modules installation."
  lsd-mod.fio.yesno_no "${_que}" && \
      lsd-mod.log.echo "Installing modules..." && \
      ${_prog}-modules \
    || lsd-mod.log.echo "${_msg}"

  _que="Configure ${_prog} now (recommended)"
  _msg="Skipping ${_prog} configuration. This is critical for proper python environment working!"
  lsd-mod.fio.yesno_no "${_que}" && \
      lsd-mod.log.echo "Configuring..." && \
      ${_prog}-config \
    || lsd-mod.log.echo "${_msg}"
}

apache2-install "$@"
