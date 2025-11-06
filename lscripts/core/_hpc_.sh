#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## HPC (SLURM) job submission and utilities
###----------------------------------------------------------



### Internal helpers
function _lsd_hpc__timestamp() {
  date +'%d%m%y_%H%M%S'
}

function _lsd_hpc__ensure_logdir() {
  local logdir="${1:-logs}"
  mkdir -p "${logdir}"
  echo "${logdir}"
}

### GROUP 1: SUBMIT
function lsd-mod.hpc.submit.generate-slurm-template() {
  ## Generate a SLURM batch script dynamically with provided args.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local job_name partition gpu cpus mem time conda_env output_file
  local _timestamp=$(_lsd_hpc__timestamp)

  job_name=${args['name']:-"hpcjob"}
  partition=${args['partition']:-"gpu-short"}
  gpu=${args['gpu']:-"gpu:1"}
  cpus=${args['cpus']:-8}
  mem=${args['mem']:-"32G"}
  time=${args['time']:-"01:00:00"}
  conda_env=${args['conda']:-""}
  output_file=${args['output']:-"${PWD}/${job_name}_${_timestamp}.slurm"}

  cat <<EOF > "${output_file}"
#!/bin/bash
#SBATCH --job-name=${job_name}
#SBATCH --partition=${partition}
#SBATCH --gres=${gpu}
#SBATCH --cpus-per-task=${cpus}
#SBATCH --mem=${mem}
#SBATCH --time=${time}
#SBATCH --output=logs/${job_name}_%j.out
#SBATCH --error=logs/${job_name}_%j.err

echo "----------------------------------------------------------"
echo "Job Name   : \${SLURM_JOB_NAME}"
echo "Job ID     : \${SLURM_JOB_ID}"
echo "User       : \${USER}"
echo "Node       : \$(hostname)"
echo "GPUs       : \${CUDA_VISIBLE_DEVICES}"
echo "Start Time : \$(date)"
echo "----------------------------------------------------------"

EOF

  [[ -n "${conda_env}" ]] && echo "source /nfs_home/software/miniconda/etc/profile.d/conda.sh && conda activate ${conda_env}" >> "${output_file}"

  echo "✅ Generated SLURM template: ${output_file}"
}


function lsd-mod.hpc.submit.run-job() {
  ## Dynamically inject a script into a generated SLURM wrapper and submit.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local script job_name partition gpu cpus mem time conda_env
  local _timestamp=$(_lsd_hpc__timestamp)
  local logdir=$(_lsd_hpc__ensure_logdir "logs")

  script=${args['script']:-""}
  job_name=${args['name']:-"hpcjob"}
  partition=${args['partition']:-"gpu-short"}
  gpu=${args['gpu']:-"gpu:1"}
  cpus=${args['cpus']:-8}
  mem=${args['mem']:-"32G"}
  time=${args['time']:-"01:00:00"}
  conda_env=${args['conda']:-""}

  if [[ -z "${script}" ]]; then
    echo "❌ Error: --script path required."
    return 1
  fi

  local wrapper="/tmp/${job_name}_${_timestamp}.slurm"
  lsd-mod.hpc.submit.generate-slurm-template --name "${job_name}" --partition "${partition}" --gpu "${gpu}" --cpus "${cpus}" --mem "${mem}" --time "${time}" --conda "${conda_env}" --output "${wrapper}"
  echo "bash ${script}" >> "${wrapper}"

  echo "🚀 Submitting job: ${job_name}"
  sbatch "${wrapper}"
}


function lsd-mod.hpc.submit.run-sh() {
  ## Shortcut for shell job submission.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  lsd-mod.hpc.submit.run-job "$@"
}


function lsd-mod.hpc.submit.run-py() {
  ## Shortcut for Python script job submission.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local script=${args['script']:-""}
  if [[ -z "${script}" ]]; then
    echo "❌ Error: --script path required."
    return 1
  fi
  local tmp=$(mktemp /tmp/lsd_pyjob_XXXX.sh)
  echo "python ${script}" > "${tmp}"
  lsd-mod.hpc.submit.run-job --script "${tmp}" "$@"
}


### GROUP 2: MONITOR
function lsd-mod.hpc.monitor.list-jobs() {
  squeue -u "$USER" -o "%.18i %.9P %.25j %.8u %.2t %.10M %.6D %R"
}

function lsd-mod.hpc.monitor.describe-job() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local jobid=${args['id']:-""}
  [[ -z "${jobid}" ]] && { echo "Usage: --id <jobid>"; return 1; }
  scontrol show job "${jobid}"
}

function lsd-mod.hpc.monitor.tail-job() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local jobid=${args['id']:-""}
  [[ -z "${jobid}" ]] && { echo "Usage: --id <jobid>"; return 1; }
  tail -f logs/*"${jobid}".out
}


### GROUP 3: MANAGE
function lsd-mod.hpc.manage.cancel-job() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local jobid=${args['id']:-""}
  [[ -z "${jobid}" ]] && { echo "Usage: --id <jobid>"; return 1; }
  scancel "${jobid}" && echo "🛑 Job ${jobid} cancelled."
}

function lsd-mod.hpc.manage.cancel-all() {
  scancel -u "$USER"
}

function lsd-mod.hpc.manage.purge-old() {
  ## Remove logs older than N days
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local days=${args['days']:-7}
  find logs -type f -mtime +"${days}" -exec rm -v {} \;
  echo "🧹 Purged logs older than ${days} days."
}


### GROUP 4: AUDIT
function lsd-mod.hpc.audit.summary() {
  echo "JobID,JobName,Partition,AllocCPUS,State,Elapsed,MaxRSS,ReqMem,Start,End"
  sacct -u "$USER" --format=JobID,JobName,Partition,AllocCPUS,State,Elapsed,MaxRSS,ReqMem,Start,End | tail -n +3
}

function lsd-mod.hpc.audit.export-report() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local fmt=${args['format']:-csv}
  local out="audit_report_$(_lsd_hpc__timestamp).${fmt}"
  if [[ "${fmt}" == "csv" ]]; then
    lsd-mod.hpc.audit.summary > "${out}"
  else
    sacct -u "$USER" --json > "${out}"
  fi
  echo "📄 Exported audit report: ${out}"
}


### GROUP 5: RESOURCE
function lsd-mod.hpc.resource.cluster-status() {
  sinfo -o "%.10P %.20N %.8t %.6D %.10C %.10m %.10G"
}

function lsd-mod.hpc.resource.list-gpus() {
  scontrol show nodes | grep "Gres=" | awk -F'=' '{print $2}' | sort | uniq
}


### GROUP 6: SCHEDULE
function lsd-mod.hpc.schedule.chain-jobs() {
  ## Run job B after A completes
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local first=${args['first']:-""}
  local second=${args['second']:-""}
  [[ -z "${first}" || -z "${second}" ]] && { echo "Usage: --first <jobA> --second <jobB>"; return 1; }
  sbatch --dependency=afterok:"${first}" "${second}"
  echo "🔗 Chained ${second} after ${first}"
}
