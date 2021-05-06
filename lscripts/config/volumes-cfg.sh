#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Docker volumes configuration
#
## References:
##  - https://stackoverflow.com/a/63204661/748469
###----------------------------------------------------------

## DOCKER_VOLUMES provides for mapping of enitre code, vm, data and mobile dirs
## inside the container, making it completely stateless. Even python virtual env created
## inside container are locally stored, hence save safe, inreases the usability & mnodularity
local DOCKER_VOLUMES=""

###----------------------------------------------------------
## NOTE:
##  - Bind mounting the Docker daemon socket gives a lot of power to a container
##  as it can control the daemon. It must be used with caution, and only with containers we can trust.
###----------------------------------------------------------
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /dev:/dev \
#   -v /media:/media \
#   -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#   -v /etc/localtime:/etc/localtime:ro \
#   -v /usr/src:/usr/src \
#   -v /lib/modules:/lib/modules"

# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /var/run/docker.sock:/var/run/docker.sock "

## Do NOT delete the trailing space
###----------------------------------------------------------
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${BASEDIR}:${BASEDIR} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DOCKER_VM_ROOT}:${DOCKER_VM_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DOCKER_DATA_ROOT}:${DOCKER_DATA_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DOCKER_MOBILE_ROOT}:${DOCKER_MOBILE_ROOT} "

###----------------------------------------------------------
## MongoDB Container volume map
###----------------------------------------------------------
local MONGODB_VOLUMES=""
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${DOCKER_DATA_ROOT}/databases/mongodb:/data "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${DOCKER_DATA_ROOT}/databases/mongodb/db:/data/db "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${DOCKER_DATA_ROOT}/databases/mongodb/configdb:/data/configdb "
# MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${DOCKER_DATA_ROOT}/databases/mongodb/key:/data/key "
# MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${DOCKER_DATA_ROOT}/databases/mongodb/logs:/data/logs "

## Let the create container script have fine control on volume mapping
# DOCKER_VOLUMES="${DOCKER_VOLUMES} ${MONGODB_VOLUMES} "
