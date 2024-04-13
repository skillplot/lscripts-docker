#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Nvidia GPU Driver Installation
###----------------------------------------------------------
#
## Todo:
## - Update Nvidia Driver if latest is available and configured
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function __nvidia-driver-install() {
  ## Todo: ask for user input for confirmation
  lsd-mod.log.warn "We will try installing Nvidia driver version as given in the configuration: ${NVIDIA_DRIVER_VER}"

  [[ "${LINUX_VERSION}" == "16.04" ]] && \
    sudo sh -c 'echo "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/disable-nouveau.conf' || lsd-mod.log.info "skipping blacklist nouveau"

  sudo apt -y update
  sudo apt install "nvidia-driver-${NVIDIA_DRIVER_VER}"

  lsd-mod.log.info "###----------------------------------------------------------"
  lsd-mod.log.info "## CUDA, cuDNN, TensorRT - Install after the Nvidia driver"
  lsd-mod.log.info "###----------------------------------------------------------"
}

function nvidia-driver-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="nvidia-driver"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=yes
  local _que
  local _msg

  lsd-mod.log.info "Checking for Graphics Hardware and System Architecture Details..."
  lsd-mod.log.info "Enter the sudo password if prompted"
  lsd-mod.system.get__gpu_info

  ## Todo: user input for driver version if latest is available
  declare -a nvidia_driver_avail=$(lsd-mod.nvidia.get__driver_avail)
  lsd-mod.log.info "Available Nvidia Drivers (${#nvidia_driver_avail[@]}): ${nvidia_driver_avail[@]}"

  [[ ! -z "${NVIDIA_DRIVER_VER}" ]] && lsd-mod.log.info "Configured NVIDIA_DRIVER_VER: ${NVIDIA_DRIVER_VER}" \
    || (NVIDIA_DRIVER_VER='440' && lsd-mod.log.info "Unable to get NVIDIA_DRIVER_VER, using default version: ${NVIDIA_DRIVER_VER}")
  
  lsd-mod.log.info "###----------------------------------------------------------"
  lsd-mod.log.info "## Nvidia Graphics Card Driver Installer"
  lsd-mod.log.info "## Tested on:"
  lsd-mod.log.info "## - MSI Leopard Laptop, RTX, Ubuntu 18.04 LTS"
  lsd-mod.log.info "## - Gigabyte Nvidia GTX 1080 Ti, Ubuntu 18.04 LTS"
  lsd-mod.log.info "###----------------------------------------------------------"

  local NVIDIA_DRIVER_INFO
  local __NVIDIA_DRIVER_VERSION
  type nvidia-smi &>/dev/null && {
    NVIDIA_DRIVER_INFO="$(nvidia-smi | grep -i 'Version')" && \
    __NVIDIA_DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | cut -d'.' -f1)
    lsd-mod.log.ok "Nvidia Driver Already Installed:\n\n${NVIDIA_DRIVER_INFO}\n" && \
    lsd-mod.nvidia.get__driver_info
  } || {
    _que="Install Nvidia driver"
    _msg="Skipping ${_prog} installation!"
    lsd-mod.fio.yesno_no "${_que}" && {
        lsd-mod.log.echo "Installing..." && \
        __${_prog}-install

        _que="Re-boot is essential. Do you want to reboot sytem"
        _msg="Re-boot you system later to complete the installation. Further installation will break is not rebooted."
        lsd-mod.fio.yes_or_no_loop "${_que}" && \
            lsd-mod.log.echo "Rebooting system..." && \
            sudo reboot \
          || lsd-mod.log.echo "${_msg}"
    } || lsd-mod.log.echo "${_msg}"
  }

  [[ ! -z "${__NVIDIA_DRIVER_VERSION}" ]] && \
    [[ "${__NVIDIA_DRIVER_VERSION}" -lt "${NVIDIA_DRIVER_VER}" ]] && {
      _que="Upgrade Nvidia driver from: ${__NVIDIA_DRIVER_VERSION} to: ${NVIDIA_DRIVER_VER} "
      _msg="Skipping ${_prog} upgrade!"
      lsd-mod.fio.yesno_no "${_que}" && {
          lsd-mod.log.echo "Upgrading..." && \
          __${_prog}-install

          _que="Re-boot is essential. Do you want to reboot sytem"
          _msg="Re-boot you system later to complete the installation. Further installation will break is not rebooted."
          lsd-mod.fio.yes_or_no_loop "${_que}" && \
              lsd-mod.log.echo "Rebooting system..." && \
              sudo reboot \
            || lsd-mod.log.echo "${_msg}"
      } || lsd-mod.log.echo "${_msg}"
    }
}

nvidia-driver-install.main "$@"
