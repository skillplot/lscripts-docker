#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## cypto functions
###----------------------------------------------------------


###----------------------------------------------------------
## openssl,ssh utilities for keys, secret management
###----------------------------------------------------------


function lsd-mod.crypto.openssl-encrypt() {
  ## Encrypt passphrase using openssl, use same algo and iteration as decrypt
  local _in=$1
  local _plaintext_passphrase
  [[ ! -f "${_in}" ]] && _plaintext_passphrase="${_in}" || {
    [[ -f "${_in}" ]] && _plaintext_passphrase="$(cat ${_in})"
  }

  # local _encrypted_passphrase=$(echo "${_plaintext_passphrase}" | openssl enc -aes-256-cbc -a -salt)
  # local _encrypted_passphrase==$(echo "${_plaintext_passphrase}" | openssl enc -aes-256-cbc -a -iter 10000)
  # local _encrypted_passphrase==$(echo "${_plaintext_passphrase}" | openssl enc -aes-256-cbc -a -pbkdf2 -iter 10000)
  local _encrypted_passphrase=$(echo "${_plaintext_passphrase}" | openssl enc -aes-256-cbc -a -pbkdf2)
  ## echo "" | openssl enc -aes-256-cbc -a -pbkdf2 -pass stdin > ${_key_filepath}.passphrase
  echo "${_encrypted_passphrase}"
}


function lsd-mod.crypto.openssl-decrypt() {
  ## Decrypt passphrase using openssl, use same algo and iteration as encrypt
  local _in=$1
  local _encrypted_passphrase
  [[ ! -f "${_in}" ]] && _encrypted_passphrase="${_in}" || {
    [[ -f "${_in}" ]] && _encrypted_passphrase="$(cat ${_in})"
  }

  # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a)
  # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a -iter 10000)
  # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a -pbkdf2 -iter 10000)
  local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a -pbkdf2)
  # lsd-mod.log.echo "_decrypted_passphrase: ${_decrypted_passphrase}"

  echo "${_decrypted_passphrase}"
}


function lsd-mod.crypto.ssh-copy-id() {
  local _in=$1
  local _username=$2
  local _host=$3

  [[ -f ${_in} ]] && {

    lsd-mod.log.echo "_in: ${_in}"
    lsd-mod.log.echo "_username: ${_username}"
    lsd-mod.log.echo "_host: ${_host}"

    ssh-copy-id -i ${_in} ${_username}@{_host}
  }
}


function lsd-mod.crypto.ssh-keygen-pubkey() {
  ## ssh-keygen -y -f "${_key_filepath}" > "${pub_key_filepath}"
  ssh-keygen -y -P "${_passphrase}" -f "${_key_filepath}" > "${pub_key_filepath}"
}


function lsd-mod.crypto.ssh-keygen() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

 local SSH_KEYGEN_BASEPATH
  [[ -n "${args['path']+1}" ]] && SSH_KEYGEN_BASEPATH="${args['path']}" || \
    SSH_KEYGEN_BASEPATH="${LSCRIPTS__AUTH}"

 local SSH_KEY_PREFIX
  [[ -n "${args['prefix']+1}" ]] && SSH_KEY_PREFIX="${args['prefix']}-" || \
    SSH_KEY_PREFIX=""

  local __KEY_TIMESTAMP__=$(date -d now +'%d%m%y_%H%M%S')

  local pvt_key_name="${SSH_KEY_PREFIX}${__KEY_TIMESTAMP__}"

  local _key_basepath=${SSH_KEYGEN_BASEPATH}/.ssh
  mkdir -p ${_key_basepath}

  local _key_filepath="${_key_basepath}/${pvt_key_name}"

  [[ -d "${_key_basepath}" ]] && {
    lsd-mod.log.echo "generating ssh keys:: ${_key_basepath}"
    ls -ltr ${_key_basepath}

    local _passphrase
    ## Prompt user for passphrase
    # read -s -p "Enter passphrase: " _passphrase
    ## The -r option is used with read to prevent backslashes from being interpreted as escape characters.
    read -r -s -p "Enter passphrase: " _passphrase

    lsd-mod.log.echo ""

    local resp
    [[ ! -z ${_passphrase} ]] && {
      ## Encrypt passphrase using openssl
      # local _encrypted_passphrase=$(echo "${_passphrase}" | openssl enc -aes-256-cbc -a -salt)
      # local _encrypted_passphrase==$(echo "${_passphrase}" | openssl enc -aes-256-cbc -a -iter 10000)
      # local _encrypted_passphrase==$(echo "${_passphrase}" | openssl enc -aes-256-cbc -a -pbkdf2 -iter 10000)
      local _encrypted_passphrase=$(echo "${_passphrase}" | openssl enc -aes-256-cbc -a -pbkdf2)
      # echo "" | openssl enc -aes-256-cbc -a -pbkdf2 -pass stdin > ${_key_filepath}.passphrase

      ## Decrypt passphrase using openssl: this is for testing
      # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a)
      # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a -iter 10000)
      # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a -pbkdf2 -iter 10000)
      # local _decrypted_passphrase=$(echo "${_encrypted_passphrase}" | openssl enc -aes-256-cbc -d -a -pbkdf2)
      # lsd-mod.log.echo "_decrypted_passphrase: ${_decrypted_passphrase}"

      ## Save passphrase to a file
      echo "${_encrypted_passphrase}" > ${_key_filepath}.passphrase
      ssh-keygen -t rsa -b 4096 -f "${_key_filepath}" -N ${_passphrase}
      resp="${_key_filepath}.passphrase : ${_key_filepath} : ${_key_filepath}.pub"
    } || {
      ssh-keygen -t rsa -b 4096 -f "${_key_filepath}"
      resp=" : ${_key_filepath} : ${_key_filepath}.pub"
    }

  }

  lsd-mod.log.echo "_key_basepath: ${_key_basepath}"
  lsd-mod.log.echo "If the key is for remote login, next:
  1. copy the key to remote machine
  2. create a entry in the ssh config file for seamlesss access: ${_key_basepath}/config

  ssh-copy-id -i ${_key_filepath}.pub <HostUsername>@<HostName>

  vi ${_key_basepath}/config

  Host <HostName>
    HostName <HostIP>
    User <HostUsername>
    IdentityFile ${_key_filepath}
  "

  echo "${resp}"
}
