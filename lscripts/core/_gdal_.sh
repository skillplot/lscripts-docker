#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__='mangalbhaskar'
###----------------------------------------------------------
## LSD GDAL / COG / GeoTIFF Utilities
##  - COG creation and validation
##  - GeoTIFF compression / translation
##  - Reprojection and generic GDAL wrappers
###----------------------------------------------------------

### Internal helpers
function _lsd_gdal__timestamp() {
  date +'%d%m%y_%H%M%S'
}

function _lsd_gdal__ensure_logdir() {
  local logdir="${1:-logs}"
  mkdir -p "${logdir}"
  echo "${logdir}"
}

function _lsd_gdal__require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "❌ Required command not found: ${cmd}"
    return 1
  fi
}

function _lsd_gdal__uuid() {
  if command -v uuid >/dev/null 2>&1; then
    uuid
  elif command -v uuidgen >/dev/null 2>&1; then
    uuidgen
  else
    date +'%s%N'
  fi
}


###----------------------------------------------------------
## INSTALL
###----------------------------------------------------------
function lsd-mod.gdal.install.core() {
  sudo apt update
  sudo apt install -y gdal-bin
  echo "Installed GDAL core utilities (gdal-bin)"
}

function lsd-mod.gdal.install.cog-tools() {
  ## placeholder for COG validators or extra tools
  ## Example (if you decide later):
  ##   pip install cogeo-mosaic cogeo-validator
  echo "Install additional COG-related tools (customize as needed)."
}

function lsd-mod.gdal.install.all() {
  lsd-mod.gdal.install.core
  lsd-mod.gdal.install.cog-tools
}


###----------------------------------------------------------
## COG (Cloud Optimized GeoTIFF)
###----------------------------------------------------------

### lsd-mod.gdal.cog.from-tiff
### Create a COG from a single TIFF file.
### Args (via argparse.sh):
###   --path <tiff_path>   (required)
###   --out  <cog_path>    (optional; default: same dir + timestamp + .cog.tif)
function lsd-mod.gdal.cog.from-tiff() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local filepath=""
  local filepath_cog=""
  local ts=$(_lsd_gdal__timestamp)

  [[ -n "${args['path']+1}" ]] && filepath="${args['path']}"
  [[ -n "${args['out']+1}" ]] && filepath_cog="${args['out']}"

  if [[ -z "${filepath}" ]]; then
    echo "❌ Missing --path <tiff_file>"
    return 1
  fi

  if [[ ! -f "${filepath}" ]]; then
    echo "❌ File not found: ${filepath}"
    return 1
  fi

  if [[ -z "${filepath_cog}" ]]; then
    local dir base
    dir=$(dirname "${filepath}")
    base=$(basename "${filepath}")
    base="${base%.*}"
    filepath_cog="${dir}/${base}.${ts}.cog.tif"
  fi

  _lsd_gdal__require_cmd gdal_translate || return 1

  lsd-mod.log.debug "filepath: ${filepath}"
  lsd-mod.log.debug "filepath_cog: ${filepath_cog}"

  gdal_translate \
    -co TILED=YES \
    -co COMPRESS=DEFLATE \
    -co BIGTIFF=YES \
    -co COPY_SRC_OVERVIEWS=YES \
    "${filepath}" "${filepath_cog}"

  local rc=$?
  if [[ ${rc} -eq 0 ]]; then
    echo "✅ COG created: ${filepath_cog}"
  else
    echo "❌ gdal_translate failed with code: ${rc}"
  fi
  return ${rc}
}

