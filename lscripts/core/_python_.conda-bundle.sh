#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
## __author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Conda offline bundle subsystem (v2)
## Air-gapped export / verify / install
###----------------------------------------------------------

###----------------------------------------------------------
## Internal helpers
###----------------------------------------------------------

function _lsd_bundle_abs() {
  local p="$1"
  [[ -z "$p" ]] && return 1
  command -v realpath &>/dev/null && realpath -m "$p" || python - <<PY
import os,sys; print(os.path.abspath(sys.argv[1]))
PY
}

function _lsd_bundle_guard_path_or_die() {
  local ap
  ap="$(_lsd_bundle_abs "$1")"
  [[ -z "$ap" || "$ap" == "/" || "$ap" == "/mnt" ]] && \
    lsd-mod.log.fail "Refusing dangerous bundle path: ${ap}"
}

function _lsd_bundle_confirm() {
  lsd-mod.fio.confirm \
    --title "$1" \
    --message "$2" \
    --expect "$3"
}

function _lsd_bundle_detect_torch_abi() {
  local env="$1"

  conda run -n "$env" python - <<'PY'
try:
  import torch
  cuda = torch.version.cuda
  if cuda is None:
    print("cpu")
  else:
    maj, min = cuda.split(".")[:2]
    print(f"cu{maj}{min}")
except Exception:
  print("none")
PY
}

function _lsd_bundle_torch_index_from_requirements() {
  local req="$1"

  local abi
  abi=$(grep -E '^torch==' "$req" | sed -n 's/.*+\(cu[0-9]\+\)$/\1/p')

  if [[ -n "$abi" ]]; then
    echo "https://download.pytorch.org/whl/${abi}"
    return
  fi

  if grep -q '^torch==.*+cpu' "$req"; then
    echo "https://download.pytorch.org/whl/cpu"
    return
  fi

  # Fallback: CPU index (safe)
  echo "https://download.pytorch.org/whl/cpu"
}


###----------------------------------------------------------
## Torch detection (AUTHORITATIVE)
###----------------------------------------------------------

function _lsd_bundle_detect_torch_pip() {
  local env="$1"
  local out="$2"

  local exclude
  exclude="$(lsd-mod.python.conda._pip_exclude_re)"

  conda run -n "${env}" pip freeze --all \
    | grep -E '^(torch|torchvision|torchaudio|nvidia-.*)==' \
    > "${out}"

  [[ -s "${out}" ]]
}

###----------------------------------------------------------
## Bundle export
###----------------------------------------------------------

function lsd-mod.python.conda.envs.bundle.export() {
  lsd-mod.python.conda._require_conda
  source "$(dirname "${BASH_SOURCE[0]}")/argparse-v2.sh" "$@"

  local env="${args[name]}"
  local out="${args[out]}"
  local overwrite="${args[overwrite]}"

  [[ -z "$env" || -z "$out" ]] && \
    lsd-mod.log.fail "--name and --out required"

  conda env list | awk '{print $1}' | grep -qx "$env" || \
    lsd-mod.log.fail "Environment not found: $env"

  _lsd_bundle_guard_path_or_die "$out"

  [[ -d "$out" && "$overwrite" != "true" ]] && \
    lsd-mod.log.fail "Bundle exists — use --overwrite=true"

  [[ -d "$out" ]] && rm -rf "$out"
  mkdir -p "$out"/{META,CONDA,PIP/wheels,TORCH/wheels}

  _lsd_bundle_confirm \
    "Confirm export" \
    "Type EXPORT to create bundle at: $out" \
    "EXPORT"

  ### 1. Pin conda env
  lsd-mod.python.conda.envs.pin \
    --name="$env" \
    --out="$out/CONDA"

  ### 2. Pip requirements (NON-TORCH)
  cp "$out/CONDA/${env}.pip.txt" \
     "$out/PIP/requirements.pip.txt"

  ### 3. Torch requirements (pip-installed only)
  : > "$out/TORCH/requirements.torch.txt"
  _lsd_bundle_detect_torch_pip "$env" \
    "$out/TORCH/requirements.torch.txt" || true

  ### 4. Download pip wheels (safe overwrite)
  lsd-mod.log.info "Downloading pip wheels"
  conda run -n "$env" pip download \
    --no-deps \
    --no-input \
    --exists-action=w \
    -r "$out/PIP/requirements.pip.txt" \
    -d "$out/PIP/wheels" || \
      lsd-mod.log.fail "pip download failed"

  ### 5. Download torch wheels (if any)
  if [[ -s "$out/TORCH/requirements.torch.txt" ]]; then
    local torch_index
    torch_index="$(_lsd_bundle_torch_index_from_requirements \
      "$out/TORCH/requirements.torch.txt")"

    lsd-mod.log.info "Downloading torch wheels from: $torch_index"

    conda run -n "$env" pip download \
      --no-deps \
      --no-input \
      --exists-action=w \
      --index-url "$torch_index" \
      -r "$out/TORCH/requirements.torch.txt" \
      -d "$out/TORCH/wheels" || \
        lsd-mod.log.fail "torch wheel download failed"
  fi

  ### 6. Manifest
  lsd-mod.python.conda.envs.bundle.manifest \
    --bundle="$out" \
    --name="$env"

  ### 7. Checksums (exclude self)
  ( cd "$out" && \
    find . -type f ! -path "./META/checksums.sha256" -exec sha256sum {} \; \
  ) > "$out/META/checksums.sha256"

  lsd-mod.log.success "Offline bundle created: $out"
}

