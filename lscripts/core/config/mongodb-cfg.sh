#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## MongoDB and MongoDB Docker configuration
###----------------------------------------------------------

###----------------------------------------------------------
## MongoDB Container Images Repo - custom build
###----------------------------------------------------------
local MONGODB_DOCKER_REPO_URL="https://github.com/docker-library/mongo.git"

local MONGODB_DOCKER_PREFIX="${DOCKER_PREFIX}"
local MONGODB_CONFIG_FILE="${_LSD__HOME}/core/config/mongodb/mongod.conf"

local MONGODB_DOCKER_IMG="mongouid"
local MONGODB_DOCKER_CONTAINER_NAME="${MONGODB_DOCKER_PREFIX}-${MONGODB_DOCKER_IMG}"
# local MONGODB_INITDB_ROOT_USERNAME=""
# local MONGODB_INITDB_ROOT_PASSWORD=""
local MONGODB_DOCKER_ENVVARS=""

###----------------------------------------------------------
## MongoDB networking configuration
###----------------------------------------------------------
local MONGODB_PORTS="27017"

local MONGODB_USER
local MONGODB_USER_ID
local MONGODB_GRP
local MONGODB_GRP_ID

## Custom username, group, uid, gid for mongodb
id -un mongodb &>/dev/null && {
  MONGODB_USER=$(id -un mongodb)
  MONGODB_USER_ID=$(id -u mongodb)
  MONGODB_GRP=$(id -gn mongodb)
  MONGODB_GRP_ID=$(id -g mongodb)

  ## mongodb user fix
  MONGODB_DOCKER_ENVVARS="${MONGODB_DOCKER_ENVVARS} -e MONGODB_USER=${MONGODB_USER} "
  MONGODB_DOCKER_ENVVARS="${MONGODB_DOCKER_ENVVARS} -e MONGODB_USER_ID=${MONGODB_USER_ID} "
  MONGODB_DOCKER_ENVVARS="${MONGODB_DOCKER_ENVVARS} -e MONGODB_GRP=${MONGODB_GRP} "
  MONGODB_DOCKER_ENVVARS="${MONGODB_DOCKER_ENVVARS} -e MONGODB_GRP_ID=${MONGODB_GRP_ID} "

}
