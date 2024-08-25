#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

## Function to generate a timestamp
function generate_timestamp() {
  echo "$(date +'%d%m%y_%H%M%S')"
}

## Function to export a key to a .gpg file in /etc/apt/trusted.gpg.d/
function export_key() {
  local keyid="$1"
  local repo_name="$2"
  
  sudo gpg --export "$keyid" | sudo tee "/etc/apt/trusted.gpg.d/${repo_name}.gpg" > /dev/null
}

## Function to update the APT sources list with the new keyring
function update_sources_list() {
  local repo_name="$1"
  local sources_list="/etc/apt/sources.list.d"
  
  ## Update any source file containing the repository URL with the new keyring reference
  sudo find "$sources_list" -type f -exec sed -i "s|deb .*|deb [signed-by=/etc/apt/trusted.gpg.d/${repo_name}.gpg] &|" {} \;
}

## Function to migrate all keys
function migrate_keys() {
  local legacy_keys_file
  legacy_keys_file="/tmp/legacy_keys-$(generate_timestamp).txt"
  
  ## List all keys and save to file
  sudo apt-key list > "${legacy_keys_file}"
  
  ## Process each key
  grep '^pub' "${legacy_keys_file}" | while IFS= read -r line; do
    local keyid
    keyid=$(echo "${line}" | awk '{print $2}' | cut -d'/' -f2)
    
    ## Get associated repository name
    local repo_name
    repo_name=$(grep -A 1 "$line" "${legacy_keys_file}" | grep 'uid' | sed -e 's/.*<\(.*\)>.*/\1/' -e 's/@.*//' -e 's/[^a-zA-Z0-9]//g')
    
    if [[ -n "$keyid" && -n "$repo_name" ]]; then
      echo "Migrating key: $keyid for repository: $repo_name"
      export_key "$keyid" "$repo_name"
      update_sources_list "$repo_name"
    fi
  done
}

## Main function to coordinate the tasks
function main() {
  migrate_keys
  
  ## Update package lists
  sudo apt update
}

## Execute the main function
main
