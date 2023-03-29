#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
#
## References:
## https://www.linode.com/docs/guides/introduction-to-systemctl/#listing-installed-unit-files
###----------------------------------------------------------


function lsd-mod.systemd.get__vars() {
  lsd-mod.log.echo "${byel}###----------------------------------------------------------${nocolor}"
  lsd-mod.log.echo "${byel}systemd-cfg${nocolor}::"
  lsd-mod.log.echo "${bgre}${nocolor}"
  #
  lsd-mod.log.echo "${byel}###----------------------------------------------------------${nocolor}"
  ##
}


function lsd-mod.systemd.list-dependencies() {
  ## To display a list of a unit file’s dependencies, use the list-dependencies command:
  systemctl list-dependencies "$1"
}


function lsd-mod.systemd.list-enabled() {
  systemctl list-unit-files --state=enabled
}


function lsd-mod.systemd.list-running() {
  # To list all the systemd service which are in state=active and sub=running
  systemctl list-units --type=service --state=running
}


function lsd-mod.systemd.list-active() {
  # To list all the systemd serice which are in state=active and sub either running or exited
  systemctl list-units --type=service --state=active
}


function lsd-mod.systemd.list-all() {
  ## Listing Installed Unit Files
  systemctl list-unit-files --type=service
}


function lsd-mod.systemd.cat() {
  ## To view the contents of a unit file, run the cat command
  systemctl cat "$1"
}


function lsd-mod.systemd.nvm.create-service-config() {
  local _appname=$(basename $PWD)
  local _servicename="$1"
  [[ ! -z ${_servicename} ]] || _servicename="${_appname}.service"

  # local service_filepath=/etc/systemd/system/${_servicename}
  local service_filepath=${_servicename}
  local env_filepath=${HOME}/.$(echo "${_appname}" | tr '-' '/').env
  local node_version=$(node --version)
  local node_home=${HOME}/.nvm/versions/node/${node_version}
  local working_directory=${node_home}/lib/node_modules/${_appname}

  lsd-mod.log.debug "service_filepath: ${service_filepath}"
  lsd-mod.log.debug "working_directory: ${working_directory}"
  lsd-mod.log.debug "env_filepath: ${env_filepath}"
  lsd-mod.log.debug "node_version: ${node_version}"
  lsd-mod.log.debug "node_home: ${node_home}"

  lsd-mod.log.info "##----------------------------------------------------------"

## TODO:
## 1. Environment file to be used; to check what happens if it does not exists but configured here
## 2. In ExecStartif nodejs version can be picked without giving full path as it's in path env already
## 3. In ExecStartif multiple shell commands with `&&` can be executed or not as given
tee ${service_filepath}<<EOF
[Unit]
Description=${_appname} Daemon
After=network.target

[Service]
Type=simple
User=$(id -un)
Group=$(id -gn)
WorkingDirectory=${working_directory}
#EnvironmentFile=-${env_filepath}
Environment="PATH=${node_home}/bin:${HOME}/.npm-packages/bin:${HOME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#ExecStart=which node && node --version && node src/start.js
ExecStart=${node_home}/bin/node src/start.js


Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
}


function lsd-mod.systemd.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/system/utils/common.sh

  source ${LSCRIPTS}/argparse.sh "$@"

  lsd-mod.log.debug "executing script...: ${scriptname}"
  lsd-mod.log.debug "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"
  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] || lsd-mod.log.debug "Key does not exists: ${key}"
  done
}
