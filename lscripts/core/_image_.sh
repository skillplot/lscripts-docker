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
EOF
}

function lsd-mod.image.help.extract() {
  cat <<EOF
📤 EXTRACT COMMANDS:
  lsd-image.extract.from-pdf <ext>
      → Extract all images from PDFs using poppler-utils
EOF
}
