#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ftp, vsftpd
###----------------------------------------------------------
#
## References:
## * https://blog.eduonix.com/shell-scripting/how-to-automate-ftp-transfers-in-linux-shell-scripting/
## * http://stratigery.com/scripting.ftp.html
## * https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-18-04
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }

function ftp-uninstall() {
  return
}

function __ftp-install() {
  sudo apt -y install vsftpd
  return
}

function ftp-configure() {
  ## saving the original as a backup
  sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig

  ## firewall status
  sudo ufw status
  sudo ufw enable

  ## open ports 20 and 21 for FTP, port 990 for when we enable TLS, and ports 40000-50000 for the range of passive ports we plan to set in the configuration file
  sudo ufw allow 20/tcp
  sudo ufw allow 21/tcp
  sudo ufw allow 990/tcp
  sudo ufw allow 40000:50000/tcp
  sudo ufw status

  local ftp_user=$(id -un)
  local ftp_user_grp=$(id -gn)

  ## create a dedicated FTP user.
  # local ftp_user="blah"
  # sudo adduser ${ftp_user}

  local ftp_root_basepath=${HOME}/ftp
  ## create the ftp directory and direcotry for file uploads
  sudo mkdir -p ${ftp_root_basepath}/files
  ## Set ownership
  sudo chown nobody:nogroup ${ftp_root_basepath}
  ## Remove write permissions:
  sudo chmod a-w ${ftp_root_basepath}
  ## Verify the permissions
  sudo ls -la ${ftp_root_basepath}
  ## assign ownership to the user for the directory for file uploads
  sudo chown ${ftp_user}:${ftp_user_grp} ${ftp_root_basepath}/files

  ## Verify the permissions
  sudo ls -la ${ftp_root_basepath}

  ## FTP is generally more secure when users are restricted to a specific directory. vsftpd accomplishes this with chroot jails.

  ## test
  echo "vsftpd test file" | sudo tee ${ftp_root_basepath}/files/test.txt

  ls -l /etc/vsftpd.conf

  ## enable the user to upload files by uncommenting the write_enable setting:
  # write_enable=YES

  ## prevent the FTP-connected user from accessing any files or commands outside the directory tree:
  # chroot_local_user=YES

  # ## ocal_root directory path so our configuration will work for this user and any additional future users
  # user_sub_token=$USER
  # local_root=/home/$USER/ftp

  # ## limit the range of ports that can be used for passive FTP to make sure enough connections are available:
  # pasv_min_port=40000
  # pasv_max_port=50000
  # userlist_enable=YES
  # userlist_file=/etc/vsftpd.userlist
  # userlist_deny=NO

  return
}

function ftp-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"
  
  _log_.info "Recommended: DOCKER_VERSION < 19.03.1. This is for providing nvidia/cuda container compatibility"
  ## local _default=$(_fio_.get_yesno_default)

  local _prog="ftp"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  local _default=yes
  local _que
  local _msg

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Uninstalling..." && \
      ${_prog}-uninstall \
    || _log_.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Installing..." && \
      __${_prog}-install \
    || _log_.echo "${_msg}"

  _que="Configure ${_prog} to run without sudo (recommended)"
  _msg="Skipping ${_prog} configuration!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Configuring..." && \
      ${_prog}-configure \
    || _log_.echo "${_msg}"

  _que="Re-boot is essential. Do you want to reboot sytem"
  _msg="Re-boot you system later to complete the installation. Further installation will break is not rebooted."
  _fio_.yes_or_no_loop "${_que}" && \
      _log_.echo "Rebooting system..." && \
      sudo reboot \
    || _log_.echo "${_msg}"
}

ftp-install
