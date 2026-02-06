#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
## __author__='mangalbhaskar'
###----------------------------------------------------------
## LSD HuggingFace Utilities (hf CLI aligned, complete)
###----------------------------------------------------------


###----------------------------------------------------------
## INTERNAL HELPERS
###----------------------------------------------------------

_lsd_hf__timestamp() { date +'%d%m%y_%H%M%S'; }

_lsd_hf__ensure_dir() {
  mkdir -p "$1" && echo "$1"
}

_lsd_hf__require_hf() {
  command -v hf >/dev/null 2>&1 \
    || { echo "❌ Hugging Face CLI (hf) not found"; return 1; }
}


###----------------------------------------------------------
## INSTALL
###----------------------------------------------------------

lsd-mod.huggingface.install.core() {
  ## OS 24.04 LTS onwards require forceful installation on base system using pip
  pip install -U huggingface_hub --break-system-packages \
    && echo "✔ HuggingFace CLI installed (hf)"
}

lsd-mod.huggingface.install.all() {
  lsd-mod.huggingface.install.core
}


###----------------------------------------------------------
## AUTH / CONFIG
###----------------------------------------------------------

lsd-mod.huggingface.token() {
  local token_file="${1:-${HOME}/.cred/huggingface.token.sh}"

  _lsd_hf__require_hf || return 1

  [[ -f "${token_file}" ]] || {
    echo "❌ Token file not found: ${token_file}"
    return 1
  }

  local token
  token="$(tr -d ' \n\r' < "${token_file}")"

  echo "${token}"
}

lsd-mod.huggingface.login() {
  local token="${1:-$(lsd-mod.huggingface.token $@)}"

  [[ -n "${token}" ]] || {
    echo "❌ Empty token file: ${token_file}"
    return 1
  }

  # export HF_TOKEN="${token}"
  # export HF_TOKEN_FILE="${token_file}"

  hf auth login --token "${token}" --add-to-git-credential
  hf auth whoami
}

lsd-mod.huggingface.logout() {
  _lsd_hf__require_hf || return 1
  hf auth logout
}

lsd-mod.huggingface.whoami() {
  _lsd_hf__require_hf || return 1
  hf auth whoami
}

lsd-mod.huggingface.config.show() {
  _lsd_hf__require_hf || return 1
  hf env
}

lsd-mod.huggingface.version() {
  _lsd_hf__require_hf || return 1
  hf version
}


###----------------------------------------------------------
## MONITORING
###----------------------------------------------------------

lsd-mod.huggingface.monitor.cache() {
  du -sh ~/.cache/huggingface 2>/dev/null \
    || echo "No HuggingFace cache found"
}

lsd-mod.huggingface.monitor.repos() {
  echo "⚠️ hf does not support 'repo list' globally"
  echo "Use: hf models ls | hf datasets ls | hf spaces ls"
}


###----------------------------------------------------------
## DATASETS (CORE)
###----------------------------------------------------------

lsd-mod.huggingface.datasets.ls() {
  _lsd_hf__require_hf || return 1
  hf datasets ls "$@"
}

lsd-mod.huggingface.datasets.info() {
  _lsd_hf__require_hf || return 1
  hf datasets info "$@"
}


###----------------------------------------------------------
## MODELS (CORE)
###----------------------------------------------------------

lsd-mod.huggingface.models.ls() {
  _lsd_hf__require_hf || return 1
  hf models ls "$@"
}

lsd-mod.huggingface.models.info() {
  _lsd_hf__require_hf || return 1
  hf models info "$@"
}


###----------------------------------------------------------
## SPACES (CORE)
###----------------------------------------------------------

lsd-mod.huggingface.spaces.ls() {
  _lsd_hf__require_hf || return 1
  hf spaces ls "$@"
}

lsd-mod.huggingface.spaces.info() {
  _lsd_hf__require_hf || return 1
  hf spaces info "$@"
}


###----------------------------------------------------------
## COLLECTIONS (CORE)
###----------------------------------------------------------

lsd-mod.huggingface.collections.ls() {
  _lsd_hf__require_hf || return 1
  hf collections ls "$@"
}

