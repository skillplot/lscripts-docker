#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Utilility functions for nvidia, gpu
###----------------------------------------------------------


function lsd-mod.nvidia.get__vars() {
  lsd-mod.log.echo "NVIDIA_DRIVER_VER: ${bgre}${NVIDIA_DRIVER_VER}${nocolor}"
  lsd-mod.log.echo "NVIDIA_OS_ARCH: ${bgre}${NVIDIA_OS_ARCH}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_REPO_KEY: ${bgre}${NVIDIA_CUDA_REPO_KEY}${nocolor}"
  lsd-mod.log.echo "NVIDIA_GPGKEY_SUM: ${bgre}${NVIDIA_GPGKEY_SUM}${nocolor}"
  lsd-mod.log.echo "NVIDIA_GPGKEY_FPR: ${bgre}${NVIDIA_GPGKEY_FPR}${nocolor}"
  lsd-mod.log.echo "NVIDIA_REPO_BASEURL: ${bgre}${NVIDIA_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_REPO_BASEURL: ${bgre}${NVIDIA_CUDA_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_ML_REPO_BASEURL: ${bgre}${NVIDIA_ML_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_DRIVER_INSTALLED: ${bgre}${NVIDIA_DRIVER_INSTALLED}${nocolor}"
  lsd-mod.log.echo "NVIDIA_DOCKER_CUDA_REPO_URL: ${bgre}${NVIDIA_DOCKER_CUDA_REPO_URL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_DOCKER_URL: ${bgre}${NVIDIA_DOCKER_URL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_DOCKER_KEY_URL: ${bgre}${NVIDIA_DOCKER_KEY_URL}${nocolor}"
}


function lsd-mod.nvidia.version() {
  ## https://stackoverflow.com/questions/40589814/cuda-runtime-version-vs-cuda-driver-version-whats-the-difference
  modinfo nvidia | grep "^version:" | sed 's/^version: *//;'
  cat /proc/driver/nvidia/version
}


function lsd-mod.nvidia.get__driver_avail() {
  declare -a nvidia_driver_avail=($(apt-cache search nvidia-driver | grep -Eo "^nvidia-driver-[0-9]+\s" | cut -d'-' -f3 | sort))
  echo "${nvidia_driver_avail[@]}"
}


function lsd-mod.nvidia.get__driver_info() {
  ###----------------------------------------------------------
  ## After successful Nvidia Driver installation
  ## check version of Driver installed
  ###----------------------------------------------------------

  lsd-mod.log.info "Checking for version of Driver installed..."
  nvidia-settings -q gpus

  # show all attributes
  #info ""
  #info "show all attributes"
  #nvidia-settings -q all

  nvidia-smi
  nvidia-smi -q | grep "Driver Version"
  #nvidia-smi -h
  #nvidia-smi --help-query-gpu
  #nvidia-smi --query-gpu=count,gpu_name,memory.total,driver_version,clocks.max.memory,compute_mode --format=csv,noheader
  nvidia-smi --query-gpu=count,gpu_name,memory.total,driver_version,clocks.max.memory,compute_mode --format=csv

  lsmod | grep -i nouveau # this should not return anything

  lsmod | grep -i nvidia # this should not return anything
  ### sample output
  ## nvidia_drm             49152  0
  ## nvidia_modeset       1114112  1 nvidia_drm
  ## nvidia              18808832  1 nvidia_modeset
  ## drm_kms_helper        204800  2 nvidia_drm,i915
  ## ipmi_msghandler        65536  2 ipmi_devintf,nvidia
  ## drm                   487424  6 drm_kms_helper,nvidia_drm,i915

  type prime-select &>/dev/null && prime-select query # should return: nvidia
}


