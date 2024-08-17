#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## vscode editor
###----------------------------------------------------------
#
## References:
## * https://tecadmin.net/install-visual-studio-code-ubuntu-18-04/
## * https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/

## sudo apt -y install software-properties-common apt-transport-https wget
## wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
## sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
## sudo apt -y update
## sudo apt -y install code

## curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg 
## sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
## echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list 
## sudo apt update 
## sudo apt install code 
#
## sudo apt install snapd
## sudo snap install code --classic
##----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function vscode-addkey() {
  local VSCODE_KEY_URL="https://packages.microsoft.com/keys/microsoft.asc"
  wget -q ${VSCODE_KEY_URL} -O- | sudo apt-key add -
  # curl -sS ${VSCODE_KEY_URL} | gpg --dearmor | sudo apt-key add -
  # curl -sS ${VSCODE_KEY_URL} | sudo apt-key add -
}


function vscode-addrepo() {
  # echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  local VSCODE_REPO_URL="http://packages.microsoft.com/repos/vscode"
  echo "deb [arch=amd64] ${VSCODE_REPO_URL} stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
}


function __vscode-install() {
  sudo apt -y update
  sudo apt -y install --no-install-recommends code
  # lsd-mod.log.info "code version is: $(code --version)"

  lsd-mod.log.info "I did not like microsoft hicjacking 'code' as the executable name. It's a conspiracy in my opinion to dictate and rule!"
  lsd-mod.log.info "Relinking 'code' to 'vscode' as executable name"
  sudo unlink /usr/bin/code
  sudo ln -s /usr/share/code/bin/code /usr/bin/vscode
}


function vscode-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="vscode"

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

vscode-apt-install.main "$@"
