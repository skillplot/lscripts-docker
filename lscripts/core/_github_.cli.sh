#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _github_.cli functions - GitHub CLI wrapper
###----------------------------------------------------------
## @description: This script manages multiple user accounts on
## the same machine by creating symlinks for the selected profile
## and logging in or out.
###----------------------------------------------------------


## Install GitHub CLI
function lsd-mod.github.cli.install() {
  ## github client (gh)
  ## References
  ## * https://docs.github.com/en/github-cli/github-cli/quickstart
  ## * https://github.com/cli/cli/blob/trunk/docs/install_linux.md

  (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt -y update \
  && sudo apt -y install gh
}


function lsd-mod.github.cli.logout() {
  unset GH_TOKEN
  gh auth status
}


function lsd-mod.github.cli.login() {
  local username="$1"
  [ -f $HOME/.cred/github.${username} ] && {
    export GH_TOKEN=$(cat $HOME/.cred/github.${username})
    gh auth status
  }
}
