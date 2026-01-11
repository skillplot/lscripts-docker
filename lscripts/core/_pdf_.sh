#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__='mangalbhaskar'
###----------------------------------------------------------
## LSD PDF Utilities (merge, convert, inspect)
###----------------------------------------------------------

### Internal helpers
function _lsd_pdf__timestamp() {
  date +'%d%m%y_%H%M%S'
}

function _lsd_pdf__ensure_logdir() {
  local logdir="${1:-logs}"
  mkdir -p "${logdir}"
  echo "${logdir}"
}


###----------------------------------------------------------
## INSTALL
###----------------------------------------------------------
function lsd-mod.pdf.install.core() {
  sudo apt update
  sudo apt install -y poppler-utils pdfgrep pdftk ghostscript
  echo "Installed PDF Utilities"
}

function lsd-mod.pdf.install.all() {
  lsd-mod.pdf.install.core
}

###----------------------------------------------------------
## INSTALL (EXTENDED)
###----------------------------------------------------------
function lsd-mod.pdf.install.color() {
  sudo apt update
  sudo apt install -y poppler-utils ghostscript imagemagick
  echo "Installed PDF color inspection utilities"
}

###----------------------------------------------------------
## MERGE
###----------------------------------------------------------

### merge two PDFs
function lsd-mod.pdf.merge.two() {
  local out="merged_$(_lsd_pdf__timestamp).pdf"
  pdftk "$1" "$2" cat output "${out}"
  echo "Merged: ${out}"
}

### merge all PDFs
function lsd-mod.pdf.merge.all() {
  local out="merged_all_$(_lsd_pdf__timestamp).pdf"
  pdftk *.pdf cat output "${out}"
  echo "Merged all: ${out}"
}


###----------------------------------------------------------
## CONVERT
###----------------------------------------------------------

### convert RGB PDF to grayscale
function lsd-mod.pdf.convert.rgb-to-gray() {
  local infile="$1"
  local out="gray_$(_lsd_pdf__timestamp).pdf"

  gs -sDEVICE=pdfwrite \
     -dCompatibilityLevel=1.4 \
     -dProcessColorModel=/DeviceGray \
     -dColorConversionStrategy=/Gray \
     -dNOPAUSE -dBATCH \
     -sOutputFile="${out}" \
     "${infile}"

  echo "Converted to grayscale: ${out}"
}

### convert PDF pages to images
function lsd-mod.pdf.convert.pages-to-images() {
  local pdf="$1"
  local ts=$(_lsd_pdf__timestamp)
  local outdir="${ts}/pages"

  mkdir -p "${outdir}"
  pdftoppm -jpeg -jpegopt quality=100 -r 300 "${pdf}" "${outdir}/page"
  echo "Extracted pages: ${outdir}"
}


###----------------------------------------------------------
## INSPECT
###----------------------------------------------------------

### search inside PDFs
function lsd-mod.pdf.inspect.grep() {
  pdfgrep "$1" *.pdf
}

###----------------------------------------------------------
## COLOR INSPECTION (VECTOR-SAFE)
###----------------------------------------------------------
function lsd-mod.pdf.color.inspect() {
  local pdf="$1"
  [[ -f "${pdf}" ]] || { echo "❌ PDF not found"; return 1; }

  local ts=$(_lsd_pdf__timestamp)
  local outdir="pdf_color_${ts}"
  mkdir -p "${outdir}"

  echo "🔍 Inspecting VECTOR color schema: ${pdf}"
  echo "📂 Output: ${outdir}"

  ### Step 1: Detect declared color spaces
  echo ""
  echo "📌 Declared Color Spaces:"
  gs -q -dNODISPLAY -c "
    (${pdf}) (r) file runpdfbegin
    pdfdict /ColorSpace known {
      pdfdict /ColorSpace get ==
    }{
      (No explicit ColorSpace dictionary found) =
    } ifelse
    quit
  " | tee "${outdir}/colorspaces.txt"

  ### Step 2: Extract color-setting operators
  echo ""
  echo "🎨 Color Operators Used:"
  pdftocairo -ps "${pdf}" "${outdir}/content" 2>/dev/null

  grep -Eo \
    '([0-9.]+ ){2}rg|([0-9.]+ ){3}k|([0-9.]+ ){3}RG|([0-9.]+ ){4}K' \
    "${outdir}"/content*.ps \
    | sort -u \
    | tee "${outdir}/color_operators.txt"

  ### Step 3: Human-readable summary
  echo ""
  echo "📊 Summary:"
  if grep -q ' rg\| RG' "${outdir}/color_operators.txt"; then
    echo "  ✔ RGB colors detected (DeviceRGB)"
  fi
  if grep -q ' k\| K' "${outdir}/color_operators.txt"; then
    echo "  ✔ CMYK colors detected (DeviceCMYK)"
  fi
  if ! grep -Eq 'rg|k|RG|K' "${outdir}/color_operators.txt"; then
    echo "  ⚠ No explicit RGB/CMYK operators detected (likely ICCBased)"
  fi

  echo ""
  echo "✅ Vector color inspection complete."
}