###----------------------------------------------------------
## Bundle manifest
###----------------------------------------------------------

function lsd-mod.python.conda.envs.bundle.manifest() {
  source "$(dirname "${BASH_SOURCE[0]}")/argparse-v2.sh" "$@"

  local bundle="${args[bundle]}"
  local env="${args[name]}"

  [[ -z "$bundle" || -z "$env" ]] && \
    lsd-mod.log.fail "--bundle and --name required"

  local m="$bundle/META/bundle.manifest.yml"

  {
    echo "schema: lsd-conda-bundle-v1"
    echo "env: $env"
    echo "created_at: $(date -Iseconds)"
    echo
    echo "conda:"
    ls "$bundle/CONDA" | sed 's/^/  - /'
    echo "pip:"
    ls "$bundle/PIP/wheels" | sed 's/^/  - /'
    echo "torch:"
    ls "$bundle/TORCH/wheels" 2>/dev/null | sed 's/^/  - /' || echo "  - none"
  } > "$m"

  lsd-mod.log.success "Manifest written: $m"
}

###----------------------------------------------------------
## Bundle verify
###----------------------------------------------------------

function lsd-mod.python.conda.envs.bundle.verify() {
  source "$(dirname "${BASH_SOURCE[0]}")/argparse-v2.sh" "$@"

  local bundle="${args[bundle]}"
  [[ -z "$bundle" ]] && lsd-mod.log.fail "--bundle required"

  _lsd_bundle_guard_path_or_die "$bundle"

  lsd-mod.log.info "Verifying bundle: $bundle"

  ( cd "$bundle" && sha256sum -c META/checksums.sha256 ) || \
    lsd-mod.log.fail "Checksum verification failed"

  lsd-mod.log.success "Bundle verification completed"
}

###----------------------------------------------------------
## Bundle install
###----------------------------------------------------------

function lsd-mod.python.conda.envs.bundle.install() {
  source "$(dirname "${BASH_SOURCE[0]}")/argparse-v2.sh" "$@"

  local bundle="${args[bundle]}"
  local name="${args[name]}"
  local dry="${args[dry-run]}"

  [[ -z "$bundle" || -z "$name" ]] && \
    lsd-mod.log.fail "--bundle and --name required"

  _lsd_bundle_guard_path_or_die "$bundle"

  local lock
  lock=$(ls "$bundle/CONDA/"*.explicit.lock | head -1)
  [[ -z "$lock" ]] && lsd-mod.log.fail "Conda lock file not found"

  lsd-mod.log.echo
  lsd-mod.log.echo "Offline Bundle Install Plan"
  lsd-mod.log.echo "----------------------------------------------"
  lsd-mod.log.echo "Bundle   : $bundle"
  lsd-mod.log.echo "Env name : $name"
  lsd-mod.log.echo "Dry-run  : ${dry:-false}"
  lsd-mod.log.echo

  if [[ "$dry" != "true" ]]; then
    _lsd_bundle_confirm \
      "Confirm install" \
      "Type INSTALL to create env '$name'" \
      "INSTALL"
  fi

  ### 1. Conda environment
  if [[ "$dry" == "true" ]]; then
    echo "conda create -n $name --file $lock"
  else
    conda create -n "$name" --file "$lock" || \
      lsd-mod.log.fail "Conda environment creation failed"
  fi

  ### 2. Torch layer (if present)
  if [[ -s "$bundle/TORCH/requirements.torch.txt" ]]; then
    if [[ "$dry" == "true" ]]; then
      echo "pip install torch layer"
    else
      conda run -n "$name" pip install \
        --no-index \
        --no-deps \
        --no-build-isolation \
        --find-links "$bundle/TORCH/wheels" \
        -r "$bundle/TORCH/requirements.torch.txt"

      conda run -n "$name" python - <<'PY'
import torch
print("Torch:", torch.__version__)
print("CUDA :", torch.version.cuda)
PY
    fi
  else
    lsd-mod.log.info "Torch layer not present; skipping"
  fi

  ### 3. Base pip layer
  if [[ "$dry" == "true" ]]; then
    echo "pip install base layer"
  else
    conda run -n "$name" pip install \
      --no-index \
      --no-deps \
      --no-build-isolation \
      --find-links "$bundle/PIP/wheels" \
      -r "$bundle/PIP/requirements.pip.txt" || \
        lsd-mod.log.fail "Base pip layer install failed"
  fi

  ### 4. Integrity check
  if [[ "$dry" == "true" ]]; then
    lsd-mod.log.warn "Dry-run complete — no changes were made"
  else
    local pip_check_out
    pip_check_out="$(conda run -n "$name" pip check || true)"

    if [[ -n "$pip_check_out" ]]; then
      if echo "$pip_check_out" | grep -q '^decord '; then
        lsd-mod.log.warn "pip check warning (known platform issue):"
        echo "$pip_check_out" | sed 's/^/  /'
      else
        echo "$pip_check_out"
        lsd-mod.log.fail "Dependency integrity check failed"
      fi
    fi

    lsd-mod.log.success "Bundle installed: $name"
  fi
}
