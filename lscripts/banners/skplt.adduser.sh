#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## User and group management for skillplot
###----------------------------------------------------------


###----------------------------------------------------------
## _fio_.sh
###----------------------------------------------------------

function lsd-mod.fio.yesno_no() {
  ## default is No
  local msg
  [[ $# -eq 0 ]] && msg="Are you sure" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}? \e[1;37m\e[1;31m[y/N]\e[1;33m>\e[0m ")
  [[ $(read -e -p "${msg}"; echo ${REPLY}) == [Yy]* ]] && return 0 || return -1
}


function lsd-mod.fio.yes_or_no_loop() {
  local msg
  local response

  [[ $# -eq 0 ]] && msg="Are you sure" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}? \e[1;37m\e[1;31m[y/n]\e[1;33m>\e[0m ")
  while true; do
    read -p "${msg}" response
    case ${response} in
      [Yy]*) return 0  ;;  
      [Nn]*) return -1 ;;
      # *) lsd-mod.log.echo "Invalid input" ;;
    esac
  done
}



###----------------------------------------------------------

function lsd-mod.skillplot() {

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


function lsd-mod.command_exists() {
  ## Function to check if a command is available
  command -v "$1" >/dev/null 2>&1
}


function lsd-mod.create-login-user() {
  ## Get a username name
  local username=$(lsd-mod.get_valid_input "Enter username" "lsd-mod.is_non_empty")
  ## local groupname=$(lsd-mod.get_valid_input "Enter group name" "lsd-mod.is_non_empty")
  local groupname="skillplot"

  (>&2 echo -e "New system user (${username}) will be added to the groups: (${username}) and (${groupname})")
  (>&2 echo -e "Password is same as username. Do not forget to change the password later.")

  ##   -U, --user-group              create a group with the same name as the user
  ##   -r, --system                  create a system account
  ##   -M, --no-create-home          do not create the user's home directory
  ##   -m, --create-home             create the user's home directory
  ##   -s, --shell SHELL             login shell of the new account
  ##   -c, --comment COMMENT         GECOS field of the new account

  ## delete username and group with the username
  ### sudo userdel -r "$username"
  ### sudo groupdel "$username"

  ## "Add user if it does not exists."
  id -u ${username} &> /dev/null || {

    sudo useradd -m -U -s /bin/bash -c "User account" ${username}
    echo "${username}:${username}" | sudo chpasswd
    sudo -u "${username}" mkdir -p "/home/${username}/Desktop" "/home/${username}/Documents" "/home/$username/Downloads" "/home/${username}/Music" "/home/${username}/Pictures" "/home/${username}/Public"
    sudo chown -R ${username}:${username} /home/${username}


    sudo gpasswd -d $(id -un) ${groupname} &> /dev/null
    sudo gpasswd -d ${username} ${groupname} &> /dev/null
  }

  ## "Add new application system user to the secondary group, if it is not already added."
  getent group | grep ${username}  | grep ${groupname} &> /dev/null || {
    sudo groupadd ${groupname}
    sudo usermod -aG ${groupname} ${username}
  }

  ## "Adding current user to the secondary group, if it is not already added."
  ## "Also, adding the user to the sudo group so it can run commands in a privileged mode!"
  getent group | grep $(id -un) | grep ${groupname} &> /dev/null || {
    sudo usermod -aG ${groupname} $(id -un)
    cat /etc/passwd | grep ${username}
  }
}


function lsd-mod.get_mac_address() {
  ## Function to get the MAC address
  # ip link show | awk '/ether/ && !/link\/ether/ {print $2; exit}'
  # echo $(LANG=C ip link show | awk '/link\/ether/ {print $2}' | tr '\n' '|')
  echo $(ip link | awk '{print $2}'  | tr '\n' '|')
}

function lsd-mod.get_hostname() {
  ## Function to get the hostname
  hostname
}

function lsd-mod.get_cpu_info() {
  ## Function to get CPU information
  cat /proc/cpuinfo | grep 'model name' | head -n 1
}

function lsd-mod.get_os_name() {
  ## Function to obtain the operating system name (fallback if lsb_release is unavailable)
  if lsd-mod.command_exists lsb_release; then
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

function lsd-mod.system() {
  ## Function to generate a unique system ID by hashing the input
  local mac_address=$(lsd-mod.get_mac_address)
  local hostname=$(lsd-mod.get_hostname)
  local cpu_info=$(lsd-mod.get_cpu_info)
  local cpu_cores=$(grep -c '^processor' /proc/cpuinfo)
  local cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
  local architecture=$(uname -m)
  local kernel_version=$(uname -r)
  local os_name=$(lsd-mod.get_os_name)
  
  local total_ram=$(free -h --si | awk '/Mem:/{print $2}')
  local storage_available=$(df -h / | awk '/\//{print $4}')
  
  local current_user=$(whoami)
  
  
  local combined_info="$mac_address-$hostname-$cpu_info-$cpu_cores-$cpu_threads-$architecture-$kernel_version-$os_name-$total_ram-$current_user"

  ## Hash the combined system information
  local system_id=$(echo -n "$combined_info" | sha256sum | awk '{print $1}')

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


function lsd-mod.display_datetime() {
  ## Function to display the current date, time, month, and year
  local current_date=$(date "+%A, %B %d, %Y")
  local current_time=$(date "+%T")
  echo "Current Date: $current_date"
  echo "Current Time: $current_time"
}


function lsd-mod.is_non_empty() {
  ## Function to check if the input is non-empty
  [ -n "$1" ]
}


function lsd-mod.get_valid_input() {
  ## Function to get a valid input (non-empty and matching the specified data type)
  local prompt="$1"
  local validation_func="$2"
  local input=""
  
  while true; do
    read -p "$prompt: " input
    if $(lsd-mod.is_non_empty "$input" && $validation_func "$input"); then
      break
    fi
  done
  
  echo "$input"
}


function lsd-mod.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

  lsd-mod.skillplot

  local combined_info=$(lsd-mod.system)
  (>&2 echo -e "$combined_info")

  (>&2 echo -e "###--------------------------------------------------------------------------")
  (>&2 echo -e "The script will create normal user with home directory and login!")
  (>&2 echo -e "The user will be added to the same user group additional to 'skillplot' group!")

  local _default=no
  local _que="Add login user to the system."
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    (>&2 echo -e "Executing... sudo access is required!")

    lsd-mod.create-login-user

    while true; do
      _que="Add another user."
      lsd-mod.fio.yes_or_no_loop "${_que}" && {
          lsd-mod.create-login-user
      } || {
        (>&2 echo -e "Thank you! If this is helpful add star to this repo: https://github.com/skillplot/lscripts-docker
###--------------------------------------------------------------------------")
        break
      }
    done
  }  
}

lsd-mod.main "$@"
