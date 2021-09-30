#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## docker stack configuration.
## This is not for the docker container
#
## NOTE:
## - Last one is what is used if not commented#
###----------------------------------------------------------


local DOCKER_CMD="docker"
local DOCKER_COMPOSE_CMD="docker-compose"

##----------------------------------------------------------
## Docker version
##----------------------------------------------------------
local DOCKER_VERSION="19.03.1"
local DOCKER_REPO_URL="https://download.docker.com/linux/ubuntu"
local DOCKER_KEY_URL="${DOCKER_REPO_URL}/gpg"
## last 8 characters of the key with fingerprint: 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
local DOCKER_REPO_KEY="0EBFCD88"

##----------------------------------------------------------
## Docker Compose version
##----------------------------------------------------------
## https://github.com/docker/compose/releases/
## https://github.com/docker/compose/releases/download/1.26.2/docker-compose-Linux-x86_64
local DOCKER_COMPOSE_VER="1.26.2"
local DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)"
