#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Basepath defines the absolute paths, and all the absolute path
## configuration must be defined here and no-where else.
## In all other scripts, uses these basebath configurations.
###----------------------------------------------------------


local BASENAME="${_LSCRIPTS__NAME}"
[[ ! -z "${BASENAME}" ]] || BASENAME="lscripts"

##----
local __ROOT_BASEDIR__="${_LSCRIPTS__ROOT}"
[[ ! -z "${__ROOT_BASEDIR__}" ]] || __ROOT_BASEDIR__="/${BASENAME}-hub"

local __CONFIG_ROOT__="${_LSCRIPTS__CONFIG_ROOT}"
[[ ! -z "${__CONFIG_ROOT__}" ]] || __CONFIG_ROOT__="${__ROOT_BASEDIR__}/${BASENAME}-config"

local __DATA_ROOT__="${_LSCRIPTS__DATA_ROOT}"
[[ ! -z "${__DATA_ROOT__}" ]] || __DATA_ROOT__="${__ROOT_BASEDIR__}/${BASENAME}-dat"

local __MOBILE_ROOT__="${_LSCRIPTS__MOBILE_ROOT}"
[[ ! -z "${__MOBILE_ROOT__}" ]] || __MOBILE_ROOT__="${__ROOT_BASEDIR__}/${BASENAME}-mobile"

local __VM_ROOT__="${_LSCRIPTS__VM_ROOT}"
[[ ! -z "${__VM_ROOT__}" ]] || __VM_ROOT__="${__ROOT_BASEDIR__}/virtualmachines"

local __HOME_BASEDIR__="${_LSCRIPTS__HOME}"
local BASEDIR="${__HOME_BASEDIR__}"
[[ ! -z "${BASEDIR}" ]] || BASEDIR="${__ROOT_BASEDIR__}/${BASENAME}"


##----HOME variables, these are symlinks to Roots
local __CONFIG_HOME__="${BASEDIR}/config"
local __DATA_HOME__="${BASEDIR}/data"
local __LOGS_HOME__="${BASEDIR}/logs"
local __MOBILE_HOME__="${BASEDIR}/mobile"
local __TMP_HOME__="${BASEDIR}/tmp"
local __WWW_HOME__="${BASEDIR}/www"
local __VM_HOME__="${BASEDIR}/virtualmachines"

##----
local ANDROID_HOME="${_LSCRIPTS__ANDROID_HOME}"
[[ ! -z "${ANDROID_HOME}" ]] || ANDROID_HOME="${__MOBILE_HOME__}/android/sdk"

local APACHE_HOME="${_LSCRIPTS__APACHE_HOME}"
[[ ! -z "${APACHE_HOME}" ]] || APACHE_HOME="${__DATA_HOME__}/public_html"

local BASEPATH="${_LSCRIPTS__BASEPATH}"
[[ ! -z "${BASEPATH}" ]] || BASEPATH="${__DATA_HOME__}/external"

## local DOWNLOAD_PATH="${HOME}/Downloads"
local DOWNLOAD_PATH="${_LSCRIPTS__DOWNLOAD_PATH}"
[[ ! -z "${DOWNLOAD_PATH}" ]] || DOWNLOAD_PATH="${__DATA_HOME__}/downloads"

local PY_VENV_PATH="${_LSCRIPTS__PY_VENV_PATH}"
[[ ! -z "${PY_VENV_PATH}" ]] || PY_VENV_PATH="${__VM_ROOT__}/virtualenvs"

##----
local BASHRC_FILEPATH="${HOME}/.bashrc"
local USER_BASHRC_FILEPATH="${HOME}/.bashrc"
local LSCRIPTS_BASHRC_FILEPATH="${__CONFIG_HOME__}/dotfiles/.bashrc"
#
local LSCRIPTS_EXPORT_FILEPATH="${__CONFIG_HOME__}/lscripts.export.sh"
local CUSTOM_EXPORT_FILEPATH="${__CONFIG_HOME__}/custom.export.sh"

local PY_VIRTUALENVWRAPPER_FILE="virtualenvwrapper.sh"

local WSGIPYTHONPATH="${_LSCRIPTS__WSGIPYTHONPATH}"
[[ ! -z "${WSGIPYTHONPATH}" ]] || WSGIPYTHONPATH=""

local WSGIPYTHONHOME="${_LSCRIPTS__WSGIPYTHONHOME}"
[[ ! -z "${WSGIPYTHONHOME}" ]] || WSGIPYTHONHOME=""


##----
## Docker specific configurationlocal DOCKER_BASENAME="${BASENAME}"
[[ ! -z "${DOCKER_BASENAME}" ]] || DOCKER_BASENAME="lscripts"

local __DOCKER_ROOT_BASEDIR__="${__ROOT_BASEDIR__}"
[[ ! -z "${__DOCKER_ROOT_BASEDIR__}" ]] || __DOCKER_ROOT_BASEDIR__="/${DOCKER_BASENAME}-hub"

local __DOCKER_CONFIG_ROOT__="${__CONFIG_ROOT__}"
[[ ! -z "${__DOCKER_CONFIG_ROOT__}" ]] || __DOCKER_CONFIG_ROOT__="${__ROOT_BASEDIR__}/${DOCKER_BASENAME}-config"

local DOCKER_DATA_ROOT="${__DATA_ROOT__}"
[[ ! -z "${DOCKER_DATA_ROOT}" ]] || DOCKER_DATA_ROOT="${__ROOT_BASEDIR__}/${DOCKER_BASENAME}-dat"

local DOCKER_MOBILE_ROOT="${__MOBILE_ROOT__}"
[[ ! -z "${DOCKER_MOBILE_ROOT}" ]] || DOCKER_MOBILE_ROOT="${__ROOT_BASEDIR__}/${DOCKER_BASENAME}-mobile"

local DOCKER_VM_ROOT="${__VM_ROOT__}"
[[ ! -z "${DOCKER_VM_ROOT}" ]] || DOCKER_VM_ROOT="${__ROOT_BASEDIR__}/virtualmachines"


local DOCKER_HUB_REPO="skillplot/boozo"

##
declare -A __LSCRIPTS_ENVVARS__=()
