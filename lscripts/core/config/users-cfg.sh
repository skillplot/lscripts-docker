#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## User configuration
###----------------------------------------------------------

## HUSER::host user used during creating of the docker container
local HUSER=${USER}
local HUSER_ID=$(id -u ${HUSER})
local HUSER_GRP=$(id -gn ${HUSER})
local HUSER_GRP_ID=$(id -g ${HUSER})
local HUSER_HOME="/home/${HUSER}"

[[ "${HUSER}" == "root" ]] && HUSER_HOME="/root"

## AUSER::application user are system level user for application management
local AUSER="boozo"
local AUSER_GRP="boozo"
