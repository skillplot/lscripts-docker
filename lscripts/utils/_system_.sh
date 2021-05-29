#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## system utility functions
###----------------------------------------------------------


function _system_.get__info() {
  type inxi &>/dev/null && inxi -Fxzd;
}


function _system_.get__cpu_cores() {
  cat /proc/cpuinfo |grep -i 'core id'|wc -l
}


function _system_.get__ip() {
  ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}


function _system_.get__numthreads() {
  ## Calculates 1.5 times physical threads
  local NUMTHREADS=1 ## disable MP
  if [[ -f /sys/devices/system/cpu/online ]]; then
    NUMTHREADS=$(( ( $(cut -f 2 -d '-' /sys/devices/system/cpu/online) + 1 ) * 15 / 10  ))
  fi
  echo "${NUMTHREADS}"
}


function _system_.get__gpu_info() {
  ###----------------------------------------------------------
  ## GPU / Graphics card
  ## How do I find out the model of my graphics card?
  ## check for Graphics Hardware and System Architecture Details
  ###----------------------------------------------------------

  lspci -nnk | grep -i "VGA\|3D" -A3
  lspci -v -s $(lspci | grep VGA | cut -d" " -f 1)
  lspci | grep VGA
  lspci | grep -i nvidia
  arch
  type glxinfo &>/dev/null && glxinfo | grep OpenGL

  ## sudo lshw | grep -A10 "VGA\|3D"
  ## sudo lshw -c video
}


function _system_.create_login_user() {
  ## create normal user with home and login
  ## Caution: add the user as the sudoer

  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  _log_.warn "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && _log_.echo "${key} = ${args[${key}]}" || _log_.error "Key does not exists: ${key}"
  done

  local username
  local groupname
  # [[ -n "${args['username']+1}" ]] && username=${args['username']} ||  username=${args['username']} 
  # [[ -n "${args['groupname']+1}" ]] && groupname=${args['groupname']} ||  groupname=${args['username']} 

  [[ -n "${args['username']+1}" ]] && [[ -n "${args['groupname']+1}" ]] && {
    username="${args['username']}"
    groupname="${args['groupname']}"

    ##   -U, --user-group              create a group with the same name as the user
    ##   -r, --system                  create a system account
    ##   -M, --no-create-home          do not create the user's home directory
    ##   -s, --shell SHELL             login shell of the new account
    ##   -c, --comment COMMENT         GECOS field of the new account

    ## add user if it does not exists
    id -u ${username} &> /dev/null || sudo useradd -c "User account" ${username}
    sudo gpasswd -d $(id -un) ${groupname} &> /dev/null
    sudo gpasswd -d ${username} ${groupname} &> /dev/null

    ## add application system user to the secondary group, if it is not already added
    getent group | grep ${username}  | grep ${groupname} &> /dev/null || {
      sudo groupadd ${groupname}
      sudo usermod -aG ${groupname} ${username}
    }

    ## add system user to the secondary group, if it is not already added
    ## add the user to the sudo group so it can run commands in a privileged mode
    getent group | grep $(id -un) | grep ${groupname} &> /dev/null || {
      sudo usermod -aG ${groupname} $(id -un) && \
        sudo usermod -aG sudo ${username} && _log_.echo "Successfully created system user"
      cat /etc/passwd | grep ${username}
    }
  } || _log_.error "Invalid paramerters!"
}


function _system_.create_nologin_user() {
  ## create linux system user
  ## Caution: delete the existing user and group

  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  _log_.warn "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && _log_.echo "${key} = ${args[${key}]}" || _log_.error "Key does not exists: ${key}"
  done

  local username
  local groupname
  [[ -n "${args['username']+1}" ]] && username=${args['username']} ||  username=${args['username']} 
  [[ -n "${args['groupname']+1}" ]] && groupname=${args['groupname']} ||  groupname=${args['username']} 

  ##   -U, --user-group              create a group with the same name as the user
  ##   -r, --system                  create a system account
  ##   -M, --no-create-home          do not create the user's home directory
  ##   -s, --shell SHELL             login shell of the new account
  ##   -c, --comment COMMENT         GECOS field of the new account

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
    sudo usermod -aG ${groupname} $(id -un) && _log_.echo "Successfully created system user"
    cat /etc/passwd | grep ${username}
  }
}


