#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Ubuntu Server Setup for Educational and Research Purpose
###----------------------------------------------------------


function lsd-mod.fio.yesno_no() {
  ## default is No
  local msg
  [[ $# -eq 0 ]] && msg="Are you sure" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}? \e[1;37m\e[1;31m[y/N]\e[1;33m>\e[0m ")
  [[ $(read -e -p "${msg}"; echo ${REPLY}) == [Yy]* ]] && return 0 || return -1
}


###----------------------------------------------------------

function lsd-mod.serversetup.banner.skillplot() {

(>&2 echo -e "
###--------------------------------------------------------------------------

   ▄▄▄▄▄   █  █▀ ▄█ █    █    █ ▄▄  █    ████▄    ▄▄▄▄▀ 
  █     ▀▄ █▄█   ██ █    █    █   █ █    █   █ ▀▀▀ █    
▄  ▀▀▀▀▄   █▀▄   ██ █    █    █▀▀▀  █    █   █     █    
 ▀▄▄▄▄▀    █  █  ▐█ ███▄ ███▄ █     ███▄ ▀████    █    .org 
             █    ▐     ▀    ▀ █        ▀        ▀      
            ▀                   ▀                       
>>> LSCRIPTS      : $(date +"%H:%M:%S, %d-%b-%Y, %A")
>>> Documentation : https://lscripts.skillplot.org
>>> Code          : https://github.com/skillplot/lscripts-docker
")
}


function lsd-mod.serversetup.command_exists() {
  ## Function to check if a command is available
  command -v "$1" >/dev/null 2>&1
}

function lsd-mod.serversetup.install_package_apt() {
  ## Function to install pre-requisite packages using apt (Debian/Ubuntu)
  
  sudo apt -y update && sudo apt -y install --no-install-recommends \
        build-essential \
        apt-transport-https \
        ca-certificates \
        gnupg \
        gnupg2 \
        wget \
        curl \
        software-properties-common \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        graphviz \
        openmpi-bin \
        rsync \
        unzip \
        zip \
        zlib1g-dev \
        git \
        swig \
        grep \
        feh \
        tree \
        sudo \
        libpng-dev \
        libjpeg-dev \
        libtool \
        bc \
        jq \
        openssh-server \
        gcc \
        figlet \
        apt-utils 2>/dev/null


  sudo apt -y install --no-install-recommends \
        uuid \
        automake \
        locate \
        vim \
        vim-gtk > /dev/null
}


function lsd-mod.serversetup.install_lscripts() {
  local __codehub_root__="/tmp/codehub"
  local __lscripts_external__="${__codehub_root__}/external"

  sudo mkdir -p ${__lscripts_external__}
  sudo chown -R $(id -un):$(id -gn) ${__codehub_root__}

  [[ ! -d "${__lscripts_external__}/lscripts-docker" ]] && {
    echo '${__lscripts_external__}/lscripts-docker directory not exists.' 
    echo 'git cloning at ${__lscripts_external__}/lscripts-docker directory.' 
    git -C ${__lscripts_external__} clone https://github.com/skillplot/lscripts-docker.git
  }

  local BASHRC_FILE="$HOME/.bashrc"
  local FILE=${BASHRC_FILE}
  local LINE

  LINE='export LSCRIPTS_DOCKER="'${__lscripts_external__}'/lscripts-docker"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='[ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  ## this will work only if the script is invoked with `source` command
  source ${FILE}
  echo 'Open a new terminal.' 
}


function lsd-mod.serversetup.get_mac_address() {
  ## Function to get the MAC address
  # ip link show | awk '/ether/ && !/link\/ether/ {print $2; exit}'
  # echo $(LANG=C ip link show | awk '/link\/ether/ {print $2}' | tr '\n' '|')
  echo $(ip link | awk '{print $2}'  | tr '\n' '|')
}

function lsd-mod.serversetup.get_hostname() {
  ## Function to get the hostname
  hostname
}

function lsd-mod.serversetup.get_cpu_info() {
  ## Function to get CPU information
  cat /proc/cpuinfo | grep 'model name' | head -n 1
}

function lsd-mod.serversetup.get_os_name() {
  ## Function to obtain the operating system name (fallback if lsb_release is unavailable)
  if lsd-mod.serversetup.command_exists lsb_release; then
    lsb_release -d | awk -F'\t' '{print $2}'
  else
    # Fallback method to obtain OS name
    if [ -e /etc/os-release ]; then
      grep -oP 'PRETTY_NAME="\K[^"]+' /etc/os-release
    elif [ -e /etc/lsb-release ]; then
      grep -oP 'DISTRIB_DESCRIPTION="\K[^"]+' /etc/lsb-release
    else
      echo "Unknown OS"
    fi
  fi
}

function lsd-mod.serversetup.banner.system() {
  ## Function to generate a unique system ID by hashing the input
  local mac_address=$(lsd-mod.serversetup.get_mac_address)
  local hostname=$(lsd-mod.serversetup.get_hostname)
  local cpu_info=$(lsd-mod.serversetup.get_cpu_info)
  local cpu_cores=$(grep -c '^processor' /proc/cpuinfo)
  local cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
  local architecture=$(uname -m)
  local kernel_version=$(uname -r)
  local os_name=$(lsd-mod.serversetup.get_os_name)
  
  local total_ram=$(free -h --si | awk '/Mem:/{print $2}')
  local storage_available=$(df -h / | awk '/\//{print $4}')
  
  local current_user=$(whoami)
  
  
  local combined_info="$mac_address-$hostname-$cpu_info-$cpu_cores-$cpu_threads-$architecture-$kernel_version-$os_name-$total_ram-$current_user"

  ## Hash the combined system information
  local system_id=$(echo -n "$combined_info" | sha256sum | awk '{print $1}')
    
  
  # ## Try to get the system UUID from dmidecode if available
  # if lsd-mod.serversetup.command_exists dmidecode; then
  #   vm_uuid=$(sudo dmidecode -s system-uuid 2>/dev/null)
  #   if [ -n "$vm_uuid" ]; then
  #     system_id="$system_id\nVM UUID: $vm_uuid"
  #   fi
  # fi

  (>&2 echo -e "System ID: $system_id
::$hostname
CPU Info: $cpu_info
CPU Cores: $cpu_cores
CPU Threads: $cpu_threads
Architecture: $architecture
Kernel Version: $kernel_version
OS Name: $os_name
Total RAM: $total_ram
Storage Available: $storage_available
Current User: $current_user ")
}


function lsd-mod.serversetup.display_datetime() {
  ## Function to display the current date, time, month, and year
  local current_date=$(date "+%A, %B %d, %Y")
  local current_time=$(date "+%T")
  echo "Current Date: $current_date"
  echo "Current Time: $current_time"
}


function lsd-mod.serversetup.is_non_empty() {
  ## Function to check if the input is non-empty
  [ -n "$1" ]
}

function lsd-mod.serversetup.is_valid_email() {
  ## Function to validate the email format
  local email_regex="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
  [[ "$1" =~ $email_regex ]]
}


function lsd-mod.serversetup.get_valid_input() {
  ## Function to get a valid input (non-empty and matching the specified data type)
  local prompt="$1"
  local validation_func="$2"
  local input=""
  
  while true; do
    read -p "$prompt: " input
    if $(lsd-mod.serversetup.is_non_empty "$input" && $validation_func "$input"); then
      break
    fi
  done
  
  echo "$input"
}


function lsd-mod.serversetup.convert_to_output() {
  ## Function to convert input to ASCII art using figlet or simple text output
  local input="$1"
  local _art=$input

  if lsd-mod.serversetup.command_exists figlet; then
    _art=$(figlet "$input")
  fi

  (>&2 echo -e "$_art")
}


function lsd-mod.serversetup.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

  # ## Get a valid name
  # local user_name=$(lsd-mod.serversetup.get_valid_input "Enter your name" "lsd-mod.serversetup.is_non_empty")

  # ## Get a valid email
  # local user_email=$(lsd-mod.serversetup.get_valid_input "Enter your email" "lsd-mod.serversetup.is_valid_email")


  # ## Get a valid student id
  # local student_id=$(lsd-mod.serversetup.get_valid_input "Enter your Student ID" "lsd-mod.serversetup.is_non_empty")

  lsd-mod.serversetup.banner.skillplot


  # ## Print ASCII art of the input or use simple text output
  # lsd-mod.serversetup.convert_to_output "$student_id"

  local combined_info=$(lsd-mod.serversetup.banner.system)
  (>&2 echo -e "$combined_info")

  local _default=no
  local _que="Insall minium server setup dependencies!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    echo "Installing..."
    (>&2 echo -e "Installing required packages... root access is required!")
    lsd-mod.serversetup.install_package_apt
  }

  local _default=no
  local _cmd="git"
  type ${_cmd} &>/dev/null && {
    local _que="Insall lscripts"
    lsd-mod.fio.yesno_${_default} "${_que}" && {
      echo "Installing..."
      (>&2 echo -e "Installing lscripts...git is requried!")
      lsd-mod.serversetup.install_lscripts
    }
  }



  (>&2 echo -e "Thank you! If this is helpful add star to this repo: https://github.com/skillplot/lscripts-docker
Next:\n 1) Open new terminal, check if skillplot banner comes, if yes then execute following command:\n lsd-stack.nvidia_cuda_python_docker
###--------------------------------------------------------------------------")
}

lsd-mod.serversetup.main "$@"
