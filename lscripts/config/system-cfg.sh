#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## system constants
##----------------------------------------------------------


local NUMTHREADS=1
[[ -f /sys/devices/system/cpu/online ]] && NUMTHREADS=$(( ( $(cut -f 2 -d '-' /sys/devices/system/cpu/online) + 1 ) * 15 / 10  ))

local MACHINE_ARCH=$(uname -m)

local USER_ID=$(id -u)
local GRP_ID=$(id -g)

## used to configure default permission on localhost/host (non-docker)
local USR=$(id -un)
local GRP=$(id -gn)

local LOCAL_HOST=$(hostname)

## example: Linux, Darwin
local OSTYPE=$(uname -s)
## example: x86_64
## note:: x86_64 is amd64
local OS_ARCH=$(uname -m)
## example: 64
local OS_ARCH_BIT=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

local LINUX_VERSION
local LINUX_CODE_NAME
local LINUX_ID
local LINUX_DISTRIBUTION

## In some distro lsb_release command is not installed
## References: https://nvidia.github.io/nvidia-container-runtime/

## example: 16.04, 18.04
type lsb_release &>/dev/null && LINUX_VERSION="$(lsb_release -sr)" || {
  LINUX_VERSION=$(. /etc/os-release;echo ${VERSION_ID})
}
## example: xenial, bionic
type lsb_release &>/dev/null && LINUX_CODE_NAME="$(lsb_release -sc)"
## example: Ubuntu, Kali
type lsb_release &>/dev/null && LINUX_ID="$(lsb_release -si)" || {
  LINUX_ID=$(. /etc/os-release;echo ${ID})
}
## example: ubuntu16.04, ubuntu18.04, debian8
LINUX_DISTRIBUTION=$(. /etc/os-release;echo ${ID}${VERSION_ID})
## hack to install nvidia-container-toolkit on Kali Linux
[[ "${LINUX_DISTRIBUTION}" == 'kali' ]] && LINUX_DISTRIBUTION="ubuntu18.04"

## example: ubuntu1604, ubuntu1804;; this is required for nvidia cuda repo url
local LINUX_DISTRIBUTION_TR=${LINUX_DISTRIBUTION//./}
