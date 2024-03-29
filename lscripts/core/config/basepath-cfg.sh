#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Basepath defines the absolute paths, and all the absolute path
## configuration must be defined here and no-where else.
## In all other scripts, uses these basebath configurations.
#
## ROOTs are actual directory, whereas HOMEs are symlinks to ROOTs
## This allows to distribute the data on remote storage plug-n-play.
##
# lscripts/banners
# lscripts/config
# lscripts/deprecated
# lscripts/logs
# lscripts/partials
# lscripts/snippets
# lscripts/tests
# lscripts/utils
# lscripts/wip
##
# local _LSD__COMMON=""
# local _LSD__APPS=""
# local _LSD__LSCRIPTS=""
# local _LSD__TFRECORDS=""
# local _LSD__WWW_LOGS=""
# local _LSD__IS_TIMESTAMP_DATA_DIR=""
##
#
## References:
## https://stackoverflow.com/questions/19724531/how-to-remove-all-non-numeric-characters-from-a-string-in-bash
###----------------------------------------------------------


local _LSD__BASENAME="${LSCRIPTS__BASENAME}"
local _LSD__BASENAME_OS="${LSCRIPTS__BASENAME_OS}"
local _LSD__ROOT="${LSCRIPTS__ROOT}"
local _LSD__CODEHUB_ROOT="${LSCRIPTS__CODEHUB_ROOT}"
local _LSD__DATAHUB_ROOT="${LSCRIPTS__DATAHUB_ROOT}"
local _LSD__AIMLHUB_ROOT="${LSCRIPTS__AIMLHUB_ROOT}"
declare -A _LSD__ENVVARS=()
##----
local _LSD__BASHRC_FILE="${LSCRIPTS__BASHRC_FILE}"
[[ ! -z "${_LSD__BASHRC_FILE}" ]] || _LSD__BASHRC_FILE="$HOME/.bashrc"

##----
[[ ! -z "${_LSD__BASENAME}" ]] || _LSD__BASENAME="lsdhub"
[[ ! -z "${_LSD__BASENAME_OS}" ]] || _LSD__BASENAME_OS="lsdos"

[[ ! -z "${_LSD__ROOT}" ]] || _LSD__ROOT="/codehub"
# [[ ! -z "${_LSD__ROOT}" ]] || _LSD__ROOT="${HOME}"

[[ ! -z "${_LSD__CODEHUB_ROOT}" ]] || _LSD__CODEHUB_ROOT="/codehub"
[[ ! -z "${_LSD__DATAHUB_ROOT}" ]] || _LSD__DATAHUB_ROOT="/datahub"
# [[ ! -z "${_LSD__WORKSPACE_ROOT}" ]] || _LSD__WORKSPACE_ROOT="/workspace"
[[ ! -z "${_LSD__AIMLHUB_ROOT}" ]] || _LSD__AIMLHUB_ROOT="${_LSD__CODEHUB_ROOT}/aihub"

## only alpha-numeric values are allowed
_LSD__BASENAME=$(tr -dc '0-9a-zA-Z' <<< "${_LSD__BASENAME}")
_LSD__ROOT=${_LSD__ROOT%/}
local _LSD__HOME="${_LSD__ROOT}/${_LSD__BASENAME}"
# _LSD__ROOT="${_LSD__ROOT}/${_LSD__BASENAME}"

