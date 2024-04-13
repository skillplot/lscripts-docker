#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


function git.get.repo-urls.main() {
  ## ls -d $PWD/*
  local dirpath
  echo "Enter the directory path to extract git urls from:"
  read dirpath

  [[ -d "${dirpath}" ]] && {
    dirpath=${dirpath%/}
    declare dir_array=($(ls -d ${dirpath}/*))

    ## local filepath=/tmp/$(date +"%d%m%y_%H%M%S-%N_XXXXXX")-git-urls.sh
    # local filepath="${dirpath}/$(basename "${dirpath}")-git-urls-$(date -d now +'%d%m%y_%H%M%S').sh"
    # local filepath="${dirpath}/$(basename "${dirpath}")-git-urls-$(date +"%d%m%y_%H%M%S-%N_XXXXXX").sh"
    local filepath="${dirpath}/$(basename "${dirpath}")-git-urls-$(date +"%d%m%y_%H%M%S-XXXXXX").sh"
    echo "filepath: ${filepath}"
    filepath=$(mktemp ${filepath})


    ## touch ${filepath}
    ls -ltr ${filepath}

    echo "dir_array: ${dir_array[@]}"
    echo "==========================="

    echo "filepath: ${filepath}"
    echo "==========================="
    for repo in "${dir_array[@]}"; do
      cd ${repo}
      local LINE=$(echo "git clone https:"$(git remote -v | grep -i fetch | cut -d':' -f2 | cut -d' ' -f1))
      echo "${LINE}"
      grep -qF "${LINE}" "${filepath}" || echo "${LINE}" >> "${filepath}"
    done
  }
}

git.get.repo-urls.main
