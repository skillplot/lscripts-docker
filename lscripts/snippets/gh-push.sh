#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

username=$1
reponame=$2

# curl -H "Authorization: token $(cat ~/.cred/github.${username})" https://api.github.com/user

# GH_CONFIG_DIR=~/.config/gh-${username} \
#   gh auth login --hostname github.com --git-protocol ssh --with-token < ~/.cred/github.${username}

## git remote set-url origin git@github.com:${username}/${reponame}.git
git remote set-url origin https://${username}@github.com/${username}/${reponame}.git

GH_CONFIG_DIR=~/.config/gh-${username} git push
