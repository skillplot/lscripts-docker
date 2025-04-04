#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _system_.monitoring.sh - System Monitoring Functions with JSON-based Argparse
###----------------------------------------------------------
## Logs system resources: CPU, Memory, GPU, Disk Temperatures, I/O, and more
## for analysis using gnuplot or similar tools.
#
## Usage:
## lsd-system.monitoring.main --interval <seconds> --logdir <directory>
#
###----------------------------------------------------------

### GPU Monitoring (Temperature and Fan Speed)
function lsd-mod.system.monitoring.gpu() {
  local logfile="${logdir}/gpu_monitor.log"
  echo "timestamp,temperature,fan_speed" > "$logfile"
  while true; do
    echo "$(date +'%Y-%m-%d %H:%M:%S'),$(nvidia-smi --query-gpu=temperature.gpu,fan.speed --format=csv,noheader,nounits)" >> "$logfile"
    sleep "$interval"
  done
}

### NVMe SSD Temperature Monitoring
function lsd-mod.system.monitoring.nvme_temp() {
  local logfile="${logdir}/nvme_temp.log"
  echo "timestamp,temperature" > "$logfile"
  while true; do
    local temp=$(sudo nvme smart-log /dev/nvme0 | grep -i temperature | awk '{print $3}')
    echo "$(date +'%Y-%m-%d %H:%M:%S'),$temp" >> "$logfile"
    sleep "$interval"
  done
}

### HDD/SSD Temperature Monitoring
function lsd-mod.system.monitoring.drive_temp() {
  local logfile="${logdir}/drive_temp.log"
  echo "timestamp,drive,temperature" > "$logfile"
  local drives=$(lsblk -d -n -o NAME | grep -E 'sd|nvme')
  while true; do
    for drive in $drives; do
      local temp=$(sudo smartctl -A /dev/$drive | grep -i Temperature | awk '{print $10}')
      echo "$(date +'%Y-%m-%d %H:%M:%S'),/dev/$drive,$temp" >> "$logfile"
    done
    sleep "$interval"
  done
}

### CPU Load Monitoring
function lsd-mod.system.monitoring.cpu_load() {
  local logfile="${logdir}/cpu_load.log"
  echo "timestamp,1min,5min,15min" > "$logfile"
  while true; do
    local load=$(cat /proc/loadavg | awk '{print $1","$2","$3}')
    echo "$(date +'%Y-%m-%d %H:%M:%S'),$load" >> "$logfile"
    sleep "$interval"
  done
}

### Memory Usage Monitoring
function lsd-mod.system.monitoring.memory_usage() {
  local logfile="${logdir}/memory_usage.log"
  echo "timestamp,total,used,free,available" > "$logfile"
  while true; do
    local mem=$(free -m | awk '/Mem:/ {print $2","$3","$4","$7}')
    echo "$(date +'%Y-%m-%d %H:%M:%S'),$mem" >> "$logfile"
    sleep "$interval"
  done
}

### I/O Wait and Swap Usage Monitoring
function lsd-mod.system.monitoring.io_swap() {
  local logfile="${logdir}/io_swap.log"
  echo "timestamp,io_wait,swap_total,swap_used,swap_free" > "$logfile"
  while true; do
    local iowait=$(dstat --nocolor 1 1 | grep -Eo '[0-9.]+%wa' | tr -d '%wa')
    local swap=$(free -m | awk '/Swap:/ {print $2","$3","$4}')
    echo "$(date +'%Y-%m-%d %H:%M:%S'),$iowait,$swap" >> "$logfile"
    sleep "$interval"
  done
}

### Top CPU-Consuming Processes Monitoring
function lsd-mod.system.monitoring.top_cpu_processes() {
  local logfile="${logdir}/top_cpu_processes.log"
  echo "timestamp,pid,process,cpu_usage" > "$logfile"
  while true; do
    top -b -n 1 | head -n 12 | tail -n 5 | awk -v date="$(date +'%Y-%m-%d %H:%M:%S')" '{print date","$1","$12","$9}' >> "$logfile"
    sleep "$interval"
  done
}

### Run All Monitors in Parallel
function lsd-mod.system.monitoring.run_all() {
  lsd-mod.system.monitoring.gpu &
  lsd-mod.system.monitoring.nvme_temp &
  lsd-mod.system.monitoring.drive_temp &
  lsd-mod.system.monitoring.cpu_load &
  lsd-mod.system.monitoring.memory_usage &
  lsd-mod.system.monitoring.io_swap &
  lsd-mod.system.monitoring.top_cpu_processes &
  wait
}

### Main function, defined last for readability
function lsd-mod.system.monitoring.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  local timestamp=$(date +'%d%m%y_%H%M%S')
  # local default_logdir="/tmp/logs/_system_.monitoring-${timestamp}"
  local default_logdir="/tmp/logs"

  # JSON schema for argument parsing and help menu
  local json_data='
  {
    "interval": {
      "description": "Logging interval in seconds",
      "opt": "i",
      "default": "5",
      "required": false
    },
    "logdir": {
      "description": "Directory to store logs",
      "opt": "l",
      "default": "'"${default_logdir}"'",
      "required": false
    }
  }'

  # Source argparse-menu.sh for JSON-based argument parsing
  source "${LSCRIPTS}/argparse-menu.sh" "$json_data" "$@"

  # Initialize arguments with defaults or provided values
  local interval="${args[interval]}"
  local logdir="${args[logdir]}"

  mkdir -p "$logdir"
}

# Execute main function
lsd-mod.system.monitoring.main "$@"
