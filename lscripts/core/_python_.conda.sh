#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
## __author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Conda governance, introspection, pinning & replication
## Module: _python_.conda.sh
###
## Design principles:
## - READ-ONLY by default
## - No mutation unless explicitly requested
## - No dependency on _python_.sh internals
## - Reproducible, auditable outputs
## - HPC + workstation safe
###----------------------------------------------------------


###----------------------------------------------------------
## Internal helpers
###----------------------------------------------------------

function lsd-mod.python.conda._require_conda() {
  command -v conda &>/dev/null || \
    lsd-mod.log.fail "conda binary not found in PATH"
}

function lsd-mod.python.conda._hostname() {
  hostname | tr '[:upper:]' '[:lower:]'
}

function lsd-mod.python.conda._timestamp() {
  date -d now +'%d%m%y_%H%M%S'
}

function lsd-mod.python.conda._logfile() {
  local host ts
  host=$(lsd-mod.python.conda._hostname)
  ts=$(lsd-mod.python.conda._timestamp)
  echo "logs/${host}-conda-config-${ts}.log"
}

function lsd-mod.python.conda._ensure_logs_dir() {
  mkdir -p logs
}

function lsd-mod.python.conda._kv_table() {
  ## stdin: key=value
  printf "%-30s | %s\n" "KEY" "VALUE"
  printf "%-30s-+-%s\n" "$(printf '%.0s-' {1..30})" "$(printf '%.0s-' {1..40})"
  while IFS='=' read -r k v; do
    printf "%-30s | %s\n" "$k" "$v"
  done
}


###----------------------------------------------------------
## 1. Conda configuration snapshot
###----------------------------------------------------------

function lsd-mod.python.conda.cfg.show() {
  lsd-mod.python.conda._require_conda
  lsd-mod.python.conda._ensure_logs_dir

  local logfile
  logfile=$(lsd-mod.python.conda._logfile)

  lsd-mod.log.info "Collecting Conda configuration"
  lsd-mod.log.info "Logfile: ${logfile}"

  {
    echo "===== CONDA VERSION ====="
    conda --version
    echo

    echo "===== OS INFO ====="
    source /etc/os-release 2>/dev/null
    echo "id=${ID}"
    echo "version_id=${VERSION_ID}"
    echo "distribution=${ID}${VERSION_ID}"
    echo "version_codename=${VERSION_CODENAME}"
    echo

    echo "===== conda info ====="
    conda info
    echo

    echo "===== conda config --show ====="
    conda config --show
    echo

    echo "===== conda config --show-sources ====="
    conda config --show-sources
    echo
  } | tee "${logfile}"

  lsd-mod.log.echo
  lsd-mod.log.echo "${gre}Conda Configuration (Normalized View)${nocolor}"
  lsd-mod.log.echo

  conda config --show \
    | sed 's/: /=/' \
    | lsd-mod.python.conda._kv_table
}


###----------------------------------------------------------
## 2. List all environments with locations & symlinks
###----------------------------------------------------------

function lsd-mod.python.conda._env_runtime_fingerprint() {
  local env_path="$1"
  local py="${env_path}/bin/python"

  [[ ! -x "$py" ]] && {
    echo "-|-|-|-|-"
    return
  }

  "$py" - <<'PYEOF' 2>/dev/null || echo "-|-|-|-|-"
import sys
def safe(mod, attr=None):
  try:
    m = __import__(mod)
    return getattr(m, attr) if attr else m.__version__
  except Exception:
    return "-"

torch_ver = safe("torch")
torch_cuda = "-"
cuda_enabled = "-"
if torch_ver != "-":
  import torch
  cuda_enabled = str(torch.cuda.is_available())
  torch_cuda = torch.version.cuda or "cpu"

print("|".join([
  ".".join(map(str, sys.version_info[:3])),
  safe("numpy"),
  torch_ver,
  cuda_enabled,
  torch_cuda
]))
PYEOF
}


function lsd-mod.python.conda.envs.list-fast() {
  lsd-mod.python.conda._require_conda

  lsd-mod.log.echo
  lsd-mod.log.echo "${gre}Conda Environments${nocolor}"
  lsd-mod.log.echo

  printf "%-25s | %-50s | %-7s | %-8s\n" \
    "NAME" "PATH" "ACTIVE" "SYMLINK"
  printf "%-25s-+-%-50s-+-%-7s-+-%-8s\n" \
    "$(printf '%.0s-' {1..25})" \
    "$(printf '%.0s-' {1..50})" \
    "$(printf '%.0s-' {1..7})" \
    "$(printf '%.0s-' {1..8})"

  conda env list | sed '1,2d' | while read -r line; do
    local name path active sym
    active="no"
    echo "$line" | grep '*' &>/dev/null && active="yes"

    name=$(echo "$line" | awk '{print $1}')
    path=$(echo "$line" | awk '{print $NF}')

    [[ -L "$path" ]] && sym="yes" || sym="no"

    printf "%-25s | %-50s | %-7s | %-8s\n" \
      "$name" "$path" "$active" "$sym"
  done
}


