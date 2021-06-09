#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## mount samba drive
###----------------------------------------------------------
##
#sudo apt install nfs-common
#sudo apt install smb4k
#sudo apt install cifs-utils
#
## References
## * https://serverfault.com/questions/414074/mount-cifs-host-is-down
## if `vers=1.0` is not provided in `Ubuntu 18.04 LTS` it throws _log_.error `host is down`
#
## * https://unix.stackexchange.com/questions/68079/mount-cifs-network-drive-write-permissions-and-chown
## sudo mount -t cifs //server-address/folder /mount/path/on/ubuntu -o username=${USER},password=${PASSWORD},uid=$(id -u),gid=$(id -g)
#
## TBD: mount _log_.error handling
## mount error(16): Device or resource busy
## * https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script
###----------------------------------------------------------


function mount.smb.main() {
  local IP=$1
  local USERNAME=$2
  ## SHARED_DIR_NAME is not the name of the folder on the file system, rather the shared folder name
  local SHARED_DIR_NAME=$3
  local MNT_DIR=$4
  local DOMAIN=$5

  [[ -d ${MNT_DIR} ]] || mkdir -p ${MNT_DIR}

  sudo mount -t cifs //"${IP}"/"${SHARED_DIR_NAME}" "${MNT_DIR}" -o username="${USERNAME}",domain="${DOMAIN}",uid=$(id -u),gid=$(id -g),vers=1.0

  echo "Successfully mounted at: ${MNT_DIR}"
  echo "changing to mounted dir..."
  echo ""
  echo "For unmounting execute: "
  echo "sudo umount ${MNT_DIR}"
  echo "Have Fun!"

  cd "${MNT_DIR}"
  # sudo umount ${MNT_DIR}
}

mount.smb.main $1 $2 $3 $4 $5
