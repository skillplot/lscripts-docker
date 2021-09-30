#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

## create the external directory, inside this clone the official nividia container file repo
mkdir -p external
git clone https://gitlab.com/nvidia/container-images/cuda.git $PWD/external/cuda
##
# printf "y" | bash docker-buildimg-cuda.sh 10.0
