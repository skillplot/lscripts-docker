#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## mongodb utility functions
###----------------------------------------------------------


function lsd-mod.mongodb.get__vars() {
  lsd-mod.log.echo "MONGODB_DOCKER_REPO_URL: ${bgre}${MONGODB_DOCKER_REPO_URL}${nocolor}"
  lsd-mod.log.echo "MONGODB_DOCKER_PREFIX: ${bgre}${MONGODB_DOCKER_PREFIX}${nocolor}"
  lsd-mod.log.echo "MONGODB_CONFIG_FILE: ${bgre}${MONGODB_CONFIG_FILE}${nocolor}"
  lsd-mod.log.echo "MONGODB_DOCKER_IMG: ${bgre}${MONGODB_DOCKER_IMG}${nocolor}"
  lsd-mod.log.echo "MONGODB_DOCKER_CONTAINER_NAME: ${bgre}${MONGODB_DOCKER_CONTAINER_NAME}${nocolor}"
  # lsd-mod.log.echo "MONGODB_INITDB_ROOT_USERNAME: ${bgre}${MONGODB_INITDB_ROOT_USERNAME}${nocolor}"
  # lsd-mod.log.echo "MONGODB_INITDB_ROOT_PASSWORD: ${bgre}${MONGODB_INITDB_ROOT_PASSWORD}${nocolor}"
  lsd-mod.log.echo "MONGODB_DOCKER_ENVVARS: ${bgre}${MONGODB_DOCKER_ENVVARS}${nocolor}"
  lsd-mod.log.echo "MONGODB_PORTS: ${bgre}${MONGODB_PORTS}${nocolor}"
  lsd-mod.log.echo "MONGODB_USER: ${bgre}${MONGODB_USER}${nocolor}"
  lsd-mod.log.echo "MONGODB_USER_ID: ${bgre}${MONGODB_USER_ID}${nocolor}"
  lsd-mod.log.echo "MONGODB_GRP: ${bgre}${MONGODB_GRP}${nocolor}"
  lsd-mod.log.echo "MONGODB_GRP_ID: ${bgre}${MONGODB_GRP_ID}${nocolor}"
}
