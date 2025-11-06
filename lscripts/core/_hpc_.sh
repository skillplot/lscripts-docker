#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## HPC (SLURM) job submission, monitoring, management,
## auditing, debugging, and scheduling utilities.
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

  # --- Safe fallback mapping in case argparse fails ---
  for arg in "$@"; do
    case $arg in
      --name) shift; job_name="$1"; shift ;;
      --partition) shift; partition="$1"; shift ;;
      --gpu) shift; gpu="$1"; shift ;;
      --cpus) shift; cpus="$1"; shift ;;
      --mem) shift; mem="$1"; shift ;;
      --time) shift; time="$1"; shift ;;
      --conda) shift; conda_env="$1"; shift ;;
      --output) shift; output_file="$1"; shift ;;
    esac
  done

  # --- Defaults if missing ---
  job_name=${job_name:-"hpcjob"}
  partition=${partition:-"gpu-short"}
  gpu=${gpu:-"gpu:1"}
  cpus=${cpus:-8}
  mem=${mem:-"32G"}
  time=${time:-"01:00:00"}
  output_file=${output_file:-"${PWD}/${job_name}_${_timestamp}.slurm"}

  local logdir=$(_lsd_hpc__ensure_logdir "logs")

  cat <<EOF > "${output_file}"
#!/bin/bash
#SBATCH --job-name=${job_name}
#SBATCH --partition=${partition}
#SBATCH --gres=${gpu}
#SBATCH --cpus-per-task=${cpus}
#SBATCH --mem=${mem}
#SBATCH --time=${time}
#SBATCH --output=${logdir}/${job_name}_%j.out
#SBATCH --error=${logdir}/${job_name}_%j.err

echo "----------------------------------------------------------"
echo "Job Name   : \${SLURM_JOB_NAME}"
echo "Job ID     : \${SLURM_JOB_ID}"
echo "User       : \${USER}"
echo "Node       : \$(hostname)"
echo "GPUs       : \${CUDA_VISIBLE_DEVICES}"
echo "Start Time : \$(date)"
echo "----------------------------------------------------------"
EOF

  if [[ -n "${conda_env}" ]]; then
    echo "source /nfs_home/software/miniconda/etc/profile.d/conda.sh" >> "${output_file}"
    echo "conda activate ${conda_env}" >> "${output_file}"
  fi

  echo "✅ Generated SLURM template: ${output_file}"
}

