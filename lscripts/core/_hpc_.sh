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

### GROUP 7: HELP
function lsd-mod.hpc.help.main() {
  echo "----------------------------------------------------------"
  echo "🚀 LSD HPC Module Help"
  echo "----------------------------------------------------------"
  echo "Semantic Groups:"
  echo "  submit     - Create and run jobs"
  echo "  monitor    - Observe, inspect, or tail jobs"
  echo "  manage     - Control job lifecycle"
  echo "  audit      - Persist and query job metadata"
  echo "  resource   - Cluster and GPU/CPU info"
  echo "  schedule   - Chaining and workflow orchestration"
  echo "  debug      - Inspect runtime env"
  echo "  test       - Validate HPC setup"
  echo "----------------------------------------------------------"
  echo "Use: lsd-hpc.<group>.help to view group-level commands."
  echo "----------------------------------------------------------"
}

function lsd-mod.hpc.help.submit() {
  cat <<EOF
🧠 SUBMIT COMMANDS:
  lsd-hpc.submit.generate-slurm-template   → Generate SLURM batch file
  lsd-hpc.submit.run-job                   → Submit dynamic job
  lsd-hpc.submit.run-sh                    → Submit shell script job
  lsd-hpc.submit.run-py                    → Submit Python script job
  lsd-hpc.submit.run-batch                 → Submit directory of jobs
  lsd-hpc.submit.run-dependent             → Submit dependent job
EOF
}

function lsd-mod.hpc.help.monitor() {
  cat <<EOF
📊 MONITOR COMMANDS:
  lsd-hpc.monitor.list-jobs       → Show active jobs
  lsd-hpc.monitor.describe-job    → Show job details
  lsd-hpc.monitor.tail-job        → Tail job logs live
  lsd-hpc.monitor.history         → Historical job summary
  lsd-hpc.monitor.stats           → Running/queued/failed stats
EOF
}

function lsd-mod.hpc.help.manage() {
  cat <<EOF
🔧 MANAGE COMMANDS:
  lsd-hpc.manage.cancel-job       → Cancel specific job
  lsd-hpc.manage.cancel-all       → Cancel all jobs
  lsd-hpc.manage.purge-old        → Clean old logs
  lsd-hpc.manage.requeue-job      → Requeue failed job
  lsd-hpc.manage.resubmit         → Resubmit from metadata
EOF
}

function lsd-mod.hpc.help.audit() {
  cat <<EOF
📚 AUDIT COMMANDS:
  lsd-hpc.audit.summary           → List job summaries
  lsd-hpc.audit.export-report     → Export to CSV/JSON
  lsd-hpc.audit.view-log          → Display job log
  lsd-hpc.audit.save-job-metadata → Store metadata
  lsd-hpc.audit.load-job-metadata → Retrieve metadata
EOF
}

function lsd-mod.hpc.help.resource() {
  cat <<EOF
⚡ RESOURCE COMMANDS:
  lsd-hpc.resource.cluster-status   → Cluster status
  lsd-hpc.resource.list-gpus        → Available GPU types
  lsd-hpc.resource.list-partitions  → Available partitions
  lsd-hpc.resource.user-quota       → User quota utilization
  lsd-hpc.resource.capacity-overview→ Capacity overview
EOF
}

function lsd-mod.hpc.help.schedule() {
  cat <<EOF
🔁 SCHEDULE COMMANDS:
  lsd-hpc.schedule.chain-jobs     → Chain dependent jobs
  lsd-hpc.schedule.schedule-job   → Time-based scheduling
  lsd-hpc.schedule.batch-submit   → Bulk submission
  lsd-hpc.schedule.workflow       → Multi-stage workflow
EOF
}

### GROUP 8: TEST
function lsd-mod.hpc.test.env() {
  echo "🧪 Checking SLURM binaries..."
  command -v sbatch >/dev/null && echo "✅ sbatch found" || echo "❌ sbatch missing"
  command -v squeue >/dev/null && echo "✅ squeue found" || echo "❌ squeue missing"
  command -v sacct >/dev/null && echo "✅ sacct found" || echo "⚠️ sacct optional"
}

function lsd-mod.hpc.test.template() {
  echo "🧪 Testing SLURM template generation..."
  lsd-mod.hpc.submit.generate-slurm-template --name testjob --output /tmp/testjob.slurm
  [[ -f /tmp/testjob.slurm ]] && echo "✅ Template created" || echo "❌ Template creation failed"
}

function lsd-mod.hpc.test.submit-dryrun() {
  echo "🧪 Dry-run submission (no sbatch execution)..."
  lsd-mod.hpc.submit.generate-slurm-template --name dryrun --output /tmp/dryrun.slurm
  echo "bash echo 'Hello World'" >> /tmp/dryrun.slurm
  echo "✅ Created /tmp/dryrun.slurm for manual sbatch testing"
}

function lsd-mod.hpc.test.all() {
  lsd-mod.hpc.test.env
  lsd-mod.hpc.test.template
  lsd-mod.hpc.test.submit-dryrun
}

### GROUP 9: DEBUG
function lsd-mod.hpc.debug.env() {
  echo "🐞 SLURM ENVIRONMENT VARIABLES:"
  env | grep SLURM_ || echo "No SLURM_* environment variables set."
}

function lsd-mod.hpc.debug.job-context() {
  echo "🐞 Job Context Info:"
  echo "  Job ID      : ${SLURM_JOB_ID:-N/A}"
  echo "  Job Name    : ${SLURM_JOB_NAME:-N/A}"
  echo "  Node        : $(hostname)"
  echo "  GPUs        : ${CUDA_VISIBLE_DEVICES:-N/A}"
  echo "  Working Dir : $(pwd)"
}

function lsd-mod.hpc.debug.show-template() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local path=${args['file']:-""}
  [[ -z "${path}" ]] && { echo "Usage: --file <slurm_template>"; return 1; }
  echo "🐞 Showing SLURM template contents for: ${path}"
  echo "----------------------------------------------------------"
  cat "${path}"
  echo "----------------------------------------------------------"
}
