#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

username=$1

curl -H "Authorization: token $(cat ~/.cred/github.${username})" https://api.github.com/user

GH_CONFIG_DIR=~/.config/gh-${username} \
  gh auth login --hostname github.com --git-protocol ssh --with-token < ~/.cred/github.${username}
