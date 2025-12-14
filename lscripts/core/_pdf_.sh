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
