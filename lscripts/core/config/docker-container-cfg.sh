#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Docker configuration
#
## References:
##  - https://medium.com/better-programming/about-var-run-docker-sock-3bfd276e12fd
##	- https://www.portainer.io
## 	- https://stackoverflow.com/a/63204661/748469
## 	- https://hub.docker.com/_/docker
## 	- https://stackoverflow.com/a/63205679/748469
###----------------------------------------------------------


local DOCKER_VERSION=""
local DOCKER_CMD="docker"
local DOCKER_COMPOSE_CMD="docker-compose"
## 19.03.12
## docker version --format '{{.Server.Version}}'
type ${DOCKER_CMD} &>/dev/null && DOCKER_VERSION=$(${DOCKER_CMD} --version | cut -d',' -f1 | cut -d' ' -f3)

local DOCKER_PREFIX="skplt"

###----------------------------------------------------------
## For environment variables mapping
###----------------------------------------------------------
local DOCKER_ENVVARS=""

###----------------------------------------------------------
## SHM_SIZE::Limits the docker memory consumption
###----------------------------------------------------------
local SHM_SIZE_2GB=2G
local SHM_SIZE_4GB=4G
local SHM_SIZE_8GB=8G
local SHM_SIZE_16GB=16G

###----------------------------------------------------------
## DDISPLAY::Require to use gui from within container
###----------------------------------------------------------
local DDISPLAY="${DISPLAY}"
if [[ -z ${DISPLAY} ]];then
  DDISPLAY=":0"
fi

###----------------------------------------------------------
## Docker User configuration
#
## DUSER:: gets baked inside the docker image during build process.
## It generally would be different if you are using the image built by
## someone else or built on different machine with different username
###----------------------------------------------------------

## DUSER::docker user used during building docker image
local DUSER=${USER}
local DUSER_ID=$(id -u ${DUSER})
local DUSER_GRP=$(id -gn ${DUSER})
local DUSER_GRP_ID=$(id -g ${DUSER})
local DUSER_HOME="/home/${DUSER}"

###----------------------------------------------------------
## Docker networking configuration
###----------------------------------------------------------
local DOCKER_LOCAL_HOST="${DOCKER_PREFIX}-docker"

## 8888:8888 - jupyternotebook
## 6006:6006 - tensorboard
## 5000:5000 - flask server
## 8000:8000 - fastapi/uvicorn server
## 5432:5432 - PostgreSQL
## 8080:80   - HTTP
## 9000:9000 - Portainer
## 22:22     - SSH
local DOCKER_PORTS="8888:8888 6006:6006 4040:4040 5000:5000 8000:8000 5432:5432"
local DOCKER_MONGODB_PORTS="27017"

local DOCKER_PORTAINER_PORT="9000:9000"

## for apache2, nginx running inside docker on port 80 is accessible to 8080 on localhost
local DOCKER_HTTP_PORT="8080:80"

local MONGODB_PORTS
[[ -z ${MONGODB_PORTS} ]] && MONGODB_PORTS="${DOCKER_MONGODB_PORTS}"

local DOCKER_HOST_TO_MONGODB_PORT_MAP=""
DOCKER_HOST_TO_MONGODB_PORT_MAP="${MONGODB_PORTS} -p ${MONGODB_PORTS}:${DOCKER_MONGODB_PORTS}"
DOCKER_PORTS="${DOCKER_PORTS} ${DOCKER_HOST_TO_MONGODB_PORT_MAP}"

###----------------------------------------------------------
## Data volumes configuration
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/docker-container-volumes-cfg.sh


###----------------------------------------------------------
## Dockerfile build image configuration
###----------------------------------------------------------
local DOCKER_BLD_TIMESTAMP=$(date +%Y%m%d_%H%M)

local DOCKER_BLD_MAINTAINER='"skillplot"'


