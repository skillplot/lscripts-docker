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
  local pub_key_name="${SSH_KEY_PREFIX}${__KEY_TIMESTAMP__}.pub"

  local pvt_key_basepath=${SSH_KEYGEN_BASEPATH}/.ssh
  local pub_key_basepath=${SSH_KEYGEN_BASEPATH}/.ssh.pub
  mkdir -p ${pvt_key_basepath} ${pub_key_basepath}

  local _key_filepath="${pvt_key_basepath}/${pvt_key_name}"
  local pub_key_filepath="${pub_key_basepath}/${pub_key_name}"

  [[ -d "${pvt_key_basepath}" ]] && [[ -d "${pub_key_basepath}" ]] && {
    lsd-mod.log.echo "generating ssh keys:: ${pvt_key_basepath}"
    ls -ltr ${pvt_key_basepath}

    local _passphrase
    ## Prompt user for passphrase
    # read -s -p "Enter passphrase: " _passphrase
    ## The -r option is used with read to prevent backslashes from being interpreted as escape characters.
    read -r -s -p "Enter passphrase: " _passphrase

    lsd-mod.log.echo ""
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

    ## ssh-keygen -t rsa -b 4096 -f "${_key_filepath}"
    ssh-keygen -t rsa -b 4096 -f "${_key_filepath}" -N ${_passphrase}

    ## ssh-keygen -y -f "${_key_filepath}" > "${pub_key_filepath}"
    ssh-keygen -y -P "${_passphrase}" -f "${_key_filepath}" > "${pub_key_filepath}"

    [[ -f "${_key_filepath}.pub" ]] && { rm -f "${_key_filepath}.pub"; }
  }

  lsd-mod.log.echo "${pvt_key_basepath} : ${pub_key_basepath}"
  echo "${_key_filepath}.passphrase : ${_key_filepath} : ${pub_key_filepath}"
}
