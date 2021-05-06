#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## vulkan - by kronos group, opensource alternative for CUDA
###----------------------------------------------------------
#
## References:
## * https://vulkan.lunarg.com/sdk/home
###----------------------------------------------------------


function vulkansdk-apt-install() {
  wget -qO - http://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo apt-key add -
  sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.1.130-bionic.list http://packages.lunarg.com/vulkan/1.1.130/lunarg-vulkan-1.1.130-bionic.list
  sudo apt -y update
  sudo apt -y install vulkan-sdk
}

vulkansdk-apt-install
