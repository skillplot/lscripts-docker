#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## configuration for nvidia driver and
## cuda versions required for system setup
#
## NOTE:
## - Last one is what is used if not commented#
###----------------------------------------------------------

###----------------------------------------------------------
## Nvidia GPU Driver
###----------------------------------------------------------
local NVIDIA_DRIVER_VER="387.22"
local NVIDIA_DRIVER_VER="390.42"
local NVIDIA_DRIVER_VER="390"

## default value for Ubuntu-18.04 LTS, CUDA 10 and tf 1.14 works with this version
## driver version 430  is not avaiable in apt repo by default, if required install it separately

## For CUDA 10.0 minimum nvidia driver requirement
local NVIDIA_DRIVER_VER="410"
local NVIDIA_DRIVER_VER="430"
local NVIDIA_DRIVER_VER="435"
local NVIDIA_DRIVER_VER="440"
local NVIDIA_DRIVER_VER="450"

## For Ubuntu (>= 17.04)
# local NVIDIA_DRIVER_INSTALLED=$(prime-select query)

###----------------------------------------------------------
## Nvidia Container Images Repo - custom build
###----------------------------------------------------------
local NVIDIA_DOCKER_CUDA_REPO_URL="https://gitlab.com/nvidia/container-images/cuda"

###----------------------------------------------------------
## Nvidia Container Toolkit
###----------------------------------------------------------
local NVIDIA_DOCKER_URL="https://nvidia.github.io/nvidia-docker"
local NVIDIA_DOCKER_KEY_URL="${NVIDIA_DOCKER_URL}/gpgkey"
