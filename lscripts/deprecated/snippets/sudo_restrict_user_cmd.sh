#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
#
## create a new system level user without login, create the new group,
## adds current logged-in user and new system nologin user to the common group;
## and give restrictive sudo access to a particular script and systemd service
###----------------------------------------------------------


function sudo_restrict_user_cmd() {
  local _key
  local _val
  declare -A args
  while [[ "$#" > "0" ]]; do
    case "$1" in 
      (*=*)
          _key="${1%%=*}" &&  _key="${_key/--/}" && _val="${1#*=}"
          args[${_key}]="${_val}"
          # (>&2 echo -e "key:val => ${_key}:${_val}")
          ;;
    esac
    shift
  done

  echo "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && lsd-mod.log.echo "${key} = ${args[${key}]}" || lsd-mod.log.error "Key does not exists: ${key}"
  done

  local username
  local groupname
  local scripts_filepath
  local cservicename
  [[ -n "${args['user']+1}" ]] && username=${args['user']} && \
  [[ -n "${args['group']+1}" ]] && groupname=${args['group']} && \
  [[ -n "${args['scripts_filepath']+1}" ]] && scripts_filepath=${args['scripts_filepath']} && {
    [[ -n "${args['cservicename']+1}" ]] && cservicename=${args['cservicename']} ||  ( cservicename="${username}.service" && echo "cservicename: ${cservicename}" ) 
    } && {
      echo "Executing system user creation process..."

      ## delete the system user from the secondary group
      sudo userdel ${username} -r &> /dev/null
      sudo groupdel ${username} &> /dev/null
      sudo groupdel ${groupname} &> /dev/null

      ## add user if it does not exists
      id -u ${username} &> /dev/null || sudo useradd -rUMs /usr/sbin/nologin -c "User account" ${username}
      sudo gpasswd -d $(id -un) ${groupname} &> /dev/null
      sudo gpasswd -d ${username} ${groupname} &> /dev/null

      ## add application system user to the secondary group, if it is not already added
      getent group | grep ${username}  | grep ${groupname} &> /dev/null || {
        sudo groupadd ${groupname}
        sudo usermod -aG ${groupname} ${username}
      }

      ## add system user to the secondary group, if it is not already added
      getent group | grep $(id -un) | grep ${groupname} &> /dev/null || {
        sudo usermod -aG ${groupname} $(id -un) && lsd-mod.log.echo "Successfully created system user"
        cat /etc/passwd | grep ${username}
      }

      local L1
      local L2
      local FILE
      ## Allow only specific services and commands to be executed without sudo
      ## Inject in sudoer file using visudo and only when it does not exits
      FILE=/etc/sudoers
      L1="Cmnd_Alias AISERVICES = ${scripts_filepath}, /bin/systemctl status ${cservicename}, /bin/systemctl reload ${cservicename}, /bin/systemctl restart ${cservicename}"
      L2="$(id -un) ALL=(${username}:${groupname}) NOPASSWD: AISERVICES"
      sudo grep -qF "$L1" "$FILE" || echo -e "$L1" | sudo EDITOR='tee -a' visudo &> /dev/null 
      sudo grep -qF "$L2" "$FILE" || echo -e "$L2" | sudo EDITOR='tee -a' visudo

      ## list the group members along with their GIDs
      id ${username}

      ## permissions: r 4; w 2; x 1;  
      ## make ${username} as the owner of specific directory
      sudo chown -R ${username}:${groupname} ${scripts_filepath}

      ## only owner has the permission to read and execute
      sudo chmod -R 500 ${scripts_filepath}

      ## kill the sudo timeout and reset, so we know that the test really works
      sudo -k

      ## Test - this should print hello
      ## systen usercan execute without these scripts without sudo password
      sudo -u ${username} -s /bin/bash ${scripts_filepath} hello

      echo -e "\nUsage:
      sudo -u ${username} -s /bin/bash ${scripts_filepath} hello
      sudo -u ${username} systemctl [status|reload|restart] ${username}.service"
  } || echo "Required params are missing!"
}
