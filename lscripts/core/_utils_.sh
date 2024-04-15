#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Utility functions
###----------------------------------------------------------
#
## References:
## * https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display
###----------------------------------------------------------


###----------------------------------------------------------
## General utilities
###----------------------------------------------------------


function lsd-mod.utils.tmux-4pane() {
  tmux new-session -d -s 4p-$(date -d now +'%d%m%y_%H%M%S')
  tmux split-window -h
  tmux split-window -v
  tmux select-pane -t 0
  tmux split-window -v
  tmux -2 attach-session -d
}


function lsd-mod.utils.tmux-3pane() {
  tmux new-session -s 3p-$(date -d now +'%d%m%y_%H%M%S') \; \
      split-window -h -p 50 \; \
      split-window -v -p 50 \;
}


function lsd-mod.utils.youtube-download-mp3() {
  ## Specify the file containing the list of items
  local tmp_download_dir="/tmp/mp3"
  local filepath="/tmp/mp3/list.txt"

  type yt-dlp &>/dev/null && {
    mkdir -p ${tmp_download_dir}
    ## Check if the file exists
    if [ -e "${filepath}" ]; then
      ## Read each line from the file and process it
      while IFS= read -r line; do
        lsd-mod.log.echo "Processing item: ${line}"
        local timestamp=$(date -d now +'%d%m%y_%H%M%S')
        yt-dlp --extract-audio --audio-format mp3 ${line} -o "${tmp_download_dir}/${timestamp}.mp3"
      done < "${filepath}"
    else
      lsd-mod.log.echo "File not found: ${filepath}"
    fi
  } || {
    lsd-mod.log.echo "yt-dlp command not found. Install using following command:"
    lsd-mod.log.echo "pip install yt-dlp"
  }
}


function lsd-mod.utils.count-lines() {
  local res
  local ext=$1
  [[ ! -z ${ext} ]] && res=`find . -iname "*.${ext}" -type f -exec cat {} + | wc -l` || {
    res=`find . -type f -exec cat {} + | wc -l`
  }
  echo ${res}
}

function lsd-mod.utils.random() {
  local N=$1
  [[ -z ${N} ]] && N=4
  echo $(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c $N)
}


function lsd-mod.utils.size() {
  du -cksh * | sort -h
  # du -sh -- * | sort -h
}


function lsd-mod.utils.pid() {
  [[ ! -z $1 ]] && (>&2 echo -e $(pgrep -f $1));
}


function lsd-mod.utils.alpha-numeric() {
  ## only alpha-numeric values are allowed
  [[ ! -z $1 ]] && (>&2 echo -e $(tr -dc '0-9a-zA-Z' <<< "$1"));
}


###----------------------------------------------------------
## lsd-mod.utils.kill Terminating utilities
###----------------------------------------------------------

function lsd-mod.utils.kill() {
  [[ ! -z $1 ]] && sudo kill -9 $(pgrep -f $1);
}


function lsd-mod.utils.kill.python() {
  lsd-mod.utils.kill python;
}


# function lsd-mod.utils.kill.python() {
#   sudo kill -9 $(pgrep -f python);
# }


###----------------------------------------------------------
## lsd-mod.utils.ls listing utilities
###----------------------------------------------------------


