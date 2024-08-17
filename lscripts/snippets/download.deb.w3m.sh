#!/bin/bash

sudo apt-get update

_pckg='w3m'

local_directory="/tmp/${_pckg}-packages"
mkdir -p ${local_directory}

cd ${local_directory}

apt-get download ${_pckg}
apt-cache depends ${_pckg} | grep Depends | sed "s/.*ends:\ //" | xargs apt-get download

remote_directory="/tmp/${_pckg}-packages"

remote_user="user"
remote_host="remote_host"

## Transfer the directory
scp -r ${local_directory} ${remote_user}@${remote_host}:${remote_directory}

## Install the packages remotely
ssh ${remote_user}@${remote_host} "cd ${remote_directory} && sudo dpkg -i *.deb && sudo apt-get install -f"
