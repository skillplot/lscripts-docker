#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## I/O utility functions
#
## From config/color-cfg.sh, following colors being used for keeping without external dependency
## local bcya='\e[1;36m'
## local bwhi='\e[1;37m'
## local byel='\e[1;33m'
#
## References:
##  - https://stackoverflow.com/a/49805832/748469
##  - https://superuser.com/questions/247127/what-is-and-in-linux
##  - https://stackoverflow.com/a/29436423/748469
##  - https://stackoverflow.com/a/29512084/748469
###----------------------------------------------------------


function lsd-mod.fio.yesno_no() {
  ## default is No
  local msg
  [[ $# -eq 0 ]] && msg="Are you sure" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}? \e[1;37m\e[1;31m[y/N]\e[1;33m>\e[0m ")
  [[ $(read -e -p "${msg}"; echo ${REPLY}) == [Yy]* ]] && return 0 || return -1
}


function lsd-mod.fio.yesno_yes() {
  ## default is Yes
  local msg
  [[ $# -eq 0 ]] && msg="Are you sure" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}? \e[1;37m\e[1;31m[Y/n]\e[1;33m>\e[0m ")
  [[ $(read -e -p "${msg}"; echo ${REPLY}) == [Nn]* ]] && return -1 || return 0
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


function lsd-mod.fio.input_loop() {
  local msg
  local response

  [[ $# -eq 0 ]] && msg="Enter input" || msg="$*"
  msg=$(echo -e "\e[1;36m${msg}?\e[1;37m\e[1;31m[*]\e[1;33m>\e[0m ")
  while true; do
    read -p "${msg}" response
    [[ -z ${response} ]] || break
  done
  echo ${response}
}


function lsd-mod.fio.get_yesno_default() {
  local _default=yes
  lsd-mod.fio.yesno_yes "Set default [Y/n] for all steps." && {
      _default=yes
      lsd-mod.log.echo "Setting to: ${_default}"
    } || {
      _default=no
      lsd-mod.log.echo "Setting to: ${_default}"
    }
    echo ${_default}
}


function lsd-mod.fio.find_in_array() {
  ## Credits:
  ## * https://stackoverflow.com/a/11525897/748469
  ## * https://stackoverflow.com/a/10433783
  ## example:
  ## some_words=( these are some words )
  ## lsd-mod.fio.find_in_array itemvalue "${some_array_of_items[@]}" || echo "expected missing! since words != word"

  local item=$1
  local e
  # shift
  # for e in "$@"; do [[ "$e" == "$item" ]] && return 0; done; return 1;
  for e in "${@:2}"; do [[ "$e" = "$item" ]] && return 0; done; return 1;
  # for e in "${@:2}"; do [[ "$e" == "$item" ]] && return 0; done; return 1;
}


function lsd-mod.fio.inject_in_file() {
  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  [[ "$#" -ne "2" ]] && lsd-mod.log.fail "Invalid number of paramerters: required 2 given $#"

  [[ -n "${args['line']+1}" ]] && [[ -n "${args['file']+1}" ]] && {
    # (>&2 echo -e "key: 'line' exists")

    local LINE=${args['line']}
    local FILE=${args['file']}

    [[ ! -f ${FILE} ]] || FILE="${HOME}/.bashrc"

    lsd-mod.log.debug Modifying: ${FILE}
    lsd-mod.log.debug Adding: ${LINE}

    grep -qF "${LINE}" "${FILE}" || echo "${LINE}" >> "${FILE}"
    # source ${FILE}
    echo ${FILE}
  } || lsd-mod.log.error "Invalid paramerters!"
}


function lsd-mod.fio.debug_logger() {
  local ll
  ##local N=8
  local N=${#_logger_[@]}
  for ll in $(seq ${N} -1 1); do
    ## Enable the loglevel
    export LSCRIPTS__LOG_LEVEL=${ll}

    # (>&2 echo -e "LSCRIPTS__LOG_LEVEL: ${LSCRIPTS__LOG_LEVEL}")
    (>&2 echo -e "${on_pur}Logger Initialized with LSCRIPTS__LOG_LEVEL: ${LSCRIPTS__LOG_LEVEL} or ${_logger_[${LSCRIPTS__LOG_LEVEL}]}${nocolor}")

    sleep 0.5s
    lsd-mod.log.stacktrace "stacktrace"
    sleep 0.5s
    lsd-mod.log.debug "debug"
    sleep 0.5s
    lsd-mod.log.success "success"
    sleep 0.5s
    lsd-mod.log.ok "ok"
    sleep 0.5s
    lsd-mod.log.info "info"
    sleep 0.5s
    lsd-mod.log.warn "warn"
    sleep 0.5s
    lsd-mod.log.error "error"
    sleep 0.5s
  done

  lsd-mod.log.fail "fail"
  (>&2 echo -e "## This line and anything below should printed or executed!")
  (>&2 echo -e "I never get's to see the Helllllllllll!")
}


function lsd-mod.fio.print_assoc_array() {
  ## Bash 4+ only
  local var=$(declare -p "$1")
  eval "declare -A _arr="${var#*=}
  for k in "${!_arr[@]}"; do
    echo "$k: ${_arr[$k]}"
  done
}


function lsd-mod.fio.exec_cmd_test() {
  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  # ## Bash 4+ only
  # local var=$(declare -p "$1")
  # eval "declare -A args="${var#*=}

  # local -n args="${1}"
  # declare -A args="${1}"
  lsd-mod.log.warn "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && lsd-mod.log.echo "${key} = ${args[${key}]}" || lsd-mod.log.error "Key does not exists: ${key}"
  done
}


function lsd-mod.fio.dir_to_link() {
  local this_dir
  echo "Enter the direcorty to move and replace it with a symlink:"
  read this_dir

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  local that_dir=${this_dir}-${timestamp}

  [[ -d ${this_dir} ]] && {
    mv ${this_dir} ${that_dir}
    ln -s ${that_dir} ${this_dir}
  } || echo "Not a valid direcorty name: ${this_dir}"
}


function lsd-mod.fio.pdf_to_image() {
  local fullfilename
  echo "Enter the pdf file path:"
  read fullfilename

  local filename=$(basename "$fullfilename")
  local fname="${filename%.*}"
  local ext="${filename##*.}"

  [[ -f ${fullfilename} ]] && [[ ${ext}=='pdf' ]] && {
    local timestamp=$(date -d now +'%d%m%y_%H%M%S')
    local outputdir=${fname}-${timestamp}

    type pdfimages &>/dev/null && {
      mkdir -p ${outputdir}
      pdfimages -j ${fullfilename} ${outputdir}/
    } || {
      lsd-mod.log.error "graphicsmagick not installed! Install it by executing:"
      lsd-mod.log.echo "sudo apt install graphicsmagick"
    }

  } || echo "Invalid file: ${fullfilename}"
}


function lsd-mod.fio.image_to_pdf() {
  ## resize images
  # for file in *.jpg; do convert $file -resize 25% r-$file; done

  ## Convert Images to PDF
  # sudo apt install graphicsmagick

  # gm convert *.jpg $(date -d now +'%d%m%y_%H%M%S').pdf
  local pdf_filename=$(date -d now +'%d%m%y_%H%M%S').pdf

  type gm &>/dev/null && {
    gm convert *.jpg ${pdf_filename}
    ## view the pdf file
    
    type evince &>/dev/null && evince ${pdf_filename} || lsd-mod.log.warn "PDF viewer evince not installed to view the file"
  } || {
    lsd-mod.log.error "graphicsmagick not installed! Install it by executing:"
    lsd-mod.log.echo "sudo apt install graphicsmagick"
  }
}


function lsd-mod.fio.filename() {
  local dirpath
  lsd-mod.log.echo "Enter the directory path [ Press Enter for default: /tmp]:"
  read dirpath

  [[ -d "${dirpath}" ]] && dirpath=${dirpath%/} || dirpath="/tmp"
  lsd-mod.log.echo "Using directory path: ${dirpath}"
  local _filename="${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S')"
  echo ${_filename}
}

function lsd-mod.fio.filename-tmp() {
  local dirpath="/tmp"
  echo "${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S').log"
}


function lsd-mod.fio.image_to_pdf_prompt() {
  local dirpath
  echo "Enter the directory path containing images to be converted to pdf:"
  read dirpath

  [[ -d "${dirpath}" ]] && {
    dirpath=${dirpath%/}
    # local filename=$(basename "${dirpath}")
    # echo ${@%/}
    # echo ${dirpath%/}
    # local pdf_filename="$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S').pdf"
    local pdf_filename="${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S').pdf"

    echo "pdf_filename: ${pdf_filename}"
    ## pdf to images
    # pdfimages -j somefile.pdf outputdir/

    ## resize images
    # for file in *.jpg; do convert $file -resize 25% r-$file; done

    ## Convert Images to PDF
    # sudo apt install graphicsmagick

    # gm convert *.jpg $(date -d now +'%d%m%y_%H%M%S').pdf
    gm convert "${dirpath}/*.png" ${pdf_filename}

    [[ -f "${pdf_filename}" ]] && {
      ## view the pdf file
      type evince &>/dev/null && evince ${pdf_filename} || lsd-mod.log.warn "PDF viewer evince not installed to view the file"
    }

  } || echo "Invalid path: ${dirpath}"
}


function lsd-mod.fio.mkdir() {
  ## get dir name
  local _dirname="$1"
  ## get permission, set default to 0755
  local _permission=${2:-0755} && lsd-mod.log.info "_permission: ${_permission}"
  [[ "$#" -eq 0 ]] && { lsd-mod.log.echo "$0: dirname"; return; }
  [[ ! -d "${_dirname}" ]] && mkdir -m "${_permission}" -p "${_dirname}"
}
