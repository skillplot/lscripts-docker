#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gcc upadate alternatives
###----------------------------------------------------------
## Ubuntu 18.04 LTS
## gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
###----------------------------------------------------------
# # so to fix this, just make gcc6 available
# # first install gcc6 and g++6
# sudo apt install -y gcc-6 g++-6
# # next, link them into your cuda stack
# sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc 
# sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++


# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 10 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 20 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 30 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 --slave /usr/bin/g++ g++ /usr/bin/g++-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 100 --slave /usr/bin/g++ g++ /usr/bin/g++-6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 200 --slave /usr/bin/g++ g++ /usr/bin/g++-7
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-8
sudo update-alternatives --config gcc
