#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install yarn
#
## Reference:
## https://yarnpkg.com/lang/en/docs/install/#debian-stable
## https://code.facebook.com/posts/1840075619545360
## https://blog.servermanagementplus.com/ubuntu/the-following-signatures-were-invalid-expkeysig-23e7166788b63e1e-yarn-packaging
##----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function yarn-addkey() {
  # curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  curl -sS ${YARN_KEY_URL} | sudo apt-key add -
}


function yarn-addrepo() {
  # echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  echo "deb ${YARN_REPO_URL} stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
}


function __yarn-install() {
  sudo apt -y update
  sudo apt -y install --no-install-recommends yarn
  ## export PATH="${PATH}:/opt/yarn-[version]/bin"
  lsd-mod.log.info "yarn version is: $(yarn --version)"
}


function yarn-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="yarn"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Add/Update ${_prog} repo key"
  _msg="Skipping adding/updating ${_prog} repo key!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Adding/updating ${_prog} repo key..."
    ${_prog}-addkey
  } || lsd-mod.log.echo "${_msg}"

  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Adding ${_prog} repo..."
    ${_prog}-addrepo
  } || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Installing..."
    __${_prog}-install
  } || lsd-mod.log.echo "${_msg}"

}

yarn-apt-install.main "$@"
