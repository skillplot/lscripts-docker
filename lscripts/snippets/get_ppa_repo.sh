#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## listppa Script to get all the PPA installed on a system ready to share for reininstall
#
## References:
## Modified the script based on provided by NGRhodes @ askubuntu:
## https://askubuntu.com/questions/545881/list-all-the-ppa-repositories-added-to-my-system
###----------------------------------------------------------


function get_ppa_repo() {
  local OUTFILE="add_ppa_repo.sh"
  local OUTFILE2="remove_ppa_repo.sh"
  #touch "${OUTFILE}"
  echo -e "#!/bin/bash\n" > "${OUTFILE}"
  echo -e "#!/bin/bash\n" > "${OUTFILE2}"

  local APT
  local ENTRY
  local _USER
  local _PPA
  for APT in `find /etc/apt/ -name \*.list`; do
      grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" ${APT} | while read ENTRY ; do
          _USER=$(echo ${ENTRY} | cut -d/ -f4)
          _PPA=$(echo ${ENTRY} | cut -d/ -f5)

          echo "#$_USER/$_PPA" >> "${OUTFILE}"
          echo "#$_USER/$_PPA" >> "${OUTFILE2}"
          echo sudo -E apt-add-repository ppa:${_USER}/${_PPA} >> "${OUTFILE}"
          echo sudo -E apt-add-repository --remove ppa:${_USER}/${_PPA} >> "${OUTFILE2}"
      done
  done

  # chmod +x "${OUTFILE}"
  # chmod +x "${OUTFILE2}"
}

get_ppa_repo