function lsd-mod.nvidia.get__gpu_stats() {
  local _delay=$1
  [[ ! -z ${_delay} ]] || _delay=5
  lsd-mod.log.debug "_delay: ${_delay} seconds"

  ## dmon is experimental
  # nvidia-smi dmon

  nvidia-smi -L
  # nvidia-smi -L | wc -l

  # https://stackoverflow.com/a/8225492
  # nvidia-smi -q -g 0 -d UTILIZATION -l

  # https://github.com/Syllo/nvtop
  # sudo apt install nvtop
  # https://stackoverflow.com/a/37664194
  # ps f -o user,pgrp,pid,pcpu,pmem,start,time,command -p `lsof -n -w -t /dev/nvidia*`
  # watch -n 0.1 'ps f -o user,pgrp,pid,pcpu,pmem,start,time,command -p `sudo lsof -n -w -t /dev/nvidia*`'


  # watch -n 1 nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu

  ## https://www.slideshare.net/databricks/monitoring-of-gpu-usage-with-tensorflow-models-using-prometheus
  ##nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l ${_delay}
  ## added power.draw
  nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,power.draw,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l ${_delay}

  # nvidia-smi --query-gpu=index,timestamp,power.draw,clocks.sm,clocks.mem,clocks.gr --format=csv

  ## https://github.com/teh/nvidia-smi-prometheus/blob/master/src/Main.hs
  # nvidia-smi dmon -c 10


  # chrome://tracing


  # nvidia-smi --help-query-gpu
  # nvidia-smi -l 1
  # watch -n 1 nvidia-smi

  #function lsd-mod.nvidia.better-nvidia-smi () {
  #    nvidia-smi
  #    join -1 1 -2 3 \
  #        <(nvidia-smi --query-compute-apps=pid,used_memory \
  #                     --format=csv \
  #          | sed "s/ //g" | sed "s/,/ /g" \
  #          | awk 'NR<=1 {print toupper($0)} NR>1 {print $0}' \
  #          | sed "/\[NotSupported\]/d" \
  #          | awk 'NR<=1{print $0;next}{print $0| "sort -k1"}') \
  #        <(ps -a -o user,pgrp,pid,pcpu,pmem,time,command \
  #          | awk 'NR<=1{print $0;next}{print $0| "sort -k3"}') \
  #        | column -t
  #}

  #lsd-mod.nvidia.better-nvidia-smi


  ## TBD: log gpustats
  #nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l >> hmd-06032019.txt
  #nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -lms >> hmd-06032019.txt



  ## TBD
  ##----------------------  
  # nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l 1 -f $1


  ## https://towardsdatascience.com/burning-gpu-while-training-dl-model-these-commands-can-cool-it-down-9c658b31c171
  ## “GPUFanControlState=1” means you can change the fan speed manually, “[fan:0]” means which gpu fan you want to set, “GPUTargetFanSpeed=100” means setting the speed to 100%, but that will be so noisy, you can choose 80%.
  # nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=80"

  ## https://www.andrey-melentyev.com/monitoring-gpus.html
  # https://github.com/Syllo/nvtop#nvtop-build
  # https://github.com/wookayin/gpustat

  # https://timdettmers.com/2018/12/16/deep-learning-hardware-guide/

  # https://developer.android.com/ndk/guides/neuralnetworks
  # https://www.xenonstack.com/blog/log-analytics-deep-machine-learning/
  # https://dzone.com/articles/how-to-train-tensorflow-models-using-gpus
  # https://tutorials.ubuntu.com/tutorial/viewing-and-monitoring-log-files#0
  # https://linoxide.com/linux-command/linux-pidstat-monitor-statistics-procesess/
  # https://www.ubuntupit.com/most-comprehensive-list-of-linux-monitoring-tools-for-sysadmin/ - **best reference**
  # https://www.nagios.com/solutions/linux-monitoring/
  # https://github.com/nicolargo/glances
    # https://glances.readthedocs.io/
    # pip install glances
    # pip install 'glances[action,browser,cloud,cpuinfo,docker,export,folders,gpu,graph,ip,raid,snmp,web,wifi]'

  # https://www.linuxtechi.com/monitor-linux-systems-performance-iostat-command/
  # https://www.linuxtechi.com/generate-cpu-memory-io-report-sar-command/ - **best report generation by hands**

  # cat /etc/sysstat/sysstat
  # sar 2 5 -o /tmp/data > /dev/null 2>&1

  ## https://stackoverflow.com/questions/10508843/what-is-dev-null-21 

  # https://en.wikipedia.org/wiki/Device_file#Pseudo-devices.

  # >> /dev/null redirects standard output (stdout) to /dev/null, which discards it.

  # 2>&1 redirects standard lsd-mod.log.error (2) to standard output (1), which then discards it as well since standard output has already been redirected.

  # & indicates a file descriptor. There are usually 3 file descriptors - standard input, output, and error.


  # Let's break >> /dev/null 2>&1 statement into parts:

  # Part 1: >> output redirection

  # This is used to redirect the program output and append the output at the end of the file
  # https://unix.stackexchange.com/questions/89386/what-is-symbol-and-in-unix-linux

  # Part 2: /dev/null special file

  # This is a Pseudo-devices special file.

  # Command ls -l /dev/null will give you details of this file:

  # crw-rw-rw-. 1 root root 1, 3 Mar 20 18:37 /dev/null
  # Did you observe crw? Which means it is a pseudo-device file which is of character-special-file type that provides serial access.
  # /dev/null accepts and discards all input; produces no output (always returns an end-of-file indication on a read)

  # Part 3: 2>&1 file descriptor

  # Whenever you execute a program, operating system always opens three files STDIN, STDOUT, and STDERR as we know whenever a file is opened, operating system (from kernel) returns a non-negative integer called as File Descriptor. The file descriptor for these files are 0, 1, 2 respectively.

  # So 2>&1 simply says redirect STDERR to STDOUT

  ## https://linoxide.com/tools/vmstat-graphical-mode/
  ## https://github.com/joewalnes/websocketd


  # https://glances.readthedocs.io/en/stable/cmds.html#interactive-commands


  # https://www.vioan.eu/blog/2016/10/10/deploy-your-flask-python-app-on-ubuntu-with-apache-gunicorn-and-systemd/
  # https://www.linode.com/docs/applications/big-data/how-to-move-machine-learning-model-to-production/
  # https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
  # https://blog.keras.io/building-a-simple-keras-deep-learning-rest-api.how-to-move-machine-learning-model-to-production
}


