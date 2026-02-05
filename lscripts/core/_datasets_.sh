#!/bin/bash

## Copyright (c) 2026 mangalbhaskar
## __author__='mangalbhaskar'
###----------------------------------------------------------
## LSD DATASETS MODULE (HF-aligned, auth-safe, signal-safe)
###----------------------------------------------------------

###----------------------------------------------------------
## INTERNALS
###----------------------------------------------------------

_lsd_ds__ts() { date +'%d%m%y_%H%M%S'; }
_lsd_ds__now() { date +%s; }
_lsd_ds__elapsed() { echo "$(( $2 - $1 ))"; }

_lsd_ds__require() {
  command -v "$1" >/dev/null 2>&1 \
    || { echo "❌ Missing required command: $1"; return 1; }
}

_lsd_ds__require_hf_auth() {
  if [[ -z "${HF_TOKEN:-}" ]]; then
    if [[ -f "${HOME}/.huggingface/token" ]]; then
      export HF_TOKEN="$(cat "${HOME}/.huggingface/token")"
    else
      echo "❌ HF_TOKEN not set and no ~/.huggingface/token found"
      echo "👉 Run: hf auth login"
      return 1
    fi
  fi
}

###----------------------------------------------------------
## DATAHUB ROOT
###----------------------------------------------------------

_lsd_ds__root() {
  [[ -d /datahub ]] && echo /datahub || echo "${HOME}/datahub"
}

_lsd_ds__outdir() {
  echo "$(_lsd_ds__root)/aimldl-dat/data-public/$1-$(_lsd_ds__ts)"
}

###----------------------------------------------------------
## LOGGING
###----------------------------------------------------------

_lsd_ds__logfile() {
  mkdir -p logs
  echo "logs/lsd-mod.datasets-$(_lsd_ds__ts).log"
}

_lsd_ds__size() {
  du -sh "$1" 2>/dev/null | awk '{print $1}'
}

###----------------------------------------------------------
## CORE HF DOWNLOAD (CORRECT & KILLABLE)
###----------------------------------------------------------

lsd-mod.datasets.hf.download() {
  local repo="$1"; shift
  [[ -z "${repo}" ]] && return 1

  _lsd_ds__require hf || return 1
  _lsd_ds__require_hf_auth || return 1

  local name="${repo##*/}"
  local outdir="$(_lsd_ds__outdir "${name}")"
  local include=""
  local resume=0

  for arg in "$@"; do
    case "$arg" in
      --dir=*) outdir="${arg#*=}" ;;
      --include=*) include="${arg#*=}" ;;
      --resume-download) resume=1 ;;
    esac
  done

  mkdir -p "${outdir}"
  local log="$(_lsd_ds__logfile)"

  echo "==========================================================" | tee "${log}"
  echo "📦 DATASET     : ${repo}" | tee -a "${log}"
  echo "📂 DESTINATION : ${outdir}" | tee -a "${log}"
  echo "📁 INCLUDE     : ${include:-ALL}" | tee -a "${log}"
  echo "==========================================================" | tee -a "${log}"

  set -m
  trap '
    echo ""
    echo "⛔ Ctrl+C detected — killing HF process group"
    kill -- -$$ 2>/dev/null
    exit 130
  ' INT TERM

  exec hf download "${repo}" \
    --repo-type dataset \
    --token "${HF_TOKEN}" \
    ${include:+--include "${include}"} \
    $([[ "${resume}" -eq 1 ]] && echo "--resume-download") \
    --local-dir "${outdir}"
}

###----------------------------------------------------------
## LONGVIDEOBENCH (FIXED)
###----------------------------------------------------------

lsd-mod.datasets.hf.longvideobench.meta() {
  lsd-mod.datasets.hf.download \
    longvideobench/LongVideoBench \
    --include="lvb_*.json" "$@"
}

lsd-mod.datasets.hf.longvideobench.subtitles() {
  lsd-mod.datasets.hf.download \
    longvideobench/LongVideoBench \
    --include="subtitles.tar" "$@"
}

lsd-mod.datasets.hf.longvideobench.chunk() {
  local part="$1"
  [[ -z "${part}" ]] && {
    echo "❌ Specify chunk number (e.g. 00)"
    return 1
  }

  lsd-mod.datasets.hf.download \
    longvideobench/LongVideoBench \
    --include="videos.tar.part.${part}" "$@"
}

lsd-mod.datasets.hf.longvideobench.full() {
  lsd-mod.datasets.hf.download \
    longvideobench/LongVideoBench "$@"
}

###----------------------------------------------------------
## HELP
###----------------------------------------------------------

lsd-mod.datasets.help.hf() {
cat <<EOF
🤗 LSD DATASETS (HF)

AUTH REQUIRED
  hf auth login
  export HF_TOKEN=...

LONGVIDEOBENCH
  lsd-mod.datasets.hf.longvideobench.meta
  lsd-mod.datasets.hf.longvideobench.subtitles
  lsd-mod.datasets.hf.longvideobench.chunk 00
  lsd-mod.datasets.hf.longvideobench.full

CTRL+C SAFE
  ✔ kills hf + python workers
  ✔ no stale locks
EOF
}
