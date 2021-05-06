#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Nvidia GPU Driver Installation
###----------------------------------------------------------
#
## Todo:
## - Update Nvidia Driver if latest is available and configured
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}

function __nvidia-driver-install() {
  ## Todo: ask for user input for confirmation
  _log_.warn "We will try installing Nvidia driver version as given in the configuration: ${NVIDIA_DRIVER_VER}"

  [[ "${LINUX_VERSION}" == "16.04" ]] && \
    sudo sh -c 'echo "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/disable-nouveau.conf' || _log_.info "skipping blacklist nouveau"

  sudo apt -y update
  sudo apt install "nvidia-driver-${NVIDIA_DRIVER_VER}"

  _log_.info "###----------------------------------------------------------"
  _log_.info "## CUDA, cuDNN, TensorRT - Install after the Nvidia driver"
  _log_.info "###----------------------------------------------------------"
}

function nvidia-driver-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _prog="nvidia-driver"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  local _default=yes
  local _que
  local _msg

  _log_.info "Checking for Graphics Hardware and System Architecture Details..."
  _log_.info "Enter the sudo password if prompted"
  _system_.get__gpu_info

  ## Todo: user input for driver version if latest is available
  declare -a nvidia_driver_avail=$(_nvidia_.get__driver_avail)
  _log_.info "Available Nvidia Drivers (${#nvidia_driver_avail[@]}): ${nvidia_driver_avail[@]}"

  [[ ! -z "${NVIDIA_DRIVER_VER}" ]] && _log_.info "Configured NVIDIA_DRIVER_VER: ${NVIDIA_DRIVER_VER}" \
    || (NVIDIA_DRIVER_VER='440' && _log_.info "Unable to get NVIDIA_DRIVER_VER, using default version: ${NVIDIA_DRIVER_VER}")
  
  _log_.info "###----------------------------------------------------------"
  _log_.info "## Nvidia Graphics Card Driver Installer"
  _log_.info "## Tested on:"
  _log_.info "## - MSI Leopard Laptop, RTX, Ubuntu 18.04 LTS"
  _log_.info "## - Gigabyte Nvidia GTX 1080 Ti, Ubuntu 18.04 LTS"
  _log_.info "###----------------------------------------------------------"

  local NVIDIA_DRIVER_INFO
  local __NVIDIA_DRIVER_VERSION
  type nvidia-smi &>/dev/null && {
    NVIDIA_DRIVER_INFO="$(nvidia-smi | grep -i 'Version')" && \
    __NVIDIA_DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | cut -d'.' -f1)
    _log_.ok "Nvidia Driver Already Installed:\n\n${NVIDIA_DRIVER_INFO}\n" && \
    _nvidia_.get__driver_info
  } || {
    _que="Install Nvidia driver"
    _msg="Skipping ${_prog} installation!"
    _fio_.yesno_no "${_que}" && {
        _log_.echo "Installing..." && \
        __${_prog}-install

        _que="Re-boot is essential. Do you want to reboot sytem"
        _msg="Re-boot you system later to complete the installation. Further installation will break is not rebooted."
        _fio_.yes_or_no_loop "${_que}" && \
            _log_.echo "Rebooting system..." && \
            sudo reboot \
          || _log_.echo "${_msg}"
    } || _log_.echo "${_msg}"
  }

  [[ ! -z "${__NVIDIA_DRIVER_VERSION}" ]] && \
    [[ "${__NVIDIA_DRIVER_VERSION}" -lt "${NVIDIA_DRIVER_VER}" ]] && {
      _que="Upgrade Nvidia driver from: ${__NVIDIA_DRIVER_VERSION} to: ${NVIDIA_DRIVER_VER} "
      _msg="Skipping ${_prog} upgrade!"
      _fio_.yesno_no "${_que}" && {
          _log_.echo "Upgrading..." && \
          __${_prog}-install

          _que="Re-boot is essential. Do you want to reboot sytem"
          _msg="Re-boot you system later to complete the installation. Further installation will break is not rebooted."
          _fio_.yes_or_no_loop "${_que}" && \
              _log_.echo "Rebooting system..." && \
              sudo reboot \
            || _log_.echo "${_msg}"
      } || _log_.echo "${_msg}"
    }
}

nvidia-driver-install
