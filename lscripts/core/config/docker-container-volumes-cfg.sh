#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Docker volumes configuration
#
## References:
##  - https://stackoverflow.com/a/63204661/748469
###----------------------------------------------------------


local _LSD__DOCKER_VOLUMES="${LSCRIPTS__DOCKER_VOLUMES}"
local _LSD__DOCKER_VOLUMES_UUID=$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
## DOCKER_VOLUMES provides for mapping of enitre code, vm, data and mobile dirs
## inside the container, making it completely stateless. Even python virtual env created
## inside container are locally stored, hence save safe, inreases the usability & mnodularity
local DOCKER_VOLUMES=""
[[ ! -z "${_LSD__DOCKER_VOLUMES}" ]] && \
  [[ -d "${_LSD__DOCKER_VOLUMES}" ]] &&  \
  [[ "${_LSD__DOCKER_VOLUMES}" != "/" ]] && {
  DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_VOLUMES_UUID}/${_LSD__DOCKER_VOLUMES}:${_LSD__DOCKER_VOLUMES} "
}


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
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__HOME}:${_LSD__HOME} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_AIHUB_ROOT}:${_LSD__DOCKER_AIHUB_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_AILAB_ROOT}:${_LSD__DOCKER_AILAB_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_EXTERNAL_ROOT}:${_LSD__DOCKER_EXTERNAL_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_VM_ROOT}:${_LSD__DOCKER_VM_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_DATA_ROOT}:${_LSD__DOCKER_DATA_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_MOBILE_ROOT}:${_LSD__DOCKER_MOBILE_ROOT} "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${_LSD__DOCKER_DATAHUB_ROOT}:${_LSD__DOCKER_DATAHUB_ROOT} "

###----------------------------------------------------------
## MongoDB Container volume map
###----------------------------------------------------------
local MONGODB_VOLUMES=""
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${_LSD__DOCKER_DATA_ROOT}/databases/mongodb:/data "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${_LSD__DOCKER_DATA_ROOT}/databases/mongodb/db:/data/db "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${_LSD__DOCKER_DATA_ROOT}/databases/mongodb/configdb:/data/configdb "
# MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${_LSD__DOCKER_DATA_ROOT}/databases/mongodb/key:/data/key "
# MONGODB_VOLUMES="${MONGODB_VOLUMES} -v ${_LSD__DOCKER_DATA_ROOT}/databases/mongodb/logs:/data/logs "

## Let the create container script have fine control on volume mapping
# DOCKER_VOLUMES="${DOCKER_VOLUMES} ${MONGODB_VOLUMES} "