##----
local _LSD__VM_ROOT=${_LSD__ROOT}/virtualmachines
local _LSD__OS_ROOT="${_LSD__ROOT}/${_LSD__BASENAME_OS}"
##----
local _LSD__CONFIG_ROOT="${_LSD__ROOT}/${_LSD__BASENAME}-config"
local _LSD__DATA_ROOT="${_LSD__ROOT}/${_LSD__BASENAME}-dat"
local _LSD__MOBILE_ROOT="${_LSD__ROOT}/${_LSD__BASENAME}-mobile"
##----
## home variables
local _LSD__VM_HOME="${LSCRIPTS__VMHOME}"
## local _LSD__PYVENV_HOME="${LSCRIPTS__PYVENV_HOME}"
local _LSD__PYVENV_PATH="${LSCRIPTS__PYVENV_PATH}"
local _LSD__PYCONDA_PATH="${LSCRIPTS__PYCONDA_PATH}"
local _LSD__WSGIPYTHONPATH="${LSCRIPTS__WSGIPYTHONPATH}"
local _LSD__WSGIPYTHONHOME="${LSCRIPTS__WSGIPYTHONHOME}"
local _LSD__ANDROID_HOME="${LSCRIPTS__ANDROID_HOME}"
local _LSD__APACHE_HOME="${LSCRIPTS__APACHE_HOME}"
local _LSD__WWW_HOME="${LSCRIPTS__WWW_HOME}"
local _LSD__DOWNLOADS_HOME="${LSCRIPTS__DOWNLOADS}"
local _LSD__EXTERNAL_HOME="${LSCRIPTS__EXTERNAL_HOME}"
##----
local _LSD__BIN_HOME
local _LSD__CONFIG_HOME
local _LSD__DATA_HOME
local _LSD__LOGS_HOME
local _LSD__MOBILE_HOME
local _LSD__TMP_HOME
#
[[ ! -z "${_LSD__BIN_HOME}" ]] || _LSD__BIN_HOME="${_LSD__HOME}/bin"
[[ ! -z "${_LSD__CONFIG_HOME}" ]] || _LSD__CONFIG_HOME="${_LSD__HOME}/config"
[[ ! -z "${_LSD__DATA_HOME}" ]] || _LSD__DATA_HOME="${_LSD__HOME}/data"
[[ ! -z "${_LSD__LOGS_HOME}" ]] || _LSD__LOGS_HOME="${_LSD__HOME}/logs"
[[ ! -z "${_LSD__MOBILE_HOME}" ]] || _LSD__MOBILE_HOME="${_LSD__HOME}/mobile"
[[ ! -z "${_LSD__TMP_HOME}" ]] || _LSD__TMP_HOME="${_LSD__HOME}/tmp"
[[ ! -z "${_LSD__WWW_HOME}" ]] || _LSD__WWW_HOME="${_LSD__HOME}/www"
[[ ! -z "${_LSD__VM_HOME}" ]] || _LSD__VM_HOME="${_LSD__HOME}/virtualmachines"
##----
[[ ! -z "${_LSD__PYVENV_PATH}" ]] || _LSD__PYVENV_PATH="${_LSD__VM_HOME}/virtualenvs"
[[ ! -z "${_LSD__WSGIPYTHONPATH}" ]] || _LSD__WSGIPYTHONPATH=""
[[ ! -z "${_LSD__WSGIPYTHONHOME}" ]] || _LSD__WSGIPYTHONHOME=""
[[ ! -z "${_LSD__ANDROID_HOME}" ]] || _LSD__ANDROID_HOME="${_LSD__MOBILE_HOME}/android/sdk"
[[ ! -z "${_LSD__APACHE_HOME}" ]] || _LSD__APACHE_HOME="${_LSD__DATA_HOME}/public_html"
[[ ! -z "${_LSD__DOWNLOADS_HOME}" ]] || _LSD__DOWNLOADS_HOME="${_LSD__DATA_HOME}/downloads"
## BASEPATH is deprecated and it is replaced with _LSD__EXTERNAL_HOME
## [[ ! -z "${BASEPATH}" ]] || BASEPATH="${_LSD__DATA_HOME}/external" ## deprecated, instead use _LSD__BASEPATH
[[ ! -z "${_LSD__EXTERNAL_HOME}" ]] || _LSD__EXTERNAL_HOME="${_LSD__DATA_HOME}/external"
##----
## Data roots
local _LSD__AID=${_LSD__DATA_ROOT}/aid
local _LSD__ANT=${_LSD__DATA_ROOT}/ant

## local _LSD__AUTH=${_LSD__DATA_ROOT}/auth
## authentication base directory is now configurable
local _LSD__AUTH=${LSCRIPTS__AUTH}
[[ ! -z "${_LSD__AUTH}" ]] || _LSD__AUTH="${_LSD__DATA_ROOT}/auth"
local _LSD__AUTH_PVT=${_LSD__AUTH}/.ssh

