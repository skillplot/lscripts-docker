#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## System monitoring commands
###----------------------------------------------------------


function monitoring-cmds() {

  local ld=`tput bold`
  local bld=`tput smso`
  local nrml=`tput rmso`
  local reset=`tput reset`
  local red=$(tput setaf 1)
  local normal=$(tput sgr0)
  local rev=$(tput rev)
  local cyan_start="\033[36m"
  local cyan_stop="\033[0m"
  ##
  declare -a processmgmnt=(pstree top iostat ps uname uptime w /sbin/lsmod /sbin/runlevel hostname)
  # declare -a memcmds=(vmstat free pmap top sar time as cat One)
  declare -a memcmds=(vmstat free pmap top sar time)
  declare -a systeminfo=(uname)
  declare -a cmdarry=(Process Memory System)

  local optn

  PS3="Choose (1-${#cmdarry[*]}):"
  echo "Choose from the list below."

  select cmdtypname in ${cmdarry[@]}
  do
    case ${cmdtypname} in
      Process)
          PS3="Choose (1-${#processmgmnt[*]}):"
          select optn in ${processmgmnt[@]}
          do
            # echo "Executing as shell command..."
            ${optn}
            break
          done
          ;;
      Memory)
          PS3="Choose (1-${#memcmds[*]}):"
          select optn in ${memcmds[@]}
          do
            # echo "Executing as shell command..."
            ${optn}
            break
          done
          ;;
      System)
          PS3="Choose (1-${#systeminfo[*]}):"
          select optn in ${systeminfo[@]}
          do
            # echo "Executing as shell command..."
            ${optn}
            break
          done
          ;;
      *)
          ;;
    esac
    if [ "${cmdtypname}" = "" -o "${optn}" = "" ]; then
      echo "Error in entry."
      exit 1
    fi
    break
  done
}

monitoring-cmds