function lsd-mod.hpc.submit.run-job() {
  ##----------------------------------------------------------
  ## Submit a job to SLURM, with or without config file.
  ## Supports YAML (.yaml/.yml) or JSON (.json) configs.
  ##----------------------------------------------------------
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local config script job_name partition gpu cpus mem time conda_env logdir dryrun
  local _timestamp=$(_lsd_hpc__timestamp)
  logdir=$(_lsd_hpc__ensure_logdir "logs")

  ##----------------------------------------------------------
  ## Parse CLI args
  ##----------------------------------------------------------
  config=${args['config']:-""}
  script=${args['script']:-""}
  job_name=${args['name']:-""}
  partition=${args['partition']:-""}
  gpu=${args['gpu']:-""}
  cpus=${args['cpus']:-""}
  mem=${args['mem']:-""}
  time=${args['time']:-""}
  conda_env=${args['conda']:-""}
  dryrun=${args['dryrun']:-false}

  ##----------------------------------------------------------
  ## If a config file is provided, detect its type and parser.
  ##----------------------------------------------------------
  if [[ -n "${config}" && -f "${config}" ]]; then
    local ext="${config##*.}"
    case "$ext" in
      yaml|yml)
        if ! command -v yq >/dev/null 2>&1; then
          echo "❌ Error: YAML config detected but 'yq' not found."
          echo "   Please install with:"
          echo "   conda install -c conda-forge yq"
          return 1
        fi
        echo "📄 Loading YAML job config: ${config}"
        job_name=$(yq -r '.job.name' "${config}")
        partition=$(yq -r '.job.partition' "${config}")
        gpu=$(yq -r '.job.gpu' "${config}")
        cpus=$(yq -r '.job.cpus' "${config}")
        mem=$(yq -r '.job.mem' "${config}")
        time=$(yq -r '.job.time' "${config}")
        conda_env=$(yq -r '.job.conda' "${config}")
        script=$(yq -r '.job.script' "${config}")
        logdir=$(yq -r '.job.logdir' "${config}")
        dryrun=$(yq -r '.job.dryrun' "${config}")
        ;;
      json)
        if ! command -v jq >/dev/null 2>&1; then
          echo "❌ Error: JSON config detected but 'jq' not found."
          echo "   Please install with:"
          echo "   conda install -c conda-forge jq"
          return 1
        fi
        echo "📄 Loading JSON job config: ${config}"
        job_name=$(jq -r '.job.name' "${config}")
        partition=$(jq -r '.job.partition' "${config}")
        gpu=$(jq -r '.job.gpu' "${config}")
        cpus=$(jq -r '.job.cpus' "${config}")
        mem=$(jq -r '.job.mem' "${config}")
        time=$(jq -r '.job.time' "${config}")
        conda_env=$(jq -r '.job.conda' "${config}")
        script=$(jq -r '.job.script' "${config}")
        logdir=$(jq -r '.job.logdir' "${config}")
        dryrun=$(jq -r '.job.dryrun' "${config}")
        ;;
      *)
        echo "⚠️  Unknown config file type: ${ext}. Skipping config parse."
        ;;
    esac
  fi

  ##----------------------------------------------------------
  ## Defaults if missing
  ##----------------------------------------------------------
  job_name=${job_name:-"hpcjob"}
  partition=${partition:-"gpu-short"}
  gpu=${gpu:-"gpu:1"}
  cpus=${cpus:-8}
  mem=${mem:-"32G"}
  time=${time:-"01:00:00"}
  conda_env=${conda_env:-""}
  logdir=${logdir:-"logs"}
  dryrun=${dryrun:-false}

  ##----------------------------------------------------------
  ## Validate script path
  ##----------------------------------------------------------
  if [[ -z "${script}" ]]; then
    echo "❌ Error: No script specified (use --script or --config <file>)"
    return 1
  fi

  if [[ ! -f "${script}" ]]; then
    echo "⚠️  Warning: Script '${script}' does not exist yet."
  fi

  ##----------------------------------------------------------
  ## Generate SLURM wrapper
  ##----------------------------------------------------------
  local slurm_dir="${PWD}/logs/scrum"
  mkdir -p "${slurm_dir}"

  local wrapper="${slurm_dir}/${job_name}.${_timestamp}.slurm"

  lsd-mod.hpc.submit.generate-slurm-template \
    --name "${job_name}" \
    --partition "${partition}" \
    --gpu "${gpu}" \
    --cpus "${cpus}" \
    --mem "${mem}" \
    --time "${time}" \
    --conda "${conda_env}" \
    --output "${wrapper}"

  echo "bash ${script}" >> "${wrapper}"
  ## Immediately after writing the wrapper, lock it down to be readable only by the job owner
  chmod 600 "${wrapper}"

  ### Find all files in ${slurm_dir} that are regular files, older than 7 days, and whose names end with .slurm, then delete them quietly.
  ## find "${slurm_dir}" -type f -mtime +7 -name "*.slurm" -print ## dry-run
  ## find "${slurm_dir}" -type f -mtime +7 -name "*.slurm" -delete 2>/dev/null

  ##----------------------------------------------------------
  ## Dry-run or submit
  ##----------------------------------------------------------
  if [[ "${dryrun}" == "true" ]]; then
    echo "🧪 Dry-run mode enabled. Wrapper generated at:"
    echo "   ${wrapper}"
    echo "----------------------------------------------------------"
    cat "${wrapper}"
    return 0
  fi

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
  local tmp_dir="${PWD}/logs/slurm"
  mkdir -p "${tmp_dir}"
  local tmp="${tmp_dir}/lsd_pyjob_$(_lsd_hpc__timestamp).sh"

  echo "python ${script}" > "${tmp}"
  lsd-mod.hpc.submit.run-job --script "${tmp}" "$@"
}