###----------------------------------------------------------
## Internal helpers
###----------------------------------------------------------
function _lsd_nvidia__timestamp() {
  date +'%d%m%y_%H%M%S'
}

function _lsd_nvidia__ensure_logdir() {
  local logdir="${1:-/tmp/gpustats}"
  mkdir -p "${logdir}"
  echo "${logdir}"
}

function _lsd_nvidia__filesize_bytes() {
  local f="$1"
  [[ -f "${f}" ]] || { echo 0; return 0; }
  stat -c%s "${f}" 2>/dev/null || echo 0
}

function _lsd_nvidia__gpu_stats_header() {
  echo "timestamp, name, pci.bus_id, driver_version, pstate, pcie.link.gen.max, pcie.link.gen.current, temperature.gpu, power.draw [W], utilization.gpu [%], utilization.memory [%], memory.total [MiB], memory.free [MiB], memory.used [MiB]"
}

function _lsd_nvidia__gpu_stats_row_cmd() {
  # NOTE: keep this aligned with the header above
  echo "nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,power.draw,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv,noheader -l"
}

###----------------------------------------------------------
## GPU STATS (LOGGING WITH ROLLING FILES)
###----------------------------------------------------------
function lsd-mod.nvidia.get__gpu_stats_log() {
  local _delay="$1"
  [[ -n "${_delay}" ]] || _delay=1

  local _logdir
  _logdir="$(_lsd_nvidia__ensure_logdir "/tmp/gpustats")"

  local _user
  _user="$(id -un 2>/dev/null || whoami)"

  local _ts
  _ts="$(_lsd_nvidia__timestamp)"

  local _i=0
  local _max_bytes=$((100 * 1024 * 1024))  # 100 MB

  local _outfile="${_logdir}/gpustats-${_user}-${_ts}-${_i}.csv"

  lsd-mod.log.debug "_delay: ${_delay} seconds"
  lsd-mod.log.info "Logging GPU stats to: ${_outfile}"
  lsd-mod.log.info "Rolling cutoff: 100 MB per file"
  lsd-mod.log.info "Stop with: Ctrl+C"

  # Write header for first file
  _lsd_nvidia__gpu_stats_header > "${_outfile}"

  # Build the streaming command
  local _cmd
  _cmd="$(_lsd_nvidia__gpu_stats_row_cmd) ${_delay}"

  # Stream rows; rotate when file reaches cutoff
  # stdbuf ensures line-buffering so rotation checks happen promptly.
  eval "stdbuf -oL ${_cmd}" | while IFS= read -r line; do
    local _sz
    _sz="$(_lsd_nvidia__filesize_bytes "${_outfile}")"

    if [[ "${_sz}" -ge "${_max_bytes}" ]]; then
      _i=$((_i + 1))
      _outfile="${_logdir}/gpustats-${_user}-${_ts}-${_i}.csv"
      lsd-mod.log.info "Rolling log -> ${_outfile}"
      _lsd_nvidia__gpu_stats_header > "${_outfile}"
    fi

    echo "${line}" >> "${_outfile}"
  done
}

###----------------------------------------------------------
## HELP
###----------------------------------------------------------
function lsd-mod.nvidia.help.main() {
  echo "----------------------------------------------------------"
  echo "📚 LSD NVIDIA MODULE HELP"
  echo "----------------------------------------------------------"
  echo "Semantic Groups:"
  echo "  cfg      - Show configured NVIDIA variables"
  echo "  driver   - Driver version / availability / info"
  echo "  gpu      - GPU stats (live + logging)"
  echo "----------------------------------------------------------"
  echo "Use: lsd-nvidia.help.<group> to view group-level commands."
  echo "----------------------------------------------------------"
}

function lsd-mod.nvidia.help.cfg() {
  cat <<'EOF'
⚙️ CFG COMMANDS:
  lsd-nvidia.cfg
      → Print NVIDIA-related environment/config variables
EOF
}

function lsd-mod.nvidia.help.driver() {
  cat <<'EOF'
🧱 DRIVER COMMANDS:
  lsd-nvidia.driver.avail
      → List available NVIDIA driver versions from apt cache

  (via module function)
  lsd-mod.nvidia.version
      → Print installed driver version info (modinfo + /proc)
      
  lsd-nvidia.gpu.info
      → Post-install sanity checks (nvidia-smi, settings, modules, prime-select)
EOF
}

function lsd-mod.nvidia.help.gpu() {
  cat <<'EOF'
📈 GPU COMMANDS:
  lsd-nvidia.gpu.stats [delay_secs]
      → Live CSV output to terminal (defaults to 5 in your current function)

  lsd-nvidia.gpu.stats-log [delay_secs]
      → Log GPU stats CSV to /tmp/gpustats with rolling files
      → Output file format:
          /tmp/gpustats/gpustats-<username>-<ddmmyy_hhmmss>-<i>.csv
      → Rolling cutoff:
          100 MB per file
      → delay_secs defaults to 1
      → Stop with Ctrl+C
EOF
}