function lsd-mod.python.conda._envs.enumerate_canonical_tsv() {
  lsd-mod.python.conda._require_conda

  declare -A REALPATH_TO_ALIASES
  declare -A REALPATH_TO_CANON

  while read -r line; do
    local name path real

    name=$(echo "$line" | awk '{print $1}')
    path=$(echo "$line" | awk '{print $NF}')

    [[ -z "$path" || ! -d "$path" ]] && continue

    real=$(realpath "$path" 2>/dev/null) || continue

    REALPATH_TO_CANON["$real"]="$(basename "$real")"

    if [[ -L "$path" ]]; then
      REALPATH_TO_ALIASES["$real"]+="${name},"
    fi
  done < <(conda env list | sed '1,2d')

  for real in "${!REALPATH_TO_CANON[@]}"; do
    local canon aliases
    canon="${REALPATH_TO_CANON[$real]}"
    aliases="$(echo "${REALPATH_TO_ALIASES[$real]}" | sed 's/,$//')"
    [[ -z "$aliases" ]] && aliases="-"
    # real<TAB>canon<TAB>aliases
    echo -e "${real}\t${canon}\t${aliases}"
  done
}


function lsd-mod.python.conda.envs.list() {
  lsd-mod.python.conda._require_conda

  lsd-mod.log.echo
  lsd-mod.log.echo "${gre}Conda Environments (canonical view)${nocolor}"
  lsd-mod.log.echo

  printf "%-24s | %-30s | %-8s | %-10s | %-19s\n" \
    "ENV" "ALIASES" "PYTHON" "SIZE" "CREATED"

  printf "%-24s-+-%-30s-+-%-8s-+-%-10s-+-%-19s\n" \
    "$(printf '%.0s-' {1..24})" \
    "$(printf '%.0s-' {1..30})" \
    "$(printf '%.0s-' {1..8})" \
    "$(printf '%.0s-' {1..10})" \
    "$(printf '%.0s-' {1..19})"

  lsd-mod.python.conda._envs.enumerate_canonical_tsv \
    | while IFS=$'\t' read -r real canon aliases; do
        local py size created

        if [[ -x "$real/bin/python" ]]; then
          py=$("$real/bin/python" -c 'import sys; print(".".join(map(str, sys.version_info[:3])))' 2>/dev/null)
        else
          py="-"
        fi

        size=$(du -sh "$real" 2>/dev/null | awk '{print $1}')
        [[ -z "$size" ]] && size="-"

        created=$(stat -c %y "$real" 2>/dev/null | cut -d'.' -f1)
        [[ -z "$created" ]] && created="0000-00-00 00:00:00"

        printf "%-24s | %-30s | %-8s | %-10s | %-19s\n" \
          "$canon" "$aliases" "$py" "$size" "$created"
      done | sort -k5
}


