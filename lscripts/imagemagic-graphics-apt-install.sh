#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## imagemagick
###----------------------------------------------------------
#
## References:
## * https://www.theshell.guru/install-imagemagick-ubuntu-16-04/
###----------------------------------------------------------


## Don't remove image magic - imagemagick may be a dependency for other pieces of software run
## sudo apt remove --purge imagemagick
apt-cache showpkg imagemagick
sudo apt -y update
sudo apt -y install imagemagick
## for php
sudo apt -y install php-imagick