function _system_.sudo_restrict_user_cmd_prompt() {
  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  _log_.warn "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && _log_.echo "${key} = ${args[${key}]}" || _log_.error "Key does not exists: ${key}"
  done

  local username
  local groupname
  local scripts_filepath
  local cservicename
  [[ -n "${args['username']+1}" ]] && username=${args['username']} || _log_.fail "username does not exists"

  [[ -n "${args['groupname']+1}" ]] && groupname=${args['groupname']} || ( groupname=${args['username']} && _log_.info "groupname will be same as username: ${args['username']}" )

  [[ -n "${args['scripts_filepath']+1}" ]] && scripts_filepath=${args['scripts_filepath']} \
    ||  ( scripts_filepath="${_BZO__SCRIPTS}/lscripts-docker/lscripts/tests/test.sh" && _log_.info "scripts_filepath: ${scripts_filepath}" )

  [[ -n "${args['cservicename']+1}" ]] && cservicename=${args['cservicename']} \
    ||  ( cservicename="${username}.service" && _log_.info "cservicename: ${cservicename}" )

  local _que
  local _msg
  _que="Do you want proceed with system user creation process"
  _msg="Skipping system user creation process."
  _fio_.yesno_yes "${_que}" && \
      _log_.echo "Executing system user creation process..." && \
      _system_.create_nologin_user --user=${username} --group=${groupname} \
    || _log_.echo "${_msg}"


  _que="Do you want proceed with configure restrictive sudo access"
  _msg="Skipping sudo configuration."
  _fio_.yesno_no "${_que}" && {
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
    } || _log_.echo "${_msg}"
}


function _system_.df_json {
  ## Referenecs:
  ## https://www.unix.com/unix-for-beginners-questions-and-answers/282491-how-convert-any-shell-command-output-json-format.html
  local keys
  local vals
  echo `df -h . | tr -s ' ' ',' | jq -nR '[ 
    ( input | split(",") ) as $keys | 
    ( inputs | split(",") ) as $vals | 
    [ [$keys, $vals] | 
    transpose[] | 
    {key:.[0],value:.[1]} ] | 
    from_entries ]'`
}


function _system_.get__osinfo() {
  local id=$(. /etc/os-release;echo ${ID})
  local version_id=$(. /etc/os-release;echo ${VERSION_ID})
  local distribution=$(. /etc/os-release;echo ${ID}${VERSION_ID})

  echo ${id}
  echo ${version_id}
  echo ${distribution}
}


function _system_.select__prog() {
  ## Todo
  local _prog=$1

  [[ ! -z ${_prog} ]] && {
    sudo update-alternatives --config ${_prog}
  } || _log_.echo "Invalid update-alternatives"
}


function _system_.select__cuda() {
  _system_.select__prog cuda
}


function _system_.select__bazel() {
  _system_.select__prog bazel
}


function _system_.select__gcc() {
  _system_.select__prog gcc
}


# ## Todo: cleanup
# function _system_.__create_appuser() {
#   source ${LSCRIPTS}/utils/argparse.sh "$@"

#   _log_.warn "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

#   local key
#   for key in "${!args[@]}"; do
#     [[ -n "${args[${key}]+1}" ]] && _log_.echo "${key} = ${args[${key}]}" || _log_.error "Key does not exists: ${key}"
#   done

#   local L1
#   local L2
#   local FILE
#   # local username="boozo"
#   # local groupname="boozo"
#   # local scripts_path="/boozo-hub/boozo/scripts"

#   local username="${args['username']}"
#   local groupname="${args['groupname']}"
#   local scripts_path="${args['scripts_path']}"

#   [[ -z ${username} ]] || username="boozo"
#   [[ -z ${groupname} ]] || username="boozo"
#   [[ -d ${scripts_path} ]] || _log_.fail "scripts_path does not exists: ${scripts_path}"

#   local cservicename="${username}.service"

#   ## delete the exisitng user; if needed, otherwise keep it commented
#   sudo userdel ${username} -r &> /dev/null
#   sudo groupdel ${groupname}