function lsd-mod.python.conda.envs.list-details() {
  lsd-mod.python.conda._require_conda

  declare -a ENV_ROWS
  declare -A PYTHON_VERSIONS
  local total_size_kb=0

  while IFS=$'\t' read -r real canon aliases; do
    [[ ! -d "$real" ]] && continue

    local size_kb size_hr created last_used
    local py numpy torch cuda_enabled cuda_ver

    size_kb=$(du -sk "$real" 2>/dev/null | awk '{print $1}')
    [[ -z "$size_kb" ]] && size_kb=0
    size_hr=$(du -sh "$real" 2>/dev/null | awk '{print $1}')
    [[ -z "$size_hr" ]] && size_hr="-"
    total_size_kb=$((total_size_kb + size_kb))

    created=$(stat -c %y "$real" 2>/dev/null | cut -d'.' -f1)
    [[ -z "$created" ]] && created="0000-00-00 00:00:00"

    # last-used heuristic:
    # prefer conda-meta/history mtime; else fallback to newest mtime under conda-meta; else created.
    if [[ -f "$real/conda-meta/history" ]]; then
      last_used=$(stat -c %y "$real/conda-meta/history" 2>/dev/null | cut -d'.' -f1)
    elif [[ -d "$real/conda-meta" ]]; then
      last_used=$(find "$real/conda-meta" -maxdepth 1 -type f -printf '%T@\n' 2>/dev/null | sort -nr | head -1)
      if [[ -n "$last_used" ]]; then
        last_used=$(date -d "@${last_used%.*}" +'%Y-%m-%d %H:%M:%S' 2>/dev/null)
      fi
    fi
    [[ -z "$last_used" ]] && last_used="$created"

    IFS='|' read -r py numpy torch cuda_enabled cuda_ver \
      <<< "$(lsd-mod.python.conda._env_runtime_fingerprint "$real")"

    [[ -z "$py" || "$py" == "-" ]] && py="-"
    PYTHON_VERSIONS["$py"]=1

    ENV_ROWS+=(
      "$created|$canon|$aliases|$py|$numpy|$torch|$cuda_enabled|$cuda_ver|$size_hr|$size_kb|$last_used"
    )
  done < <(lsd-mod.python.conda._envs.enumerate_canonical_tsv)

  # Handle empty case cleanly
  if [[ ${#ENV_ROWS[@]} -eq 0 ]]; then
    lsd-mod.log.warn "No conda environments found (or conda not installed / no permissions)."
    return 0
  fi

  # ----------------------------------------------------------
  # Main table
  # ----------------------------------------------------------
  lsd-mod.log.echo
  lsd-mod.log.echo "${gre}Conda Environments (detailed)${nocolor}"
  lsd-mod.log.echo

  printf "%-8s | %-8s | %-12s | %-5s | %-8s | %-8s | %-19s | %-19s | %-24s | %-30s\n" \
    "PY" "NUMPY" "TORCH" "CUDA" "CUDA_VER" "SIZE" "CREATED" "LAST_USED" "ENV" "ALIASES"

  printf "%-8s-+-%-8s-+-%-12s-+-%-5s-+-%-8s-+-%-8s-+-%-19s-+-%-19s-+-%-24s-+-%-30s\n" \
    "$(printf '%.0s-' {1..6})" \
    "$(printf '%.0s-' {1..8})" \
    "$(printf '%.0s-' {1..12})" \
    "$(printf '%.0s-' {1..5})" \
    "$(printf '%.0s-' {1..8})" \
    "$(printf '%.0s-' {1..8})" \
    "$(printf '%.0s-' {1..19})" \
    "$(printf '%.0s-' {1..19})" \
    "$(printf '%.0s-' {1..22})" \
    "$(printf '%.0s-' {1..30})"

  printf "%s\n" "${ENV_ROWS[@]}" \
    | sort \
    | while IFS='|' read -r created env aliases py numpy torch cuda cuda_ver size_hr _ last_used; do
        printf "%-8s | %-8s | %-12s | %-5s | %-8s | %-8s | %-19s | %-19s | %-24s | %-30s\n" \
          "$py" \
          "$numpy" \
          "$torch" \
          "$cuda" \
          "$cuda_ver" \
          "$size_hr" \
          "$created" \
          "$last_used" \
          "$env" \
          "${aliases:-"-"}"
      done

  # ----------------------------------------------------------
  # Summary
  # ----------------------------------------------------------
  local env_count=${#ENV_ROWS[@]}
  local total_gb
  total_gb=$(awk "BEGIN {printf \"%.1f\", $total_size_kb/1024/1024}")

  lsd-mod.log.echo
  lsd-mod.log.echo "${biyel}Summary${nocolor}"
  lsd-mod.log.echo "----------------------------------------------"
  lsd-mod.log.echo "Total real envs       : ${env_count}"
  lsd-mod.log.echo "Total disk usage      : ${total_gb} GB"

  lsd-mod.log.echo
  lsd-mod.log.echo "Top storage consumers:"
  printf "%s\n" "${ENV_ROWS[@]}" \
    | sort -t'|' -k10 -nr \
    | head -5 \
    | while IFS='|' read -r _ env _ py _ _ _ _ size_hr _ _; do
        echo "  - ${env} (${size_hr}, py ${py})"
      done

  local oldest newest
  oldest=$(printf "%s\n" "${ENV_ROWS[@]}" | sort | head -1)
  newest=$(printf "%s\n" "${ENV_ROWS[@]}" | sort | tail -1)

  IFS='|' read -r _ oenv _ opy _ _ _ _ osize _ _ <<< "$oldest"
  IFS='|' read -r _ nenv _ npy _ _ _ _ nsize _ _ <<< "$newest"

  lsd-mod.log.echo
  lsd-mod.log.echo "Oldest env : ${oenv} (${osize}, py ${opy})"
  lsd-mod.log.echo "Newest env : ${nenv} (${nsize}, py ${npy})"

  lsd-mod.log.echo
  lsd-mod.log.echo "Python versions in use:"
  for v in "${!PYTHON_VERSIONS[@]}"; do
    [[ "$v" == "-" ]] && continue
    echo "  - ${v}"
  done | sort
}


###----------------------------------------------------------
## 3. Pin an environment (explicit + yaml + metadata)
###----------------------------------------------------------

function lsd-mod.python.conda.envs.pin() {
  lsd-mod.python.conda._require_conda
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/argparse.sh" "$@"

  local env outdir
  env="${args['name']}"
  outdir="${args['out']}"

  [[ -z "${env}" ]] && \
    lsd-mod.log.fail "--name=<env> is required"

  [[ -z "${outdir}" ]] && outdir="logs/envs/${env}"

  # verify env exists
  conda env list | awk '{print $1}' | grep -qx "${env}" || \
    lsd-mod.log.fail "Environment not found: ${env}"

  mkdir -p "${outdir}"

  lsd-mod.log.info "Pinning environment: ${env}"
  lsd-mod.log.info "Output directory: ${outdir}"

  conda list --explicit -n "${env}" > "${outdir}/${env}.explicit.lock"
  ## strip away prefix to have no system dependent path for reproducibility
  conda env export -n "${env}" --no-builds \
    | grep -v '^prefix:' \
    > "${outdir}/${env}.env.yml"


  {
    echo "name: ${env}"
    echo "pinned_at: $(date -Iseconds)"
    echo "conda_version: $(conda --version | awk '{print $2}')"
    echo "python: $(conda run -n "${env}" python -V 2>&1 | awk '{print $2}')"
    echo "channels:"
    conda config --show channels | sed '1d' | sed 's/^/  - /'
    echo "os:"
    source /etc/os-release 2>/dev/null
    echo "  id: ${ID}"
    echo "  version_id: ${VERSION_ID}"
  } > "${outdir}/${env}.meta.yml"

  lsd-mod.log.success "Pinned environment saved under: ${outdir}"
}


function lsd-mod.python.conda.envs.pin-all() {
  lsd-mod.python.conda._require_conda
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/argparse.sh" "$@"

  local outdir failures=0
  outdir="${args['out']}"
  [[ -z "$outdir" ]] && outdir="logs/envs"

  mkdir -p "${outdir}"

  lsd-mod.log.info "Pinning ALL conda environments"
  lsd-mod.log.info "Output root: ${outdir}"

  lsd-mod.python.conda._envs.enumerate_canonical_tsv \
    | while IFS=$'\t' read -r _ canon _; do

        case "$canon" in
          base|conda)
            lsd-mod.log.warn "Skipping core env: ${canon}"
            continue
            ;;
        esac

        lsd-mod.log.info "Pinning: ${canon}"

        if ! lsd-mod.python.conda.envs.pin --name="${canon}" --out="${outdir}/${canon}"; then
          lsd-mod.log.fail "Failed to pin: ${canon}" || true
          failures=$((failures + 1))
        fi
      done

  if [[ $failures -gt 0 ]]; then
    lsd-mod.log.warn "Pin-all completed with ${failures} failures"
  else
    lsd-mod.log.success "Pin-all completed successfully"
  fi
}


###----------------------------------------------------------
## 4. Replicate environment (delegates creation)
###----------------------------------------------------------

function lsd-mod.python.conda.envs.replicate() {
  lsd-mod.python.conda._require_conda
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/argparse.sh" "$@"

  local src name
  src="${args['from']}"
  name="${args['name']}"

  [[ -z "${src}" ]] && lsd-mod.log.fail "--from=<env-dir> required"
  [[ -z "${name}" ]] && lsd-mod.log.fail "--name=<new-env-name> required"

  lsd-mod.log.info "Replicating environment from: ${src}"
  lsd-mod.log.info "Target environment name: ${name}"

  if [[ -f "${src}"/*.explicit.lock ]]; then
    lsd-mod.log.info "Using explicit lockfile (binary exact)"
    conda create -n "${name}" --file "${src}"/*.explicit.lock

  elif [[ -f "${src}"/*.env.yml ]]; then
    lsd-mod.log.info "Using environment YAML (solver based, prefix-free)"
    conda env create -n "${name}" \
      -f <(grep -v '^prefix:' "${src}"/*.env.yml)

  else
    lsd-mod.log.fail "No explicit.lock or env.yml found in ${src}"
  fi
}


###----------------------------------------------------------
## 5. Telemetry & plugins
###----------------------------------------------------------

function lsd-mod.python.conda.telemetry.status() {
  lsd-mod.python.conda._require_conda

  lsd-mod.log.echo
  lsd-mod.log.echo "${gre}Conda Telemetry / Plugins${nocolor}"
  lsd-mod.log.echo

  conda config --show | grep -E 'telemetry|plugins|report'
  echo
  conda list | grep -i telemetry || true
}

function lsd-mod.python.conda.telemetry.disable() {
  lsd-mod.python.conda._require_conda

  lsd-mod.log.warn "Disabling Conda telemetry & error reporting"

  conda config --set telemetry_enabled false
  conda config --set report_errors false

  lsd-mod.log.success "Telemetry disabled (non-destructive)"
  lsd-mod.log.info "For full isolation, export: CONDA_NO_PLUGINS=true"
}
