#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## VLC
###----------------------------------------------------------


# sudo apt -y update
sudo apt -y install vlc browser-plugin-vlc

# VLC hacks

##----------------------------------------------------------
### Opening the CAM out of the box
##----------------------------------------------------------
# vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio
