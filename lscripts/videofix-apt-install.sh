#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## How to Enable Ubuntu 18.04 LTS to Play Videos Files
#
## References:
## * https://websiteforstudents.com/how-to-enable-ubuntu-18-04-lts-beta-to-play-videos-files/
###----------------------------------------------------------


# sudo apt -y update
sudo apt -y install libdvdnav4 libdvd-pkg gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvd-pkg
sudo apt -y install ubuntu-restricted-extras
sudo apt -y install libavcodec57

sudo apt install libdvdnav4 libdvdread4 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvd-pkg
sudo apt install ubuntu-restricted-extras

# sudo dpkg-reconfigure libdvd-pkg


# │                                                                                                                                                                                                 │ 
# │ This package automates the process of launching downloads of the source files for libdvdcss2 from videolan.org, compiling them, and installing the binary packages (libdvdcss2 libdvdcss-dev).  │ 
# │                                                                                                                                                                                                 │ 
# │ Please run "sudo dpkg-reconfigure libdvd-pkg" to launch this process for the first time.

# │ If activated, the APT post-invoke hook takes care of future automatic upgrades of libdvdcss2 (which may be triggered by new versions of libdvd-pkg). When updates are available, the hook will   │ 
# │ launch the process of downloading the source, recompiling it, and (if "apt-get check" reports no errors) using "dpkg -i" to install the new versions.                                            │ 
# │                                                                                                                                                                                                  │ 
# │ Alternatively, the process can be launched manually by running "sudo dpkg-reconfigure libdvd-pkg".                                                                                               │ 
# │                                                                                                                                                                                                  │ 
# │ Enable automatic upgrades for libdvdcss2?                                                                                                                                                        │ 
# │                                            

# Configuring ttf-mscorefonts-installer