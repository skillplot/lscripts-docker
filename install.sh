#!/bin/bash

## TODO:: prompt for user input for codehub and datahub root

export __CODEHUB_ROOT__="/codehub"
export __DATAHUB_ROOT__="/datahub"
export __AIMLHUB_ROOT__="${__CODEHUB_ROOT__}/aihub"

## TODO:: error handling
sudo mkdir -p ${__CODEHUB_ROOT__}/external ${__CODEHUB_ROOT__}/aihub ${__CODEHUB_ROOT__}/ailab
sudo chown -R $(id -un):$(id -gn) /codehub

sudo mkdir -p ${__DATAHUB_ROOT__}
sudo chown -R $(id -un):$(id -gn) ${__DATAHUB_ROOT__}


sudo apt -y update
sudo apt -y install git

git -C ${__CODEHUB_ROOT__}/external clone https://github.com/skillplot/lscripts-docker.git


# ## TODO:: be injected in ~/.bashrc

# export __CODEHUB_ROOT__="/codehub"
# export __DATAHUB_ROOT__="/datahub"
# export __AIMLHUB_ROOT__="${__CODEHUB_ROOT__}/aihub"

# export LSCRIPTS_DOCKER="${__CODEHUB_ROOT__}/external/lscripts-docker"
# [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh

