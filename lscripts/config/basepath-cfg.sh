#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Basepath defines the absolute paths, and all the absolute path
## configuration must be defined here and no-where else.
## In all other scripts, uses these basebath configurations.
###----------------------------------------------------------

## Change the ROOT_BASEDIR and BASENAME to appropriate values
local ROOT_BASEDIR="${_BZO__ROOT}"
[[ ! -z "${ROOT_BASEDIR}" ]] || ROOT_BASEDIR="/boozo-hub"

local BASENAME="${_BZO__NAME}"
[[ ! -z "${BASENAME}" ]] || BASENAME="boozo"

##----
local BASEDIR="${_BZO__HOME}"
[[ ! -z "${BASEDIR}" ]] || BASEDIR="${ROOT_BASEDIR}/${BASENAME}"

local BASEPATH="${ROOT_BASEDIR}/data/external"
local ANDROID_HOME="${BASEDIR}/android/sdk"

local DOWNLOAD_PATH="${ROOT_BASEDIR}/data/downloads"

local BASHRC_FILE="${HOME}/.bashrc"
local USER_BASHRC_FILE="${HOME}/.bashrc"
local CUSTOM_EXPORT_FILE="${ROOT_BASEDIR}/config/export.custom.sh"

local APACHE_HOME="${ROOT_BASEDIR}/data/public_html"

local VM_HOME="${ROOT_BASEDIR}/virtualmachines"
local PY_VENV_PATH="${VM_HOME}/virtualenvs"

local PY_VIRTUALENVWRAPPER="virtualenvwrapper.sh"

local WSGIPYTHONPATH=""
local WSGIPYTHONHOME=""

local __DOCKER_CONFIG_ROOT__="${_BZO__CONFIG_ROOT}"
[[ ! -z "${__DOCKER_CONFIG_ROOT__}" ]] || __DOCKER_CONFIG_ROOT__="${ROOT_BASEDIR}/${BASENAME}-dat"

local DOCKER_VM_ROOT="${_BZO__VMHOME}"
[[ ! -z "${DOCKER_VM_ROOT}" ]] || DOCKER_VM_ROOT="${ROOT_BASEDIR}/virtualmachines"


local DOCKER_DATA_ROOT="${_BZO__DATA_ROOT}"
[[ ! -z "${DOCKER_DATA_ROOT}" ]] || DOCKER_DATA_ROOT="${ROOT_BASEDIR}/${BASENAME}-dat"

local DOCKER_MOBILE_ROOT="${_BZO__MOBILE_ROOT}"
[[ ! -z "${DOCKER_MOBILE_ROOT}" ]] || DOCKER_MOBILE_ROOT="${ROOT_BASEDIR}/${BASENAME}-mobile"

local DOCKER_ROOT_BASEDIR="${ROOT_BASEDIR}"

local DOCKER_HUB_REPO="skillplot/boozo"

##
declare -A __LSCRIPTS_ENVVARS__=()

