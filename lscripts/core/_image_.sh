#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__='mangalbhaskar'
###----------------------------------------------------------
## LSD Image Utilities (convert, transform, extract)
###----------------------------------------------------------

### Internal helpers
function _lsd_image__timestamp() {
  date +'%d%m%y_%H%M%S'
}

function _lsd_image__ensure_logdir() {
  local logdir="${1:-logs}"
  mkdir -p "${logdir}"
  echo "${logdir}"
}

## Convert comma-separated list into array
function _lsd_image__split_csv_to_array() {
  local input="$1"
  IFS=',' read -r -a out <<< "${input}"
  echo "${out[@]}"
}

## Resolve files for PDF conversion
function _lsd_image__resolve_image_inputs() {
  local arg="$1"
  local resolved=()

  # If argument contains comma → multiple items
  if [[ "${arg}" == *,* ]]; then
    local items=($( _lsd_image__split_csv_to_array "${arg}" ))
    for item in "${items[@]}"; do
      # Expand glob patterns and paths safely
      for f in ${item}; do
        [[ -f "${f}" ]] && resolved+=("${f}")
      done
    done
  else
    # Single extension (any), glob, or single file
    if [[ "${arg}" =~ ^\*\. ]]; then
      # "*.jpg"
      for f in ${arg}; do
        [[ -f "${f}" ]] && resolved+=("${f}")
      done
    elif [[ -f "${arg}" ]]; then
      resolved+=("${arg}")
    else
      # Argument is EXTENSION like jpg, png, tiff
      for f in *.${arg}; do
        [[ -f "${f}" ]] && resolved+=("${f}")
      done
    fi
  fi

  printf '%s\n' "${resolved[@]}"
}


###----------------------------------------------------------
## INSTALL
###----------------------------------------------------------
function lsd-mod.image.install.core() {
  sudo apt update
  sudo apt install -y imagemagick graphicsmagick poppler-utils
  echo "Installed Image Utilities"
}

function lsd-mod.image.install.all() {
  lsd-mod.image.install.core
}


###----------------------------------------------------------
## TRANSFORM
###----------------------------------------------------------

### resize images
function lsd-mod.image.transform.resize() {
  local ext="${1:-jpg}"
  local percent="${2:-50}"
  local ts=$(_lsd_image__timestamp)

  for f in *.${ext}; do
    [[ -f "$f" ]] || continue
    convert "$f" -resize "${percent}%" "${ts}---${f}"
    echo "Resized: ${f}"
  done
}

### grayscale images
function lsd-mod.image.transform.to-gray() {
  local ext="${1:-jpg}"
  local ts=$(_lsd_image__timestamp)

  for f in *.${ext}; do
    [[ -f "$f" ]] || continue
    convert "$f" -colorspace Gray "${ts}---gray---${f}"
    echo "Grayscale: ${f}"
  done
}

### compress images
function lsd-mod.image.transform.compress() {
  local ext="${1:-jpg}"
  local quality="${2:-60}"
  local ts=$(_lsd_image__timestamp)

  for f in *.${ext}; do
    [[ -f "$f" ]] || continue
    convert "$f" -quality "${quality}" "${ts}---compressed---${f}"
  done
}


###----------------------------------------------------------
## CONVERT
###----------------------------------------------------------

### NEW: robust PDF conversion
### Accepts:
###   - single ext: jpg
###   - csv ext: jpg,png,tiff
###   - specific files: "img 1.jpg,img 2.png"
###   - mixed patterns: "*.jpg,*.png,photo 3.jpeg"
### Example:
###   lsd-image.convert.to-pdf jpg,png
###   lsd-image.convert.to-pdf "img 1.jpg,img 2.png"
###   lsd-image.convert.to-pdf "*.jpg,*.png"
###----------------------------------------------------------
function lsd-mod.image.convert.to-pdf() {
  local input="${1:-jpg}"
  local ts=$(_lsd_image__timestamp)
  local outfile="images_${ts}.pdf"

  echo "Resolving inputs for: ${input}"

  mapfile -t files < <(_lsd_image__resolve_image_inputs "${input}")

  if [[ "${#files[@]}" -eq 0 ]]; then
    echo "❌ No images found matching: ${input}"
    return 1
  fi

  echo "Files to convert:"
  for f in "${files[@]}"; do
    echo "  → ${f}"
  done

  gm convert "${files[@]}" "${outfile}"
  echo "PDF created: ${outfile}"
}

