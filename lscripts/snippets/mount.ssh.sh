#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## mount filesystem using sshfs
###----------------------------------------------------------
#
## References:
## * https://stackoverflow.com/questions/20271101/what-happens-if-you-mount-to-a-non-empty-mount-point-with-fuse
## * https://sourceforge.net/p/fuse/mailman/message/29929087/
## The solution is to add an ending slash to the remote path:
##
## Usage/Example:
## `sudo sshfs -o transform_symlinks,nonempty,${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${remote_user}@${remote_ip}:${remote_path}/ ${local_path}`
###----------------------------------------------------------


function mount.ssh.main() {
  local remote_ip
  local remote_user
  echo "Enter the REMOTE system IP:"
  read remote_ip
  remote_ip="${remote_ip}"
  echo "remote_ip: ${remote_ip}"

  echo "Enter the REMOTE system USER name:"
  read remote_user
  echo "remote_user: ${remote_user}"

  # info_remotepaths
  local remote_path
  echo "Enter the REMOTE path you want to mount:"
  read remote_path

  local local_path=${remote_path}
  echo "local mount path will be: ${local_path}"

  local mode
  echo "Enter the mode: [rw | ro]"
  read mode
  echo "mode: ${mode}"

  if [[ ${mode} == 'rw' ]]; then
    echo "CAREFUL: mounting in write mode, any deletion will delete it from the remote system!!!"
  fi

  echo "Mouting...using the following command:"
  echo "sudo sshfs -o transform_symlinks,nonempty,${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${remote_user}@${remote_ip}:${remote_path}/ ${local_path}"

  sudo sshfs -o transform_symlinks,nonempty,${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${remote_user}@${remote_ip}:${remote_path}/ ${local_path}

}

mount.ssh.main
