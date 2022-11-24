#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ssh key generation and management
##----------------------------------------------------------
## https://docs.gitlab.com/ee/ssh/index.html#generate-an-ssh-key-pair
## https://docs.gitlab.com/ee/ssh/index.html#configure-ssh-to-point-to-a-different-directory
## https://www.ssh.com/academy/ssh/passphrase
## https://docs.gitlab.com/ee/ssh/index.html#add-an-ssh-key-to-your-gitlab-account
## https://man.openbsd.org/ssh_config
###----------------------------------------------------------


function sshkeygen.remove() {
  local _ip=$1
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R "${_ip}"
}


## wip: work-in-progress
function sshkeygen.main() {
  ssh-keygen -t ed25519 -C "<comment>"
  # ssh-keygen -t rsa -b 2048 -C "<comment>"

  ## Generating public/private ed25519 key pair.
  ## Enter file in which to save the key (/home/user/.ssh/id_ed25519):
  ##
  ## Enter passphrase (empty for no passphrase):
  ## Enter same passphrase again:


  ## Configure SSH to point to a different directory
  ## https://man.openbsd.org/ssh_config
  eval $(ssh-agent -s)
  ssh-add <directory to private SSH key>

  ## Update your SSH key passphrase
  ssh-keygen -p -f /path/to/ssh_key


  ## Add an SSH key to your GitLab account
  ## macos
  # tr -d '\n' < ~/.ssh/id_ed25519.pub | pbcopy

  ## linux
  # sudo apt install xclip
  xclip -sel clip < ~/.ssh/id_ed25519.pub
}

sshkeygen.main