#   ##   -U, --user-group              create a group with the same name as the user
#   ##   -r, --system                  create a system account
#   ##   -M, --no-create-home          do not create the user's home directory
#   ##   -s, --shell SHELL             login shell of the new account
#   ##   -c, --comment COMMENT         GECOS field of the new account

#   ## add user if it does not exists
#   id -u ${username} &> /dev/null || sudo useradd -rUMs /usr/sbin/nologin -c "AI application user account" ${username}


#   ## add system user to the secondary group, if it is not already added
#   getent group | grep $(id -un) | grep ${groupname} &> /dev/null || sudo usermod -aG ${groupname} $(id -un)

#   ## delete the system user from the secondary group if needed, otherwise keep it commented
#   ## sudo gpasswd -d $(id -un) ${groupname}

#   ## allow only specific services and commands to be executed without sudo
#   ## Inject in sudoer file using visudo and only when it does not exits
#   FILE=/etc/sudoers
#   L1="Cmnd_Alias AISERVICES = ${scripts_path}/test.sh, ${scripts_path}/flip.sh, /bin/systemctl status ${cservicename}, /bin/systemctl reload ${cservicename}, /bin/systemctl restart ${cservicename}"
#   L2="$(id -un) ALL=(${username}:${groupname}) NOPASSWD: AISERVICES"
#   sudo grep -qF "$L1" "$FILE" || echo -e "$L1" | sudo EDITOR='tee -a' visudo &> /dev/null 
#   sudo grep -qF "$L2" "$FILE" || echo -e "$L2" | sudo EDITOR='tee -a' visudo

#   # echo -e "$L1" | sudo EDITOR='tee -a' visudo
#   # echo "$L2" | sudo EDITOR='tee -a' visudo

#   ## list the group members along with their GIDs
#   id ${username}

#   ## permissions: r 4; w 2; x 1;  

#   ## make ${username} as the owner of specific directory
#   sudo chown -R ${username}:${groupname} ${scripts_path}

#   ## only owner has the permission to read and execute
#   # sudo chmod 500 ${scripts_path}/*.sh
#   sudo chmod -R 500 ${scripts_path}

#   ## kill the sudo timeout and reset, so we know that the test really works
#   sudo -k

#   ## Test - this should print hello
#   ## systen usercan execute without these scripts without sudo password
#   sudo -u ${username} -s /bin/bash ${scripts_path}/test.sh hello

#   echo -e "\nUsage:
#   sudo -u ${username} -s /bin/bash ${scripts_path}/test.sh hello
#   sudo -u ${username} -s /bin/bash ${scripts_path}/flip.sh
#   sudo -u ${username} systemctl [status|reload|restart] aimlhub.service"
# }


# function _system_.__add_userusername{
#   source ${LSCRIPTS}/utils/argparse.sh "$@"

#   [[ "$#" -ne "2" ]] && _log_.fail "Invalid number of paramerters: required 2 given $#"
#   [[ -n "${args['user']+1}" ]] && [[ -n "${args['groupname']+1}" ]] && {
#     # (>&2 echo -e "key: 'username' exists")
#     local username="${args['user']}"
#     local groupname="${args['groupname']}"

#     ## Create the user that will run the service
#     sudo useradd ${username}

#     ## Set bash as the default shell for the user
#     sudo usermod --shell /bin/bash ${username}

#     ## Set a password for this user
#     sudo passwd ${username}

#     ## add the user to the sudo group so it can run commands in a privileged mode
#     # sudo adduser ${username} sudo
#     sudo usermod -aG sudo ${username}

#     ## In terms of security, it is recommended that you allow SSH access to as few users as possible
#     ## Disable SSH access for both your newly created user and root user in this step.
#     ## Save and exit the file and then restart the SSH daemon to activate the changes.
#     # ```
#     # sudo vi /etc/ssh/sshd_config
#     # PermitRootLogin no
#     ## Under the PermitRootLogin value, add a DenyUsers line and set the value as any user who should have SSH access disabled:
#     # DenyUsers ${username}
#     # ```
#     # sudo systemctl restart sshd
#     # 
#   } || _log_.error "Invalid paramerters!"
# }
