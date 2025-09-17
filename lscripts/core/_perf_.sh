#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Performance & profiling utilities
###----------------------------------------------------------


##----------------------------------------------------------
## Get scriptname from path
##----------------------------------------------------------
function lsd-mod.perf._basename() {
  local _fpath="$1"
  echo "$(basename "${_fpath}")"
}

function lsd-mod.perf._ensure_logs_dir() {
  local _logdir="logs"
  [[ -d "${_logdir}" ]] || mkdir -p "${_logdir}"
  echo "${_logdir}"
}


##----------------------------------------------------------
## Run any command/script with /usr/bin/time
##----------------------------------------------------------
function lsd-mod.perf.time() {
  local _script="$1"; shift
  local _timestamp="$(date +'%d%m%y_%H%M%S')"
  local _scriptname="$(basename "${_script}")"
  local _logdir="$(lsd-mod.perf._ensure_logs_dir)"
  local _log="${_logdir}/run_stats.${_scriptname}-${_timestamp}.csv"

  # CSV header
  echo "timestamp,wall_sec,user_sec,sys_sec,mem_mb" > "${_log}"

  # Run and collect stats
  /usr/bin/time -f "%e,%U,%S,%M" \
    -o tmp.perf.$$ \
    bash "${_script}" "$@"

  # Append with timestamp + MB conversion
  awk -v ts="$(date +%s)" -F, '{printf("%s,%s,%s,%s,%.2f\n", ts,$1,$2,$3,$4/1024)}' tmp.perf.$$ >> "${_log}"
  rm -f tmp.perf.$$

  echo "⏱ Perf log written: ${_log}"
}


##----------------------------------------------------------
## Run with detailed -v stats
##----------------------------------------------------------
function lsd-mod.perf.time-verbose() {
  local _script="$1"; shift
  local _timestamp="$(date +'%d%m%y_%H%M%S')"
  local _scriptname="$(basename "${_script}")"
  local _logdir="$(lsd-mod.perf._ensure_logs_dir)"
  local _log="${_logdir}/run_stats.${_scriptname}-${_timestamp}.log"

  /usr/bin/time -v -o "${_log}" bash "${_script}" "$@"
  echo "⏱ Verbose perf log written: ${_log}"
}

##----------------------------------------------------------
## Append to the same file for the given script
## across multiple execution
##----------------------------------------------------------
function lsd-mod.perf.time-append() {
  local _script="$1"; shift
  local _scriptname="$(basename "${_script}")"
  local _logdir="$(lsd-mod.perf._ensure_logs_dir)"
  local _log="${_logdir}/run_stats.${_scriptname}.csv"

  ## Create header only if file does not exist
  if [[ ! -f "${_log}" ]]; then
    echo "timestamp,wall_sec,user_sec,sys_sec,mem_mb,host,cpu,gpu" > "${_log}"
  fi

  /usr/bin/time -f "%e,%U,%S,%M" \
    -o tmp.perf.$$ \
    bash "${_script}" "$@"

  ## Collect host/system info
  local ts="$(date +%s)"
  local host="$(hostname)"
  local cpu="$(lscpu | awk -F: '/Model name/ {print $2; exit}' | xargs)"
  local gpu="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | paste -sd ';' - || echo "None")"

  ## Append with hardware info
  awk -v ts="$ts" -v h="$host" -v c="$cpu" -v g="$gpu" -F, \
    '{printf("%s,%s,%s,%s,%.2f,%s,%s,%s\n", ts,$1,$2,$3,$4/1024,h,c,g)}' \
    tmp.perf.$$ >> "${_log}"

  rm -f tmp.perf.$$

  echo "⏱ Perf log appended: ${_log}"
}


##----------------------------------------------------------
## Run with psrecord (CPU/mem time series)
##----------------------------------------------------------
function lsd-mod.perf.psrecord() {
  local _script="$1"; shift
  local _timestamp="$(date +'%d%m%y_%H%M%S')"
  local _scriptname="$(basename "${_script}")"
  local _logdir="$(lsd-mod.perf._ensure_logs_dir)"
  local _log="${_logdir}/run_usage.${_scriptname}-${_timestamp}.log"
  local _plot="${_logdir}/run_usage.${_scriptname}-${_timestamp}.png"

  type psrecord &>/dev/null || {
    echo "psrecord not installed. Install with: pip install psrecord"
    return 1
  }

  psrecord --log "${_log}" --plot "${_plot}" \
    -- bash "${_script}" "$@"

  echo "📊 Perf log: ${_log}"
  echo "📈 Perf plot: ${_plot}"
}
