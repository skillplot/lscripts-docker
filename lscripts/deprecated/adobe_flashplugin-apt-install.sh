#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install utilities and softwares
## Tested on Ubuntu 18.04 LTS
## Installing Adobe Flash Player and Plugin for browser
#
## References:
## https://websiteforstudents.com/installing-the-latest-flash-player-on-ubuntu-17-10/
###----------------------------------------------------------


sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt -y update
sudo apt -y install adobe-flashplugin browser-plugin-freshplayer-pepperflash