function lsd-mod.utils.lsdir() {
  declare -a arr=($(ls -d -1 $PWD/*))
  echo "${#arr[@]}"
}


function lsd-mod.utils.ls() {
  ls -lrth | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf("%0o ",k);print}';
}


function lsd-mod.utils.ls.pycache() {
  ## __pycache__ egg-info
  find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'ls -dl "$0"';
}


function lsd-mod.utils.ls.egg() {
  find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'ls -dl "$0"';
}


###----------------------------------------------------------
## lsd-mod.utils.rm removing/deletion/trash utilities
###----------------------------------------------------------

function lsd-mod.utils.rm.pycache() {
  find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'rm -rf "$0"';
}


function lsd-mod.utils.rm.egg() {
  find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'rm -rf "$0"';
}


function lsd-mod.utils.rm.node_modules() {
  find ${PWD}/ -iname node_modules -type d | xargs -n 1 bash -c 'rm -rf "$0"'
}


function lsd-mod.utils.rm._site() {
  find ${PWD}/ -iname _site -type d | xargs -n 1 bash -c 'rm -rf "$0"'
}



function lsd-mod.utils.trash() {
  for item in "$@" ; do echo "Trashing: $item" ; mv "$item" ${HOME}/.Trash/; done
}

###----------------------------------------------------------
## lsd-mod.utils.image Image utilities
###----------------------------------------------------------

function lsd-mod.utils.image.resize() {
  local file
  for file in *.${1:-'jpg'}; do convert ${file} -resize ${2:-'50'}% $(date -d now +'%d%m%y_%H%M%S')---${file}; done
}


function lsd-mod.utils.image.pdf() {
  gm convert *.${1:-'jpg'} $(date -d now +'%d%m%y_%H%M%S').pdf;
}


function lsd-mod.utils.image.tiff2cog() {
  local LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  local scriptname=$(basename ${BASH_SOURCE[0]})

  source ${LSCRIPTS}/argparse.sh "$@"

  local filepath
  local filepath_cog

  
  [[ -n "${args['path']+1}" ]] && filepath=${args['path']}

  type uuid &>/dev/null && {
    filepath_cog="/tmp/$(uuid).tif"

    lsd-mod.log.debug "filepath: ${filepath}"
    lsd-mod.log.debug "filepath_cog: ${filepath_cog}"

    type gdal_translate &>/dev/null && {
      # (>&2 echo -e "key: 'line' exists")
      gdal_translate -co TILED=YES -co COMPRESS=DEFLATE -co BIGTIFF=YES ${filepath} ${filepath_cog}
    } 2>/dev/null
  }
}


###----------------------------------------------------------
## lsd-mod.utils.pdf PDF utilities
###----------------------------------------------------------

function lsd-mod.utils.pdf.images() {
  local file
  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  for file in *.${1:-'pdf'}; do

    ## filename specific output directory
    local filename=$(echo "${file}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9._-]/_/g')
    local fname="${filename%.*}"
    local ext="${filename##*.}"

    # local outputdir=${timestamp}
    # local outputdir="${fname}-${timestamp}"
    local outputdir="${timestamp}/${fname}"

    type pdfimages &>/dev/null && {
      mkdir -p ${outputdir}
      pdfimages -j ${filename} ${outputdir}/
      lsd-mod.log.echo "fname: ${fname} => ${outputdir}"
    }
  done
}


###----------------------------------------------------------
## lsd-mod.utils.date Date utilities
###----------------------------------------------------------

function lsd-mod.utils.date.get() {
  echo $(date +"%d-%b-%Y, %A");
}


###----------------------------------------------------------
## lsd-mod.utils.convert
###----------------------------------------------------------


function lsd-mod.utils.convert.utf8() {
  ## https://fedingo.com/how-to-convert-files-to-utf-8-in-linux/
  local _file
  local _convert
  local _from_encoding
  local _to_encoding="UTF-8"
  declare -a _files=($(ls -1 $PWD/*))

  for _file in ${_files[@]}; do
    _from_encoding=$(file -b --mime-encoding ${_file})
    ## convert to uppercase
    _from_encoding=${_from_encoding^^}
    lsd-mod.log.echo "_from_encoding: ${_from_encoding}"

    _convert="iconv -f ${_from_encoding} -t ${_to_encoding}"
    lsd-mod.log.echo ${_convert} "${_file}" -o  "${_file%}.utf8"
  done
}


###----------------------------------------------------------
## lsd-mod.utils.system
###----------------------------------------------------------

function lsd-mod.utils.system.info() {
  type inxi &>/dev/null && inxi -Fxzd;
}


###----------------------------------------------------------
## lsd-mod.utils.id Identification utilities
###----------------------------------------------------------

function lsd-mod.utils.id.salt() {
  ###----------------------------------------------------------
  ## To generate security keys and salts
  ###----------------------------------------------------------
  ## References:
  ## https://gist.github.com/earthgecko/3089509
  ###----------------------------------------------------------
  ## Credit: https://gist.github.com/fjarrett
  ## To generate WordPress security keys and salts for a wp-config.php file:
  ## https://api.wordpress.org/secret-key/1.1/salt/
  ## 64 random printable characters
  ## Excludes: space, double quote, single quote, and backslash
  echo $(cat /dev/urandom | tr -dc [:print:] | tr -d '[:space:]\042\047\134' | fold -w 64 | head -n 1)
  ## jVig,+1&z3]}DT*$pvXPY#!z!^A-;[c0n!c*Ju=fy9`+yOauYAve<#fL]?>B9U;/
}


function lsd-mod.utils.id.get() {
  echo $(uname -a && date) | md5sum | cut -f1 -d" " | head -c ${1:-33}
}


function lsd-mod.utils.id.uuid() {
  ###----------------------------------------------------------
  ## generate uuid without `uuid` apt utility package
  ###----------------------------------------------------------
  ## References:
  ## https://gist.github.com/earthgecko/3089509
  ###----------------------------------------------------------

  # local charlen=5
  # echo $(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 32)
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null)
  # echo $(tr -dc '[:alnum:]' '[:lower:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null)
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=1 count=32 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=1 count=5 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=1 count=${charlen} 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(base64 /dev/urandom | tr -d '/+' | head -c 32 | tr '[:upper:]' '[:lower:]')
  # echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${charlen} | head -n 1)
  # # enerates a 24-char string consisting of any printable ASCII character from ! to ~.
  # # Change 24 to whatever length you require, obviously.
  # echo $(head -c24 < <(tr -dc '\041-\176' < /dev/urandom)()
  # # Slight update to prevent password containing single quotes, making it easier to quote a variable containing the password.
  # echo $(head -c24 < <(tr --delete --complement '\041-\046\048-\176' < /dev/urandom)()


  ## Credit: https://gist.github.com/sergeyklay
  ## Generate UUID-like strings: c8521ea3-0f42-4e36-aba7-6de2d7c20725
  echo $(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
}


function lsd-mod.utils.id.filename() {
  local dirpath
  lsd-mod.log.echo "Enter the directory path [ Press Enter for default: /tmp]:"
  read dirpath

  [[ -d "${dirpath}" ]] && dirpath=${dirpath%/} || dirpath="/tmp"
  lsd-mod.log.echo "Using directory path: ${dirpath}"
  local _filename="${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S')"
  echo ${_filename}
}


function lsd-mod.utils.id.filename-tmp() {
  local dirpath="/tmp"
  echo "${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S').log"
}


function lsd-mod.utils.cmds() {
  local _cmd_prefix=$1
  [[ ! -z "${_cmd_prefix}" ]] && {
    (
      local LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
      local scriptname=$(basename ${BASH_SOURCE[0]})
      [ -f ${LSCRIPTS}/../lscripts.env.sh ] && source ${LSCRIPTS}/../lscripts.env.sh
      # type compgen &>/dev/null && compgen -c | grep "${_cmd_prefix}-"
      type compgen &>/dev/null && compgen -c | grep -v "${_cmd_prefix}-mod" | grep -v ".main" | grep "${_cmd_prefix}-"
    ) 2>/dev/null
  }
}


function lsd-mod.utils.python.venvname() {
  local LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  local scriptname=$(basename ${BASH_SOURCE[0]})

  source ${LSCRIPTS}/argparse.sh "$@"

  local py=python3
  local pip=pip3

  local pyPath
  # local pipPath
  # local pipVer

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})
  # type ${pipPath} &>/dev/null && pipPath=$(which ${pip})
  # type ${pipVer} &>/dev/null && pipVer=$(${pip} --version)

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.debug "py: ${py}"
  lsd-mod.log.debug "pyPath: ${pyPath}"

  local pipPath=$(which ${pip})
  # local pipVer=$(${pip} --version)

  type ${pyPath} &>/dev/null && {
    # (>&2 echo -e "key: 'line' exists")

    ## this is the fullpath of the input python executable you want to use
    local __pyVer=$(${py} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
    # local _timestamp=$(lsd-mod.date.get__timestamp)
    # local _timestamp="$(date -d now +'%d%m%y_%H%M%S')"
    local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  } 2>/dev/null
  echo "${py_env_name}"
}