local _LSD__ROS=${_LSD__DATA_ROOT}/catkin_ws
local _LSD__CFG=${_LSD__DATA_ROOT}/cfg
local _LSD__CLOUD=${_LSD__DATA_ROOT}/cloud
local _LSD__DATABASE=${_LSD__DATA_ROOT}/databases
local _LSD__DOCKER=${_LSD__DATA_ROOT}/docker
local _LSD__DOCS=${_LSD__DATA_ROOT}/docs
local _LSD__DOWNLOADS=${_LSD__DATA_ROOT}/downloads
local _LSD__DIST=${_LSD__DATA_ROOT}/dist
local _LSD__EXTERNAL=${_LSD__DATA_ROOT}/external
local _LSD__KBANK=${_LSD__DATA_ROOT}/kbank
local _LSD__LOGS=${_LSD__DATA_ROOT}/logs
local _LSD__MOBILE=${_LSD__DATA_ROOT}/mobile
local _LSD__NPM=${_LSD__DATA_ROOT}/node_modules
local _LSD__PIP=${_LSD__DATA_ROOT}/pip
local _LSD__PRACTICE=${_LSD__DATA_ROOT}/practice
local _LSD__PUBLIC=${_LSD__DATA_ROOT}/public
local _LSD__PLUGINS=${_LSD__DATA_ROOT}/plugins
local _LSD__WWW=${_LSD__DATA_ROOT}/public_html
local _LSD__RELEASE=${_LSD__DATA_ROOT}/release
local _LSD__REPORTS=${_LSD__DATA_ROOT}/reports
local _LSD__RUBY=${_LSD__DATA_ROOT}/ruby
local _LSD__SAMPLES=${_LSD__DATA_ROOT}/samples
local _LSD__SITE=${_LSD__DATA_ROOT}/_site
local _LSD__TOOLS=${_LSD__DATA_ROOT}/tools
local _LSD__UPLOADS=${_LSD__DATA_ROOT}/uploads
local _LSD__WORKSPACE=${_LSD__DATA_ROOT}/workspaces
##----
local _LSD__3DMODELS=${_LSD__DATA_ROOT}/3dmodels
local _LSD__EBOOKSLIB=${_LSD__DATA_ROOT}/ebookslib
local _LSD__PHOTOGRAMMETRY=${_LSD__DATA_ROOT}/photogrammetry
local _LSD__REF=${_LSD__DATA_ROOT}/ref
local _LSD__SOFTWARES=${_LSD__DATA_ROOT}/softwares
local _LSD__TEAM=${_LSD__DATA_ROOT}/team
local _LSD__TECHNOTES=${_LSD__DATA_ROOT}/technotes
local _LSD__TECHNOTES_RESEARCH=${_LSD__DATA_ROOT}/technotes-research
##----
## Docker specific configuration
local _LSD__DOCKER_HUB_REPO="skillplot/boozo"
##
local _LSD__DOCKER_BASENAME="${_LSD__BASENAME}"
local _LSD__DOCKER_ROOT="${_LSD__ROOT}"
local _LSD__DOCKER_CONFIG_ROOT__="${_LSD__CONFIG_ROOT}"
local _LSD__DOCKER_DATA_ROOT="${_LSD__DATA_ROOT}"
local _LSD__DOCKER_MOBILE_ROOT="${_LSD__MOBILE_ROOT}"
local _LSD__DOCKER_OS_ROOT="${_LSD__OS_ROOT}"
local _LSD__DOCKER_VM_ROOT="${_LSD__VM_ROOT}"
local _LSD__DOCKER_DATAHUB_ROOT="${_LSD__DATAHUB_ROOT}"
# local _LSD__DOCKER_WORKSPACE_ROOT="${_LSD__WORKSPACE_ROOT}"

