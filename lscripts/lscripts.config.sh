#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## lscripts configuration compatible with docker
## NOTE:
## - Do NOT change the order of the source scripts or variable names
###----------------------------------------------------------
#
## References:
## * https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
###----------------------------------------------------------


local __LSCRIPTS_HOME__=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
local __LSCRIPTS_LOG_BASEDIR__="${__LSCRIPTS_HOME__}/logs"
mkdir -p "${__LSCRIPTS_LOG_BASEDIR__}"

source "${__LSCRIPTS_HOME__}/config/__init__.sh"
source "${__LSCRIPTS_HOME__}/_common_.sh"