### lsd-mod.gdal.cog.from-dir
### Convert all *.tif in a directory to COGs.
### Args:
###   --dir <path> (default: .)
function lsd-mod.gdal.cog.from-dir() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local dir="${args['dir']:-.}"
  local ts=$(_lsd_gdal__timestamp)

  if [[ ! -d "${dir}" ]]; then
    echo "❌ Directory not found: ${dir}"
    return 1
  fi

  _lsd_gdal__require_cmd gdal_translate || return 1

  for f in "${dir}"/*.tif; do
    [[ -f "${f}" ]] || continue
    local base
    base=$(basename "${f}")
    base="${base%.*}"
    local out="${dir}/${base}.${ts}.cog.tif"

    echo "→ Converting to COG: ${f} → ${out}"
    gdal_translate \
      -co TILED=YES \
      -co COMPRESS=DEFLATE \
      -co BIGTIFF=YES \
      -co COPY_SRC_OVERVIEWS=YES \
      "${f}" "${out}"
  done
}

### lsd-mod.gdal.cog.validate
### Validate a COG file if cog_validator is available.
### Args:
###   --path <cog_path>
function lsd-mod.gdal.cog.validate() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local filepath="${args['path']:-}"

  if [[ -z "${filepath}" ]]; then
    echo "❌ Missing --path <cog_file>"
    return 1
  fi

  if [[ ! -f "${filepath}" ]]; then
    echo "❌ File not found: ${filepath}"
    return 1
  fi

  if ! command -v cog_validator >/dev/null 2>&1; then
    echo "⚠️ cog_validator not found. Install it or wire your own validator."
    return 1
  fi

  cog_validator "${filepath}"
}


###----------------------------------------------------------
## TIFF
###----------------------------------------------------------

### lsd-mod.gdal.tiff.compress
### Generic GeoTIFF compression.
### Args:
###   --path <tiff_path>   (required)
###   --out  <out_path>    (optional; default: same dir + .deflate.tif)
###   --compress <codec>   (default: DEFLATE)
###   --tiled <YES/NO>     (default: YES)
function lsd-mod.gdal.tiff.compress() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local filepath="${args['path']:-}"
  local filepath_out="${args['out']:-}"
  local compress="${args['compress']:-DEFLATE}"
  local tiled="${args['tiled']:-YES}"
  local ts=$(_lsd_gdal__timestamp)

  if [[ -z "${filepath}" ]]; then
    echo "❌ Missing --path <tiff_file>"
    return 1
  fi

  if [[ ! -f "${filepath}" ]]; then
    echo "❌ File not found: ${filepath}"
    return 1
  fi

  if [[ -z "${filepath_out}" ]]; then
    local dir base
    dir=$(dirname "${filepath}")
    base=$(basename "${filepath}")
    base="${base%.*}"
    filepath_out="${dir}/${base}.${ts}.compressed.tif"
  fi

  _lsd_gdal__require_cmd gdal_translate || return 1

  echo "→ Compressing TIFF:"
  echo "   src : ${filepath}"
  echo "   dest: ${filepath_out}"
  echo "   COMPRESS=${compress}, TILED=${tiled}"

  gdal_translate \
    -co TILED=${tiled} \
    -co COMPRESS=${compress} \
    -co BIGTIFF=YES \
    "${filepath}" "${filepath_out}"
}

### lsd-mod.gdal.tiff.info
### Wrapper around gdalinfo.
### Args:
###   --path <file>
###   --stats (optional, any non-empty value enables -stats)
function lsd-mod.gdal.tiff.info() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local filepath="${args['path']:-}"
  local stats="${args['stats']:-}"

  if [[ -z "${filepath}" ]]; then
    echo "❌ Missing --path <file>"
    return 1
  fi

  if [[ ! -f "${filepath}" ]]; then
    echo "❌ File not found: ${filepath}"
    return 1
  fi

  _lsd_gdal__require_cmd gdalinfo || return 1

  if [[ -n "${stats}" ]]; then
    gdalinfo -stats "${filepath}"
  else
    gdalinfo "${filepath}"
  fi
}


###----------------------------------------------------------
## INFO / GENERIC
###----------------------------------------------------------

### lsd-mod.gdal.info
### Thin wrapper: gdalinfo <path>
function lsd-mod.gdal.info() {
  local filepath="$1"

  if [[ -z "${filepath}" ]]; then
    echo "❌ Usage: lsd-gdal.info <path>"
    return 1
  fi

  if [[ ! -f "${filepath}" ]]; then
    echo "❌ File not found: ${filepath}"
    return 1
  fi

  _lsd_gdal__require_cmd gdalinfo || return 1
  gdalinfo "${filepath}"
}


###----------------------------------------------------------
## WARP (REPROJECT)
###----------------------------------------------------------

### lsd-mod.gdal.warp.reproject
### Reproject a raster to a target SRS.
### Args:
###   --src <path>      (required)
###   --dst <path>      (optional; default: src + .reproj.<timestamp>.tif)
###   --srs <EPSG:xxx>  (required)
function lsd-mod.gdal.warp.reproject() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local src="${args['src']:-}"
  local dst="${args['dst']:-}"
  local srs="${args['srs']:-}"

  if [[ -z "${src}" || -z "${srs}" ]]; then
    echo "❌ Usage: --src <path> --srs <EPSG:xxxx> [--dst <path>]"
    return 1
  fi

  if [[ ! -f "${src}" ]]; then
    echo "❌ File not found: ${src}"
    return 1
  fi

  if [[ -z "${dst}" ]]; then
    local dir base ts
    dir=$(dirname "${src}")
    base=$(basename "${src}")
    base="${base%.*}"
    ts=$(_lsd_gdal__timestamp)
    dst="${dir}/${base}.${ts}.reproj.tif"
  fi

  _lsd_gdal__require_cmd gdalwarp || return 1

  echo "→ Reprojecting:"
  echo "   src : ${src}"
  echo "   dst : ${dst}"
  echo "   srs : ${srs}"

  gdalwarp -t_srs "${srs}" "${src}" "${dst}"
}


###----------------------------------------------------------
## TRANSLATE (GENERIC WRAPPER)
###----------------------------------------------------------

### lsd-mod.gdal.translate.generic
### Generic wrapper over gdal_translate with extra options.
### Args:
###   --src <path>       (required)
###   --dst <path>       (required)
###   --opts "<options>" (optional, raw string appended)
### Example:
###   lsd-gdal.translate.generic --src in.tif --dst out.tif --opts "-co COMPRESS=DEFLATE -co TILED=YES"
function lsd-mod.gdal.translate.generic() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local src="${args['src']:-}"
  local dst="${args['dst']:-}"
  local opts="${args['opts']:-}"

  if [[ -z "${src}" || -z "${dst}" ]]; then
    echo "❌ Usage: --src <path> --dst <path> [--opts \"<options>\"]"
    return 1
  fi

  if [[ ! -f "${src}" ]]; then
    echo "❌ File not found: ${src}"
    return 1
  fi

  _lsd_gdal__require_cmd gdal_translate || return 1

  echo "→ gdal_translate:"
  echo "   src : ${src}"
  echo "   dst : ${dst}"
  echo "   opts: ${opts}"

  if [[ -n "${opts}" ]]; then
    # shellcheck disable=SC2086
    gdal_translate ${opts} "${src}" "${dst}"
  else
    gdal_translate "${src}" "${dst}"
  fi
}


###----------------------------------------------------------
## BATCH
###----------------------------------------------------------

### lsd-mod.gdal.batch.cog-from-list
### Convert a list of TIFFs into COGs.
### Args:
###   --list <file>   File containing one TIFF path per line.
function lsd-mod.gdal.batch.cog-from-list() {
  local LSCRIPTS
  LSCRIPTS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  source "${LSCRIPTS}/argparse.sh" "$@"

  local list="${args['list']:-}"

  if [[ -z "${list}" ]]; then
    echo "❌ Missing --list <file_with_paths>"
    return 1
  fi

  if [[ ! -f "${list}" ]]; then
    echo "❌ List file not found: ${list}"
    return 1
  fi

  while IFS= read -r line; do
    [[ -z "${line}" ]] && continue
    echo "→ COG from list entry: ${line}"
    lsd-mod.gdal.cog.from-tiff --path "${line}"
  done < "${list}"
}


###----------------------------------------------------------
## HELP
###----------------------------------------------------------
function lsd-mod.gdal.help.main() {
  echo "----------------------------------------------------------"
  echo "🌍 LSD GDAL / COG MODULE HELP"
  echo "----------------------------------------------------------"
  echo "Semantic Groups:"
  echo "  install   - Install GDAL & COG-related tools"
  echo "  cog       - Create & validate Cloud Optimized GeoTIFFs"
  echo "  tiff      - Compress & inspect GeoTIFFs"
  echo "  info      - Generic gdalinfo wrappers"
  echo "  warp      - Reprojection workflows (gdalwarp)"
  echo "  translate - Generic gdal_translate wrapper"
  echo "  batch     - Batch COG generation"
  echo "  test      - Environment checks"
  echo "----------------------------------------------------------"
  echo "Use: lsd-gdal.help.<group> to view group-level commands."
  echo "----------------------------------------------------------"
}

function lsd-mod.gdal.help.install() {
  cat <<EOF
📦 INSTALL COMMANDS:
  lsd-gdal.install.core
      → Install gdal-bin

  lsd-gdal.install.cog-tools
      → Install extra COG-related tools (customize implementation)

  lsd-gdal.install.all
      → Run all GDAL-related installers
EOF
}

function lsd-mod.gdal.help.cog() {
  cat <<EOF
☁️ COG COMMANDS:
  lsd-gdal.cog.from-tiff --path <tiff> [--out <cog>]
      → Create a Cloud Optimized GeoTIFF (COG) from a TIFF file.

  lsd-gdal.cog.from-dir --dir <folder>
      → Convert all *.tif in <folder> to COGs (timestamped filenames).

  lsd-gdal.cog.validate --path <cog>
      → Validate a COG using cog_validator (if installed).
EOF
}

function lsd-mod.gdal.help.tiff() {
  cat <<EOF
🧱 TIFF COMMANDS:
  lsd-gdal.tiff.compress --path <tiff> [--out <out>] [--compress <codec>] [--tiled YES|NO]
      → Compress a GeoTIFF with chosen codec (default: DEFLATE, TILED=YES).

  lsd-gdal.tiff.info --path <file> [--stats 1]
      → gdalinfo wrapper; pass --stats to compute statistics.
EOF
}

function lsd-mod.gdal.help.info() {
  cat <<EOF
ℹ️ INFO COMMANDS:
  lsd-gdal.info <path>
      → Simple gdalinfo <path>
EOF
}

function lsd-mod.gdal.help.warp() {
  cat <<EOF
🗺️ WARP COMMANDS:
  lsd-gdal.warp.reproject --src <file> --srs <EPSG:xxxx> [--dst <out>]
      → Reproject raster into target SRS using gdalwarp.
EOF
}

function lsd-mod.gdal.help.translate() {
  cat <<EOF
🔄 TRANSLATE COMMANDS:
  lsd-gdal.translate.generic --src <file> --dst <file> [--opts "<gdal_translate options>"]
      → Generic wrapper around gdal_translate.
EOF
}

function lsd-mod.gdal.help.batch() {
  cat <<EOF
📚 BATCH COMMANDS:
  lsd-gdal.batch.cog-from-list --list <file>
      → Create COGs from a list file (one TIFF path per line).
EOF
}

function lsd-mod.gdal.help.test() {
  cat <<EOF
🧪 TEST COMMANDS:
  lsd-gdal.test.env
      → Check presence of GDAL-related binaries.
EOF
}


###----------------------------------------------------------
## TEST
###----------------------------------------------------------
function lsd-mod.gdal.test.env() {
  echo "🧪 Checking GDAL environment..."
  for c in gdal_translate gdalinfo gdalwarp; do
    if command -v "${c}" >/dev/null 2>&1; then
      echo "✅ ${c} found"
    else
      echo "❌ ${c} MISSING"
    fi
  done

  if command -v cog_validator >/dev/null 2>&1; then
    echo "✅ cog_validator found"
  else
    echo "⚠️ cog_validator not found (optional)"
  fi
}
