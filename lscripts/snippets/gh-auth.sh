#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


curl -H "Authorization: token $(cat ~/.cred/github.$1)" https://api.github.com/user

GH_CONFIG_DIR=~/.config/gh-$1 \
  gh auth login --hostname github.com --git-protocol ssh --with-token < ~/.cred/github.$1

