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
##  https://github.com/nvm-sh/nvm
##  https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04
##  https://classic.yarnpkg.com/en/docs/install/#debian-stable
##  https://blua.blue/article/how-to-install-global-npm-packages-without-sudo-on-ubuntu/
##----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


function nodejs-install-packages() {
  _log_.info "nodejs-install-packages"
  ls -l ${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/nodejs.requirements.sh
  source ${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/nodejs.requirements.sh
}


function __nvm-install() {
  ## Running either of the commands downloads a script and runs it.
  ## The script clones the nvm repository to ~/.nvm, and attempts to add the source
  ## lines from the snippet below to the correct profile file:
  ## (~/.bash_profile, ~/.zshrc, ~/.profile, or ~/.bashrc).

  # local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  # source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${NODE_NVM_VER}" ]; then
    local NODE_NVM_VER=v0.38.0
    echo "Unable to get NODE_NVM_VER version, falling back to default version#: ${NODE_NVM_VER}"
  fi

  ## Warning: should inspect, instead of running blindfaith
  # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  # curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh -o install_nvm.sh

  _log_.debug "If environment variable XDG_CONFIG_HOME is present, it will place the nvm files there: ${XDG_CONFIG_HOME}"
  ## You can customize the install source, directory, profile, and version using the NVM_SOURCE, NVM_DIR, PROFILE, and NODE_VERSION variables. Eg: curl ... | NVM_DIR="path/to/nvm". Ensure that the NVM_DIR does not contain a trailing slash.

  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/${NODE_NVM_VER}/install.sh | bash

  # source ~/.profile
  # nvm help

  # nvm ls-remote
  # nvm install 12.18.3
  # nvm use 12.18.3
  # node -v
  # nvm ls
  # nvm alias default 12.18.3
  # nvm use default

  # nvm current
  # nvm uninstall <node_version>
  # nvm deactivate

  # nvm list
}


function nvm-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _prog="nvm"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" {
      _log_.echo "Installing..."
      __${_prog}-install
  } || _log_.echo "${_msg}"
}


nvm-install
