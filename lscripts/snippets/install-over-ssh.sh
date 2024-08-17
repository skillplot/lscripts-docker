#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

## Package name
_pckg='w3m'

## Local and remote directories
local_directory="/tmp/${_pckg}-packages"
remote_directory="/tmp/${_pckg}-packages"

## Prompt for remote user and host
read -p "Enter the remote username: " remote_user
read -p "Enter the remote host (IP or hostname): " remote_host

## Create local directory
mkdir -p ${local_directory}
cd ${local_directory}

## Download w3m and its dependencies if not already downloaded
[[ ! -f "${_pckg}_*.deb" ]] && {
  sudo apt-get update
  apt-get download ${_pckg}
  apt-cache depends ${_pckg} | grep Depends | sed "s/.*ends:\ //" | xargs apt-get download
}

## Download the packages needed for --fix-broken
apt-get install --download-only -f

## Transfer the directory using rsync to avoid overhead
rsync -avz ${local_directory}/ ${remote_user}@${remote_host}:${remote_directory}/

## Install the packages remotely
ssh -t ${remote_user}@${remote_host} "cd ${remote_directory} && sudo -S dpkg -i *.deb && sudo -S apt-get install -f"