### convert directories to pdf (unchanged)
function lsd-mod.image.convert.all-to-pdf() {
  for d in */; do
    local out="${d%/}_$(_lsd_image__timestamp).pdf"
    gm convert "${d}"/*.jpg "${out}"
    echo "PDF created: ${out}"
  done
}


###----------------------------------------------------------
## EXTRACT
###----------------------------------------------------------

### extract images from PDFs
function lsd-mod.image.extract.from-pdf() {
  local ext="${1:-pdf}"
  local ts=$(_lsd_image__timestamp)

  for f in *.${ext}; do
    [[ -f "$f" ]] || continue

    local clean=$(echo "$f" | tr '[:upper:]' '[:lower:]' |
                sed 's/[^a-zA-Z0-9._-]/_/g')
    local fname="${clean%.*}"
    local outdir="${ts}/${fname}"

    mkdir -p "${outdir}"
    pdfimages -j "${f}" "${outdir}/img"
    echo "Extracted: ${outdir}"
  done
}

###----------------------------------------------------------
## INTERNAL: logo / square conversion helpers
###----------------------------------------------------------

function _lsd_image__default_logo_sizes() {
  echo "1536x1536,1400x1400,1280x1280,1152x1152,1024x1024,896x896"
}

function _lsd_image__parse_sizes() {
  local input="$1"
  local default_sizes
  default_sizes=$(_lsd_image__default_logo_sizes)

  if [[ -z "${input}" ]]; then
    echo "${default_sizes}"
    return
  fi

  # validate wxh pattern
  local valid=1
  IFS=',' read -r -a arr <<< "${input}"
  for s in "${arr[@]}"; do
    [[ "${s}" =~ ^[0-9]+x[0-9]+$ ]] || valid=0
  done

  if [[ "${valid}" -eq 0 ]]; then
    echo "⚠️  Invalid --size input '${input}', using defaults" >&2
    echo "${default_sizes}"
  else
    echo "${input}"
  fi
}

###----------------------------------------------------------
## CONVERT: logo / square image variants
###----------------------------------------------------------
function lsd-mod.image.convert.logo() {
  local input="$1"; shift

  if [[ -z "${input}" ]]; then
    echo "❌ Input image or directory is required"
    return 1
  fi

  local size_arg=""
  local ext_override=""

  for arg in "$@"; do
    case "${arg}" in
      --size=*) size_arg="${arg#*=}" ;;
      --ext=*)  ext_override="${arg#*=}" ;;
    esac
  done

  local ts
  ts=$(_lsd_image__timestamp)
  local outroot="logs/images-${ts}"
  mkdir -p "${outroot}"

  local sizes_csv
  sizes_csv=$(_lsd_image__parse_sizes "${size_arg}")
  IFS=',' read -r -a SIZES <<< "${sizes_csv}"

  local process_file
  process_file() {
    local src="$1"
    local rel="$2"

    local fname
    fname="$(basename "${src}")"
    local base="${fname%.*}"
    local in_ext="${fname##*.}"
    local out_ext="${ext_override:-${in_ext}}"

    local outdir="${outroot}/${rel}"
    mkdir -p "${outdir}"

    for sz in "${SIZES[@]}"; do
      local w="${sz%x*}"
      local h="${sz#*x}"
      local pad=$(( w / 5 ))

      local outfile="${outdir}/${base}-${w}x${h}.${out_ext}"

      convert "${src}" \
        -resize $((w - pad))x$((h - pad)) \
        -background white \
        -gravity center \
        -extent "${w}x${h}" \
        "${outfile}"

      echo "✔ ${outfile}"
    done
  }

  if [[ -f "${input}" ]]; then
    process_file "${input}" ""
  elif [[ -d "${input}" ]]; then
    local base_dir
    base_dir="$(basename "${input}")"

    find "${input}" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | while read -r f; do
      local rel
      rel="$(dirname "${f#${input}/}")"
      process_file "${f}" "${base_dir}/${rel}"
    done
  else
    echo "❌ Invalid input: ${input}"
    return 1
  fi

  echo "----------------------------------------------------------"
  echo "📂 Output directory:"
  echo "  ${outroot}"
}

###----------------------------------------------------------
## HELP
###----------------------------------------------------------
function lsd-mod.image.help.main() {
  echo "----------------------------------------------------------"
  echo "🖼️  LSD IMAGE MODULE HELP"
  echo "----------------------------------------------------------"
  echo "Semantic Groups:"
  echo "  install    - Install required image utilities"
  echo "  transform  - Resize, grayscale, compress images"
  echo "  convert    - Convert images to PDF (supports CSV & filenames)"
  echo "  extract    - Extract images from PDFs"
  echo "----------------------------------------------------------"
  echo "Use: lsd-image.help.<group> to view group-level commands."
  echo "----------------------------------------------------------"
}

function lsd-mod.image.help.install() {
  cat <<EOF
📦 INSTALL COMMANDS:
  lsd-image.install.core       → Install imagemagick, graphicsmagick, poppler-utils
  lsd-image.install.all        → Install all components
EOF
}

function lsd-mod.image.help.transform() {
  cat <<EOF
🎨 TRANSFORM COMMANDS:
  lsd-image.transform.resize <ext> <percent> 
      → Resize images (default: JPG → 50%)

  lsd-image.transform.to-gray <ext>             
      → Convert images to grayscale

  lsd-image.transform.compress <ext> <quality>
      → Compress images (default quality: 60)
EOF
}

function lsd-mod.image.help.convert() {
  cat <<EOF
📄 CONVERT COMMANDS:

----------------------------------------------------------
PDF CONVERSION
----------------------------------------------------------

  lsd-image.convert.to-pdf <input>
      → Convert images to PDF

  INPUT supports:
      - extension: jpg
      - multiple extensions: jpg,png,tiff
      - file paths (with spaces): "img 1.jpg,img 2.png"
      - glob patterns: "*.png,*.jpg"

  Examples:
      lsd-image.convert.to-pdf jpg
      lsd-image.convert.to-pdf jpg,png
      lsd-image.convert.to-pdf "*.jpg,*.png"
      lsd-image.convert.to-pdf "img 1.jpg,img 2.png"

----------------------------------------------------------
LOGO / SOCIAL IMAGE CONVERSION
----------------------------------------------------------

  lsd-image.convert.logo <image|directory>
      [--size=wxh,w2xh2,...]
      [--ext=jpg|png|webp]

      → Generate square logo / social-media variants
      → Preserves directory & nested sub-directory structure
      → Outputs to: logs/images-<ddmmyy_hhmmss>/

  Defaults:
      sizes : 1536x1536,1400x1400,1280x1280,1152x1152,1024x1024,896x896
      ext   : same as input image

  Notes:
      - --size accepts a single value or CSV (always parsed as array)
      - Invalid --size falls back to defaults with warning
      - Basename is derived from input filename
      - No default image name is assumed

  Examples:
      lsd-image.convert.logo logo.png
      lsd-image.convert.logo logo.png --size=1024x1024
      lsd-image.convert.logo logos/
      lsd-image.convert.logo logos/ --ext=jpg
      lsd-image.convert.logo logos/ --size=512x512,256x256

EOF
}