###----------------------------------------------------------
## COLOR INSPECTION (EPS – ROBUST POSTSCRIPT)
###----------------------------------------------------------
function lsd-mod.pdf.color.inspect.eps() {
  local eps="$1"
  [[ -f "${eps}" ]] || { echo "❌ EPS not found"; return 1; }

  local ts=$(_lsd_pdf__timestamp)
  local outdir="eps_color_${ts}"
  mkdir -p "${outdir}"

  echo "🔍 Inspecting EPS color schema: ${eps}"
  echo "📂 Output: ${outdir}"

  echo ""
  echo "🎨 Color operators detected:"

  grep -Eo \
    '([0-9.]+ ){2}(rg|RG)|([0-9.]+ ){3}(k|K)|([0-9.]+ )(g|G)|([0-9.]+ ){2}setrgbcolor|([0-9.]+ ){3}setcmykcolor|([0-9.]+ )setgray' \
    "${eps}" \
    | sort -u \
    | tee "${outdir}/color_operators.txt"

  echo ""
  echo "📊 Summary:"
  if grep -Eq '( rg| RG|setrgbcolor)' "${outdir}/color_operators.txt"; then
    echo "  ✔ RGB colors detected"
  fi
  if grep -Eq '( k| K|setcmykcolor)' "${outdir}/color_operators.txt"; then
    echo "  ✔ CMYK colors detected"
  fi
  if grep -Eq '( g| G|setgray)' "${outdir}/color_operators.txt"; then
    echo "  ✔ Grayscale detected"
  fi

  if [[ ! -s "${outdir}/color_operators.txt" ]]; then
    echo "  ⚠ No explicit color operators found"
    echo "    → Possibly procedure-wrapped or binary EPS"
  fi

  echo ""
  echo "📁 Raw operator list: ${outdir}/color_operators.txt"
  echo "✅ EPS color inspection complete."
}

###----------------------------------------------------------
## HELP
###----------------------------------------------------------

function lsd-mod.pdf.help.main() {
  echo "----------------------------------------------------------"
  echo "📚 LSD PDF MODULE HELP"
  echo "----------------------------------------------------------"
  echo "Semantic Groups:"
  echo "  install   - Install pdf utilities"
  echo "  merge     - Merge multiple PDFs"
  echo "  convert   - Convert/mutate PDF formats"
  echo "  inspect   - Search and inspect PDFs"
  echo "  color     - Inspect PDF color models (RGB / CMYK)"
  echo "----------------------------------------------------------"
  echo "Use: lsd-pdf.help.<group> to view group-level commands."
  echo "----------------------------------------------------------"
}

function lsd-mod.pdf.help.install() {
  cat <<EOF
📦 INSTALL COMMANDS:
  lsd-pdf.install.core      → Install poppler-utils, pdfgrep, pdftk, ghostscript
  lsd-pdf.install.all       → Install all required PDF tools
EOF
}

function lsd-mod.pdf.help.merge() {
  cat <<EOF
🧩 MERGE COMMANDS:
  lsd-pdf.merge.two <pdf1> <pdf2>
      → Merge exactly two PDFs into an immutable timestamped output

  lsd-pdf.merge.all
      → Merge all PDFs in the directory into a single file
EOF
}

function lsd-mod.pdf.help.convert() {
  cat <<EOF
🔄 CONVERT COMMANDS:
  lsd-pdf.convert.rgb-to-gray <pdf>
      → Convert any PDF containing RGB images → grayscale PDF

  lsd-pdf.convert.pages-to-images <pdf>
      → Convert all PDF pages to JPEG images (300 DPI, high quality)
EOF
}

function lsd-mod.pdf.help.inspect() {
  cat <<EOF
🔍 INSPECT COMMANDS:
  lsd-pdf.inspect.grep <pattern>
      → Search all PDFs for regex pattern using pdfgrep
EOF
}

function lsd-mod.pdf.help.color() {
  cat <<EOF
🎨 COLOR INSPECTION COMMANDS:
  lsd-pdf.color.inspect <pdf>
      → Detect logo/image color space
      → Extract numeric channel values
      → Infer RGB ⇄ CMYK counterpart
      → No mutation, analysis-only

  Output includes:
      - Color space per image
      - Channel means
      - Theoretical conversion values
EOF
}