function lsd-mod.hpc.submit.run-batch() {
  ## Submit all .sh scripts from a directory.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local dir=${args['dir']:-"./batch_jobs"}

  for script in "${dir}"/*.sh; do
    echo "🚀 Submitting: ${script}"
    lsd-mod.hpc.submit.run-job --script "${script}"
  done
}


function lsd-mod.hpc.submit.run-dependent() {
  ## Run a job dependent on another job completion.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local dep=${args['after']:-""}
  local script=${args['script']:-""}

  if [[ -z "${dep}" || -z "${script}" ]]; then
    echo "Usage: --after <jobid> --script <path>"
    return 1
  fi

  sbatch --dependency=afterok:${dep} "${script}"
  echo "🔗 Dependent job submitted: ${script} (after ${dep})"
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
  ## Stream the log of a running job.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  ## Support shorthand: lsd-hpc.monitor.tail-job 1460
  local jobid=${args['id']:-"$1"}

  if [[ -z "${jobid}" ]]; then
    echo "Usage: lsd-hpc.monitor.tail-job --id <jobid>"
    return 1
  fi

  local logfile=$(ls logs/*"${jobid}".out 2>/dev/null | head -n 1)
  if [[ -z "${logfile}" ]]; then
    echo "⚠️  Log file for JobID ${jobid} not found in logs/."
    return 1
  fi

  echo "📡 Tailing job ${jobid} -> ${logfile}"
  echo "----------------------------------------------------------"
  tail -f "${logfile}"
}

function lsd-mod.hpc.monitor.history() {
  ## Display recent job history for current user.
  sacct -u "$USER" --format=JobID,JobName,State,Elapsed,ExitCode,Start,End | tail -n +3
}


function lsd-mod.hpc.monitor.stats() {
  ## Display summary of job states for user.
  squeue -u "$USER" | awk 'NR>1 {count[$5]++} END{for (s in count) print s, count[s]}'
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

function lsd-mod.hpc.manage.requeue-job() {
  ## Requeue a failed or stopped job.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local jobid=${args['id']:-""}

  if [[ -z "${jobid}" ]]; then
    echo "Usage: --id <jobid>"
    return 1
  fi

  scontrol requeue "${jobid}" && echo "♻️  Job ${jobid} requeued."
}

function lsd-mod.hpc.manage.purge-old() {
  ## Remove logs older than N days
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"
  local days=${args['days']:-7}
  find logs -type f -mtime +"${days}" -exec rm -v {} \;
  echo "🧹 Purged logs older than ${days} days."
}

function lsd-mod.hpc.manage.resubmit() {
  ## Resubmit a job using saved metadata.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local meta=${args['meta']:-""}

  if [[ -z "${meta}" ]]; then
    echo "Usage: --meta <metadata.json>"
    return 1
  fi

  local script=$(jq -r '.script' "${meta}")

  echo "Resubmitting ${script}"
  sbatch "${script}"
}


### GROUP 4: AUDIT
function lsd-mod.hpc.audit.save-job-metadata() {
  ## Save SLURM job metadata to JSON file.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local jobid=${args['id']:-""}

  if [[ -z "${jobid}" ]]; then
    echo "Usage: --id <jobid>"
    return 1
  fi

  scontrol show job "${jobid}" > ".meta_${jobid}.json"
  echo "💾 Metadata saved: .meta_${jobid}.json"
}

function lsd-mod.hpc.audit.load-job-metadata() {
  ## Load and display job metadata file.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local meta=${args['file']:-""}

  if [[ -z "${meta}" ]]; then
    echo "Usage: --file <metadata.json>"
    return 1
  fi

  cat "${meta}"
}

function lsd-mod.hpc.audit.view-log() {
  ## View job output log interactively.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local jobid=${args['id']:-""}

  if [[ -z "${jobid}" ]]; then
    echo "Usage: --id <jobid>"
    return 1
  fi

  less logs/*"${jobid}".out
}

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

function lsd-mod.hpc.resource.list-partitions() {
  sinfo -o "%.10P %.6D %.10C %.10m %.10G"
}


function lsd-mod.hpc.resource.user-quota() {
  sacctmgr show assoc user=${USER} format=User,GrpTRESMins,GrpTRESRunMins,GrpJobs
}


function lsd-mod.hpc.resource.capacity-overview() {
  sinfo -N -o "%.10P %.15N %.6D %.10C %.10m %.10G"
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

function lsd-mod.hpc.schedule.schedule-job() {
  ## Schedule a job to start after a delay.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local script=${args['script']:-""}
  local delay=${args['delay']:-60}

  if [[ -z "${script}" ]]; then
    echo "Usage: --script <path>"
    return 1
  fi

  echo "⏱ Scheduling ${script} to run in ${delay}s..."
  sleep "${delay}" && sbatch "${script}"
}

function lsd-mod.hpc.schedule.batch-submit() {
  ## Submit multiple jobs from a JSON list file.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local list=${args['list']:-"jobs.json"}

  if [[ ! -f "${list}" ]]; then
    echo "File ${list} not found."
    return 1
  fi

  for script in $(jq -r '.jobs[]' "${list}"); do
    echo "Submitting ${script}"
    sbatch "${script}"
  done
}

function lsd-mod.hpc.schedule.workflow() {
  ## Execute multi-step workflow based on JSON config.
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/argparse.sh" "$@"

  local config=${args['config']:-"workflow.json"}

  if [[ ! -f "${config}" ]]; then
    echo "Missing workflow config"
    return 1
  fi

  echo "🧩 Executing workflow ${config}"

  for step in $(jq -r '.steps[].script' "${config}"); do
    echo "Running ${step}"
    sbatch "${step}"
  done
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
  echo "   🗂 SLURM wrappers are saved under: logs/scrum/"
  echo "   🧪 Test & dry-run files are under: logs/slurm/"

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
  local test_dir="${PWD}/logs/slurm"
  mkdir -p "${test_dir}"
  # find "${test_dir}" -type f -mtime +7 -name "*.slurm" -delete 2>/dev/null

  local testfile="${test_dir}/testjob.$(_lsd_hpc__timestamp).slurm"
  lsd-mod.hpc.submit.generate-slurm-template --name testjob --output "${testfile}"
  [[ -f "${testfile}" ]] && echo "✅ Template created: ${testfile}" || echo "❌ Template creation failed"
  chmod 600 "${testfile}"
}

function lsd-mod.hpc.test.submit-dryrun() {
  echo "🧪 Dry-run submission (no sbatch execution)..."
  local dry_dir="${PWD}/logs/slurm"
  mkdir -p "${dry_dir}"
  # find "${test_dir}" -type f -mtime +7 -name "*.slurm" -delete 2>/dev/null

  local dryfile="${dry_dir}/dryrun.$(_lsd_hpc__timestamp).slurm"
  lsd-mod.hpc.submit.generate-slurm-template --name dryrun --output "${dryfile}"
  echo "bash echo 'Hello World'" >> "${dryfile}"
  chmod 600 "${dryfile}"

  echo "✅ Created dry-run SLURM file: ${dryfile}"
  echo "   You can inspect it safely under logs/slurm/"
}

function lsd-mod.hpc.test.all() {
  echo "📁 Using local test SLURM directory: logs/slurm"
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
