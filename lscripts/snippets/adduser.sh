#!/bin/bash

username=$1

[[ -z ${username} ]] && username="skplt$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 4)"
groupname="skillplot"
# echo "username: ${username}"

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