## local _LSD__DOCKER_VM_HOME="${_LSD__VM_HOME}"
##
[[ ! -z "${_LSD__DOCKER_BASENAME}" ]] || _LSD__DOCKER_BASENAME="lscripts"
[[ ! -z "${_LSD__DOCKER_ROOT}" ]] || _LSD__DOCKER_ROOT="/${_LSD__DOCKER_BASENAME}-hub"
[[ ! -z "${_LSD__DOCKER_CONFIG_ROOT__}" ]] || _LSD__DOCKER_CONFIG_ROOT__="${_LSD__ROOT}/${_LSD__DOCKER_BASENAME}-config"
[[ ! -z "${_LSD__DOCKER_DATA_ROOT}" ]] || _LSD__DOCKER_DATA_ROOT="${_LSD__ROOT}/${_LSD__DOCKER_BASENAME}-dat"
[[ ! -z "${_LSD__DOCKER_MOBILE_ROOT}" ]] || _LSD__DOCKER_MOBILE_ROOT="${_LSD__ROOT}/${_LSD__DOCKER_BASENAME}-mobile"
[[ ! -z "${_LSD__DOCKER_OS_ROOT}" ]] || _LSD__DOCKER_OS_ROOT="${_LSD__ROOT}/${_LSD__DOCKER_BASENAME}-os"
[[ ! -z "${_LSD__DOCKER_VM_ROOT}" ]] || _LSD__DOCKER_VM_ROOT="${_LSD__ROOT}/virtualmachines"
[[ ! -z "${_LSD__DOCKER_AIHUB_ROOT}" ]] || _LSD__DOCKER_AIHUB_ROOT="${_LSD__ROOT}/aihub"
[[ ! -z "${_LSD__DOCKER_AILAB_ROOT}" ]] || _LSD__DOCKER_AILAB_ROOT="${_LSD__ROOT}/ailab"
[[ ! -z "${_LSD__DOCKER_EXTERNAL_ROOT}" ]] || _LSD__DOCKER_EXTERNAL_ROOT="${_LSD__ROOT}/external"
[[ ! -z "${_LSD__DOCKER_DATAHUB_ROOT}" ]] || _LSD__DOCKER_DATAHUB_ROOT="/datahub"
##----
## This directory is the home directory for the root user
local _LSD__OS_USR_ROOT=${_LSD__OS_ROOT}/root
## This directory should hold those shared libraries that are necessary to boot the system and to run the commands in the root filesystem
local _LSD__OS_LIB=${_LSD__OS_ROOT}/lib
## Source code for locally installed software.
local _LSD__OS_SRC=${_LSD__OS_ROOT}/src
## Documentation about installed programs
local _LSD__OS_DOC=${_LSD__OS_ROOT}/doc
## Locale information goes here
local _LSD__OS_LOCALE=${_LSD__OS_ROOT}/locale
## Include files for the C compiler.
local _LSD__OS_INCLUDE=${_LSD__OS_ROOT}/include
## On  machines  with  home  directories  for  users, these are usually beneath this directory, directly or not
local _LSD__OS_USR_HOME=${_LSD__OS_ROOT}/home
## Special or device files, which refer to physical devices
local _LSD__OS_DEV=${_LSD__OS_ROOT}/dev
## This  directory  is  a  mount point for a temporarily mounted filesystem.  In some dist ributions, /mnt contains subdirectories intended to be used as mount points for several temporary filesystems.
local _LSD__OS_MNT=${_LSD__OS_ROOT}/mnt
## This directory contains temporary files which may be deleted with no notice, such as by a regular job or at system boot up.
local _LSD__OS_TMP=${_LSD__OS_ROOT}/tmp
## This directory contains executable programs which are needed in single user mode and to bring the system up or repair it.
local _LSD__OS_BIN=${_LSD__OS_ROOT}/bin
## Contains configuration files which are local to the machine.  Some larger software packages, can have their own subdirectories below `etc`. Programs should always look for these files in `etc`.
local _LSD__OS_ETC=${_LSD__OS_ROOT}/etc
## This directory contains subdirectories with specific application data, that can be shared among different architectures of the same OS
local _LSD__OS_SHARE=${_LSD__OS_ROOT}/share
## This directory contains files which may change in size, such as spool and log files.
local _LSD__OS_VAR=${_LSD__OS_ROOT}/var
## Logs directory
local _LSD__OS_LOGS=${_LSD__OS_ROOT}/logs
## Data cached for programs.
local _LSD__OS_CACHE=${_LSD__OS_ROOT}/cache
## System crash dumps
local _LSD__OS_CRASH=${_LSD__OS_ROOT}/crash
## Lock files are placed in this directory.  The naming convention for device lock files is LCK..<device> where <device> is the device's name in the filesystem.  The format used  is  that of HDU UUCP lock files, that is, lock files contain a PID as a 10-byte ASCII decimal number, followed by a newline character.
local _LSD__OS_LOCK=${_LSD__OS_ROOT}/lock
## Spooled (or queued) files for various programs
local _LSD__OS_SPOOL=${_LSD__OS_ROOT}/spool
##----
declare -a _LSD__OS_DIRS=(
  "root"
  "lib"
  "src"
  "doc"
  "external"
  "locale"
  "include"
  "home"
  "dev"
  "mnt"
  "tmp"
  ".trash"
  "bin"
  "etc"
  "share"
  "var"
  "logs"
  "cache"
  "crash"
  "lock"
  "opt"
  "spool"
)

declare -a _LSD__DATA_DIRS=(
  "aid"
  "aid/tfrecords"
  "ant"
  "ant/tfrecords"
  "auth"
  "auth/.ssh"
  "auth/.ssh.pub"
  "catkin_ws"
  "cfg"
  "cfg/arch"
  "cfg/dataset"
  "cfg/model"
  "cfg/model/release"
  "cloud"
  "databases"
  "databases/mongodb"
  "databases/mongodb/db"
  "databases/mongodb/logs"
  "databases/mongodb/key"
  "databases/mongodb/configdb"
  "docker"
  "docs"
  "downloads"
  "dist"
  "external"
  "kbank"
  "logs"
  "logs/www"
  "logs/www/uploads"
  "mobile"
  "node_modules"
  "pip"
  "practice"
  "public"
  "plugins"
  "public_html"
  "release"
  "reports"
  "ruby"
  "samples"
  "_site"
  "tools"
  "uploads"
  "workspaces"
  "3dmodels"
  "ebookslib"
  "photogrammetry"
  "ref"
  "softwares"
  "tmp"
  "team"
  "technotes"
  "technotes-research"
)

declare -A _LSD__ENVVARS=()
declare -a _LSD__DATA_DIRS_PATHS=()
declare -a _LSD__OS_DIRS_PATHS=()

##----
local _LSD__OS_ALIAS_SH="${__LSCRIPTS_LOG_BASEDIR__}/lsdos.alias.sh"
local _LSD__DATA_ALIAS_SH="${__LSCRIPTS_LOG_BASEDIR__}/lsddata.alias.sh"
