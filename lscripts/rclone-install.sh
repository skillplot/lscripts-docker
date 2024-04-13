#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Rclone - rsync for cloud storage
###----------------------------------------------------------
#
## References:
## * https://rclone.org/install/
## * https://github.com/rclone/rclone
#
## * https://www.ostechnix.com/how-to-mount-google-drive-locally-as-virtual-file-system-in-linux/
## * https://rclone.org/drive/#making-your-own-client-id
## * https://community.alteryx.com/t5/Alteryx-Designer-Knowledge-Base/How-to-Create-Google-API-Credentials/ta-p/11834
## * https://github.com/Cloudbox/Cloudbox/wiki/Google-Drive-API-Client-ID-and-Client-Secret

## * https://developers.google.com/drive/activity/v1/guides/project
## * https://developers.google.com/identity/protocols/googlescopes#drivev3
## * https://cloud.google.com/storage/docs/gsutil/commands/config
## * https://www.maketecheasier.com/rclone-sync-multiple-cloud-storage-providers-linux/
## * https://www.labnol.org/internet/direct-links-for-google-drive/28356/ 
## * https://github.com/rclone/rclone/issues/3631
#
## Rclone browser
## * https://www.techrepublic.com/article/how-to-sync-from-linux-to-google-drive-with-rclone/
###----------------------------------------------------------


function rclone-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  # source ${LSCRIPTS}/lscripts.config.sh

  local filepath="$(mktemp /tmp/rclone.install-$(date +"%d%m%y_%H%M%S-XXXXXX").sh)"
  echo "filepath: ${filepath}"
  curl https://rclone.org/install.sh > ${filepath}
  sudo bash ${filepath}

	## OR
	# sudo apt install rclone

	# man rclone
	rclone config

	# cd ${LSCRIPTS}
}

rclone-install.main "$@"
