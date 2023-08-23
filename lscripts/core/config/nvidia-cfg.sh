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
## default value for Ubuntu-18.04 LTS, CUDA 10.0 and tf 1.14 works with this version
## driver version 430  is not avaiable in apt repo by default, if required install it separately
#
## For CUDA 10.0 minimum nvidia driver required
local NVIDIA_DRIVER_VER="410"
## For CUDA 10.2 minimum nvidia driver required
local NVIDIA_DRIVER_VER="430"
local NVIDIA_DRIVER_VER="435"
## For CUDA 11.0 minimum nvidia driver required.
local NVIDIA_DRIVER_VER="440"
local NVIDIA_DRIVER_VER="450"
local NVIDIA_DRIVER_VER="460"
local NVIDIA_DRIVER_VER="465"
local NVIDIA_DRIVER_VER="510"
## For CUDA 11.8 minimum driver required
local NVIDIA_DRIVER_VER="525"
## For CUDA 12.1 minimum driver required
local NVIDIA_DRIVER_VER="535"
##
local NVIDIA_OS_ARCH="x86_64"
local NVIDIA_CUDA_REPO_KEY="3bf863cc.pub"
local NVIDIA_ML_REPO_KEY="7fa2af80.pub"
## local NVIDIA_GPGKEY_SUM="d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5"
## local NVIDIA_GPGKEY_FPR="ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80"
#
## Example: open these URL in the browser to check if they are valid are not
### ubuntu1804
## cuda repo: https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
## ML repo: https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
### ubuntu2004
## cuda repo: https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
## ML repo: https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub
local NVIDIA_REPO_BASEURL="https://developer.download.nvidia.com/compute"
## https://developer.download.nvidia.com/compute/machine-learning/repos
local NVIDIA_CUDA_REPO_BASEURL="${NVIDIA_REPO_BASEURL}/cuda/repos"
## https://developer.download.nvidia.com/compute/machine-learning/repos/
local NVIDIA_ML_REPO_BASEURL="${NVIDIA_REPO_BASEURL}/machine-learning/repos"
#
## For Ubuntu (>= 17.04)
# local NVIDIA_DRIVER_INSTALLED=$(prime-select query)
#
## Nvidia Container Images Repo - custom build
local NVIDIA_DOCKER_CUDA_REPO_URL="https://gitlab.com/nvidia/container-images/cuda"
#
## Nvidia Container Toolkit
local NVIDIA_DOCKER_URL="https://nvidia.github.io/nvidia-docker"
local NVIDIA_DOCKER_KEY_URL="${NVIDIA_DOCKER_URL}/gpgkey"