lsd-mod.huggingface.collections.info() {
  _lsd_hf__require_hf || return 1
  hf collections info "$@"
}

lsd-mod.huggingface.collections.add() {
  _lsd_hf__require_hf || return 1
  hf collections add-item "$@"
}


###----------------------------------------------------------
## REPO (METADATA ONLY)
###----------------------------------------------------------

lsd-mod.huggingface.repo.info() {
  _lsd_hf__require_hf || return 1
  hf repo settings "$@"
}


###----------------------------------------------------------
## DATASET DOWNLOAD (GENERIC)
###----------------------------------------------------------

lsd-mod.huggingface.download.dataset() {
  local repo="$1"; shift || true
  [[ -z "${repo}" ]] && { echo "❌ repo_id required"; return 1; }

  _lsd_hf__require_hf || return 1

  local outdir="${PWD}/${repo##*/}"
  local include=""
  local dryrun=0

  for arg in "$@"; do
    case "${arg}" in
      --dir=*)     outdir="${arg#*=}" ;;
      --include=*) include="${arg#*=}" ;;
      --dry-run)   dryrun=1 ;;
    esac
  done

  _lsd_hf__ensure_dir "${outdir}" >/dev/null

  echo "----------------------------------------------------------"
  echo "📦 DATASET : ${repo}"
  echo "📂 OUTDIR  : ${outdir}"
  echo "📁 INCLUDE : ${include:-ALL}"
  echo "----------------------------------------------------------"

  if [[ "${dryrun}" -eq 1 ]]; then
    hf download "${repo}" --repo-type dataset --dry-run
    return 0
  fi

  hf download "${repo}" \
    --repo-type dataset \
    ${include:+--include "${include}"} \
    --local-dir "${outdir}"
}


###----------------------------------------------------------
## MODEL DOWNLOAD (GENERIC)
###----------------------------------------------------------

lsd-mod.huggingface.download.model() {
  local repo="$1"; shift || true
  [[ -z "${repo}" ]] && { echo "❌ model repo_id required"; return 1; }

  _lsd_hf__require_hf || return 1

  local outdir="${PWD}/${repo##*/}"
  local type="model"

  for arg in "$@"; do
    case "${arg}" in
      --dir=*)  outdir="${arg#*=}" ;;
      --type=*) type="${arg#*=}" ;;
    esac
  done

  mkdir -p "${outdir}"

  hf download "${repo}" \
    --repo-type "${type}" \
    --local-dir "${outdir}"
}


###----------------------------------------------------------
## MODEL SHORTCUTS
###----------------------------------------------------------

lsd-mod.huggingface.download.model.qwen2vl() {
  lsd-mod.huggingface.download.model "Qwen/Qwen2-VL-7B-Instruct" "$@"
}

lsd-mod.huggingface.download.model.text-encoder() {
  lsd-mod.huggingface.download.model \
    "sentence-transformers/all-MiniLM-L6-v2" "$@"
}

lsd-mod.huggingface.download.model.audio() {
  lsd-mod.huggingface.download.model \
    "openai/whisper-large-v3" "$@"
}


###----------------------------------------------------------
## RAW CLI
###----------------------------------------------------------

lsd-mod.huggingface.cli() {
  _lsd_hf__require_hf || return 1
  hf "$@"
}


###----------------------------------------------------------
## HELP
###----------------------------------------------------------

lsd-mod.huggingface.help.main() {
  cat <<EOF
----------------------------------------------------------
🤗 LSD HUGGINGFACE MODULE HELP
----------------------------------------------------------
INSTALL
  lsd-huggingface.install.core
  lsd-huggingface.install.all

AUTH
  lsd-huggingface.login [token_file]
  lsd-huggingface.logout
  lsd-huggingface.whoami

DATASETS
  lsd-huggingface.datasets.ls
  lsd-huggingface.datasets.info <repo>

MODELS / SPACES / COLLECTIONS
  *.ls / *.info / *.add

DOWNLOAD
  lsd-huggingface.download.dataset
  lsd-huggingface.download.model

RAW
  lsd-huggingface.cli <hf args>
----------------------------------------------------------
EOF
}
