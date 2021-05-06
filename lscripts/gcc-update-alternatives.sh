#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gcc, g++ multiple version configuration
###----------------------------------------------------------
#
## -DCMAKE_C_COMPILER=/usr/bin/gcc-6 -DCMAKE_CXX_COMPILER=/usr/bin/g++-6
## https://stackoverflow.com/questions/39854114/set-gcc-version-for-make-in-shell
## make CC=gcc-4.4 CPP=g++-4.4 CXX=g++-4.4 LD=g++-4.4
#
## * https://codeyarns.com/2015/02/26/how-to-switch-gcc-version-using-update-alternatives/
#
### Alternative to update-alternative options is to create sym link
### I preferred update-alternatives option
#
###----------------------------------------------------------
## sudo ln -s /usr/bin/gcc-5 /usr/local/cuda/bin/gcc 
## sudo ln -s /usr/bin/g++-5 /usr/local/cuda/bin/g++
###----------------------------------------------------------

# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 100 --slave /usr/bin/g++ g++ /usr/bin/g++-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 150 --slave /usr/bin/g++ g++ /usr/bin/g++-6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 200 --slave /usr/bin/g++ g++ /usr/bin/g++-7
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 250 --slave /usr/bin/g++ g++ /usr/bin/g++-8
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 300 --slave /usr/bin/g++ g++ /usr/bin/g++-9
sudo update-alternatives --config gcc
