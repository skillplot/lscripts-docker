#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

username=$1
reponame=$2

GH_CONFIG_DIR=~/.config/gh-${username} gh repo view ${username}/${reponame}
