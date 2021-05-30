#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install nodejs
#
## * Installing the Distro-Stable Version for Ubuntu
##  - default repositories that can be used to provide a consistent experience across multiple systems
##  - This will not be the latest version, but it should be stable
## * Installing Using a PPA
##  - This will have more up-to-date versions of Node.js than the official Ubuntu repositories
## * Installing Using NVM (Node.js Version Manager)
##  - this allows to install multiple self-contained versions of Node.js without affecting the entire system
## * Using nodejs inside docker
#
## References:
##  - https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04
##  - https://github.com/nvm-sh/nvm
##  - https://classic.yarnpkg.com/en/docs/install/#debian-stable
##  - https://blua.blue/article/how-to-install-global-npm-packages-without-sudo-on-ubuntu/
##----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function nodejs-uninstall() {
  _log_.warn "nodejs will be uninstalled and configuration will be removed!"

  # _log_.info "remove the package and retain the configuration files."
  # sudo apt remove nodejs

  _log_.warn "uninstalling the package and remove the configuration files associated with it."
  sudo apt purge nodejs
}


function nodejs-uninstall() {
  _log_.warn "nodejs will be uninstalled and configuration will be removed!"

  _log_.info "remove the package and retain the configuration files."
  sudo apt remove nodejs

  _log_.info "uninstall the package and remove the configuration files associated with it."
  sudo apt purge nodejs
}


function nodejs-config() {
  _log_.info "nodejs-config"

  ## Todo: use lscripts specific config file
  ## Todo: check if line already exists in config file or not
  [[ ! -L "${HOME}/.npm-packages" ]] && {
    mkdir -p "${HOME}/.npm-packages"
    touch ${HOME}/.npmrc
    echo prefix='${HOME}/.npm-packages' > ${HOME}/.npmrc
    echo NPM_PACKAGES='${HOME}/.npm-packages' >> ${HOME}/.bashrc
    echo PATH='${NPM_PACKAGES}/bin:$PATH' >> ${HOME}/.bashrc
    unset MANPATH # delete if you already modified MANPATH elsewhere in your config
    echo "export MANPATH='${NPM_PACKAGES}/share/man:$(manpath)'" >> ${HOME}/.bashrc
  }
  
  # local NPM_PACKAGES="${HOME}/.npm-packages"
  npm config set prefix "${HOME}/.npm-packages"

  # ## cushion if source for bashrc does not happen
  # export MANPATH='${NPM_PACKAGES}/share/man:$(manpath)'
  # ls -l ${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/nodejs.requirements.sh
}


function nodejs-install-packages() {
  _log_.info "nodejs-install-packages"
  ls -l ${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/nodejs.requirements.sh
  source ${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/nodejs.requirements.sh
}


function __nodejs-install() {
  # local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  # source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${NODEJS_VER}" ]; then
    local NODEJS_VER=16
    echo "Unable to get NODEJS_VER version, falling back to default version#: ${NODEJS_VER}"
  fi

  echo "LINUX_VERSION:${LINUX_VERSION}"
  ## Ubuntu 16.04 LTS
  [[ ${LINUX_VERSION} == "16.04" ]] && (sudo apt -y install python-software-properties)
  ## Ubuntu 18.04 LTS
  [[ ${LINUX_VERSION} == "18.04" ]] && (sudo apt -y install software-properties-common)
  ## Kali 2019.1
  [[ ${LINUX_ID} == "Kali" ]] && (sudo apt -y install software-properties-common)

  curl -sL https://deb.nodesource.com/setup_${NODEJS_VER}.x | sudo -E bash -
  ## wget -qO- https://deb.nodesource.com/setup_${NODEJS_VER}.x | sudo -E bash -

  sudo apt -y install nodejs
  nodejs -v

  ## If required -
  # ## Fix for Error: npm : Depends: node-gyp (>= 0.10.9) but it is not going to be installed
  # ## https://askubuntu.com/questions/1088662/npm-depends-node-gyp-0-10-9-but-it-is-not-going-to-be-installed
  # sudo apt -y install nodejs-dev node-gyp libssl1.0-dev
  # sudo apt -y install npm
  # npm update -g npm
  # npm -v
  # node -v
}


function nodejs-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _prog="nodejs"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Installing..." && \
      __${_prog}-install \
    || _log_.echo "${_msg}"

  _que="Configure ${_prog} now (recommended)"
  _msg="Skipping ${_prog} configuration. This is critical for proper python environment working!"
  _fio_.yesno_no "${_que}" && \
      _log_.echo "Configuring..." && \
      ${_prog}-config \
    || _log_.echo "${_msg}"

  _que="Install packages for ${_prog} now (recommended)"
  _msg="Skipping ${_prog} installing packages."
  _fio_.yesno_no "${_que}" && \
      _log_.echo "Installing packages..." && \
      ${_prog}-install-packages \
    || _log_.echo "${_msg}"
}

nodejs-install.main "$@"
