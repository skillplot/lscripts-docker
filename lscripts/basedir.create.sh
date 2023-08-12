#!/bin/bash

sudo mkdir -p /codehub/apps /codehub/external /datahub
sudo chown -R $(id -un):$(id -gn) /codehub
sudo chown -R $(id -un):$(id -gn) /datahub



sudo apt -y update
sudo apt -y install git vim


cd /codehub/external
git clone https://github.com/skillplot/lscripts-docker.git



vi ~/.bashrc
###
## custom configuration
###
alias l='ls -ltr'
export LSCRIPTS_DOCKER="/codehub/external/lscripts-docker"
[ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh


sudo apt -y install python3-pil python3-pil.imagetk

cd /codehub/apps/entryexit

pip install -r pi-172.18.19.171-requirements.txt



