#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## www website cloning, information, diagnosis utilities
###----------------------------------------------------------


###----------------------------------------------------------
## lsd-mod.www.site.*  |  Website analysis utilities
## Dependencies installed automatically:
##   whois, dnsutils, whatweb, curl
###----------------------------------------------------------
function lsd-mod.www.site.ensure-tools() {
  local pkgs=("whois" "dnsutils" "whatweb" "curl")
  for pkg in "${pkgs[@]}"; do
    if ! command -v "${pkg}" &>/dev/null; then
      (>&2 echo ">>> Installing missing dependency: ${pkg}")
      sudo apt update -y >/dev/null 2>&1
      sudo apt install -y "${pkg}" >/dev/null 2>&1
    fi
  done
}

function lsd-mod.www.site.logpath() {
  local FUNC="$1"
  local DOMAIN="$2"
  local TS="$(date -d now +'%d%m%y_%H%M%S')"
  local LOGDIR="${HOME}/logs"
  mkdir -p "${LOGDIR}"
  echo "${LOGDIR}/site-${FUNC}-${DOMAIN}-${TS}.txt"
}


###----------------------------------------------------------
## WHOIS Information
###----------------------------------------------------------
function lsd-mod.www.site.whois() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.whois <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath whois "$DOMAIN")

  {
    echo "=== WHOIS Information for ${DOMAIN} ==="
    whois "$DOMAIN"
    echo "=== End of WHOIS ==="
  } | tee "${LOGFILE}"

  (>&2 echo ">>> WHOIS saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## lsd-mod.www.site.hosting Hosting provider lookup
###----------------------------------------------------------
function lsd-mod.www.site.hosting() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.hosting <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath hosting "$DOMAIN")

  {
    echo "=== Hosting / IP Owner Info for ${DOMAIN} ==="
    local IP=$(dig +short A "$DOMAIN" | head -n1)
    echo "Resolved IP: ${IP}"
    if [[ -n "$IP" ]]; then
      echo ""
      echo "--- WHOIS for IP ---"
      whois "$IP" | grep -E "OrgName|Organization|owner|netname|country|descr|CIDR|inetnum"
    else
      echo "Could not resolve IP for ${DOMAIN}"
    fi
    echo "=== End of Hosting Info ==="
  } | tee "${LOGFILE}"

  (>&2 echo ">>> Hosting info saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## DNS / Nameserver Information
###----------------------------------------------------------
function lsd-mod.www.site.dns() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.dns <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath dns "$DOMAIN")

  {
    echo "=== DNS Information for ${DOMAIN} ==="
    echo "--- NS Records ---"
    dig +short NS "$DOMAIN"
    echo "--- A Records ---"
    dig +short A "$DOMAIN"
    echo "--- MX Records ---"
    dig +short MX "$DOMAIN"
    echo "--- TXT Records ---"
    dig +short TXT "$DOMAIN"
    echo "=== End of DNS ==="
  } | tee "${LOGFILE}"

  (>&2 echo ">>> DNS info saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## Technology Stack (WhatWeb)
###----------------------------------------------------------
function lsd-mod.www.site.tech() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.tech <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath tech "$DOMAIN")

  {
    echo "=== Technology Detection for ${DOMAIN} ==="
    whatweb --color=never --verbose "$URL"
    echo "=== End of Technology Detection ==="
  } | tee "${LOGFILE}"

  (>&2 echo ">>> Tech stack saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## HTTP Headers
###----------------------------------------------------------
function lsd-mod.www.site.header() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.header <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath header "$DOMAIN")

  {
    echo "=== HTTP Headers for ${DOMAIN} ==="
    curl -Is "$URL" | sed -e 's/^/  /'
    echo "=== End of HTTP Headers ==="
  } | tee "${LOGFILE}"

  (>&2 echo ">>> Header info saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## lsd-mod.www.site.geo Geo-location lookup
###----------------------------------------------------------
function lsd-mod.www.site.geo() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.geo <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  if ! command -v geoiplookup >/dev/null 2>&1; then
    (>&2 echo ">>> Installing geoiplookup ...")
    sudo apt update -y >/dev/null 2>&1
    sudo apt install -y geoip-bin >/dev/null 2>&1
  fi

  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath geo "$DOMAIN")

  {
    echo "=== GeoIP Info for ${DOMAIN} ==="
    local IP=$(dig +short A "$DOMAIN" | head -n1)
    echo "Resolved IP: ${IP}"
    [[ -n "$IP" ]] && geoiplookup "$IP" || echo "IP not found for ${DOMAIN}"
    echo "=== End of GeoIP ==="
  } | tee "${LOGFILE}"

  (>&2 echo ">>> GeoIP info saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## lsd-mod.www.site.info Website info utilities
## Use CLI tools (whois, whatweb, dig, curl) to extract
## domain registration, DNS, tech stack, server headers.
###----------------------------------------------------------
function lsd-mod.www.site.info() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.info <url>"; return 1; }
  lsd-mod.www.site.ensure-tools
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local LOGFILE=$(lsd-mod.www.site.logpath info "$DOMAIN")

  {
    echo "=============================================================="
    echo "Site Info Report for: ${URL}"
    echo "Generated on: $(date)"
    echo "=============================================================="
    echo ""
    echo "--- WHOIS ---"
    whois "$DOMAIN"
    echo ""
    echo "--- DNS ---"
    dig +short NS "$DOMAIN"
    dig +short A "$DOMAIN"
    echo ""
    echo "--- TECHNOLOGY STACK ---"
    whatweb --color=never --verbose "$URL"
    echo ""
    echo "--- HEADERS ---"
    curl -Is "$URL" | head -n20
    echo ""
    echo "=============================================================="
    echo "End of Site Info Report"
  } | tee "${LOGFILE}"

  (>&2 echo ">>> Site report saved to: ${LOGFILE}")
}


###----------------------------------------------------------
## lsd-mod.www.site.fingerprint  |  Run all website intelligence utilities
###----------------------------------------------------------
## Runs: whois, dns, tech, header, hosting, geo
## Each function writes its own log automatically.
## Output: Individual log files under ~/logs/
###----------------------------------------------------------
function lsd-mod.www.site.fingerprint() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.site.fingerprint <url>"; return 1; }

  echo "=============================================================="
  echo "Comprehensive Site Diagnostics for: ${URL}"
  echo "Started at: $(date)"
  echo "=============================================================="
  echo ""

  ## Ensure all dependencies once
  lsd-mod.www.site.ensure-tools

  ## Execute each function sequentially
  lsd-mod.www.site.whois   "$URL"
  lsd-mod.www.site.dns     "$URL"
  lsd-mod.www.site.tech    "$URL"
  lsd-mod.www.site.header  "$URL"

  ## Optional advanced diagnostics if defined
  type lsd-mod.www.site.hosting &>/dev/null && lsd-mod.www.site.hosting "$URL"
  type lsd-mod.www.site.geo &>/dev/null && lsd-mod.www.site.geo "$URL"

  echo ""
  echo "=============================================================="
  echo "Diagnostics completed for ${URL}"
  echo "Individual logs are stored under: ${HOME}/logs/"
  echo "=============================================================="
}


###----------------------------------------------------------
## lsd-mod.www.clone-site.static Website Cloning utilities
## Clone entire website with HTTrack into
##   $HOME/public_html/<domain>-<ddmmyy_hhmmss>/
## Requires: httrack (auto-installed if missing)
###----------------------------------------------------------
function lsd-mod.www.clone-site.static() {
  local URL="$1"

  if [[ -z "$URL" ]]; then
    (>&2 echo "Usage: lsd-mod.www.clone-site.static <url>")
    return 1
  fi

  ## Ensure httrack is installed
  if ! command -v httrack >/dev/null 2>&1; then
    (>&2 echo ">>> Installing httrack ...")
    sudo apt update -y >/dev/null 2>&1
    sudo apt install -y httrack >/dev/null 2>&1
  fi

  ## Domain extraction & timestamp
  local DOMAIN
  DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local TS
  TS=$(date -d now +'%d%m%y_%H%M%S')

  ## Target path
  local TARGET_DIR="${HOME}/public_html/${DOMAIN}-${TS}"

  (>&2 echo ">>> Creating target directory: ${TARGET_DIR}")
  mkdir -p "${TARGET_DIR}"

  ## Begin mirroring
  (>&2 echo ">>> Starting full mirror for: ${URL}")
  httrack "${URL}" \
    -O "${TARGET_DIR}" \
    "+*${DOMAIN}/*" \
    "+*.jpg" "+*.jpeg" "+*.png" "+*.gif" "+*.svg" "+*.webp" \
    "+*.css" "+*.js" "+*.woff" "+*.woff2" "+*.ttf" "+*.eot" \
    "+*.pdf" "+*.doc" "+*.docx" "+*.xls" "+*.xlsx" "+*.txt" "+*.zip" \
    --mirror --depth=10 --robots=0 --updatehack --disable-security-limits \
    --max-rate=0 --sockets=10 --keep-alive --timeout=30 \
    --user-agent "Mozilla/5.0 (X11; Ubuntu; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128 Safari/537.36" \
    --verbose

  ## Completion message
  (>&2 echo ">>> Clone complete. Files saved under: ${TARGET_DIR}")
  (>&2 echo ">>> To browse locally:")
  (>&2 echo "    cd '${TARGET_DIR}' && python3 -m http.server 8181")
  (>&2 echo "    Open: http://localhost:8181")
}


function lsd-mod.www.clone-site.browsertrix() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.clone-site.browsertrix <url>"; return 1; }

  type docker &>/dev/null || {
    (>&2 echo "✗ Docker not found. Install Docker first."); return 1;
  }

  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local TS=$(date -d now +'%d%m%y_%H%M%S')
  local OUTDIR="${HOME}/public_html/${DOMAIN}-browsertrix-${TS}"
  mkdir -p "${OUTDIR}"

  (>&2 echo ">>> Launching Browsertrix crawl for ${URL}")
  docker run --rm -it \
    -v "${OUTDIR}:/crawls" \
    webrecorder/browsertrix-crawler \
    crawl --url "${URL}" --depth 2 --scopeType domain \
          --saveAssets true --text --screenshot --outputDir /crawls

  (>&2 echo ">>> Crawl complete. Output: ${OUTDIR}")
  (>&2 echo ">>> To preview locally:")
  (>&2 echo "    cd '${OUTDIR}' && python3 -m http.server 8181")
}


###----------------------------------------------------------
## lsd-mod.www.clone-site.capture-website
## Capture a fully-rendered single page using capture-website
## Requires: capture-website (npm i -g capture-website)
###----------------------------------------------------------
function lsd-mod.www.clone-site.capture-website() {
  local URL="$1"
  [[ -z "$URL" ]] && { echo "Usage: lsd-mod.www.clone-site.capture-website <url>"; return 1; }

  ## Check dependency
  type capture-website &>/dev/null || {
    (>&2 echo "✗ capture-website not found. Install with:")
    (>&2 echo "    npm install -g capture-website")
    return 1
  }

  ## Domain, timestamp, and output path
  local DOMAIN=$(echo "$URL" | awk -F[/:] '{print $4}' | sed 's/^www\.//g')
  local TS=$(date -d now +'%d%m%y_%H%M%S')
  local OUTDIR="${HOME}/public_html/${DOMAIN}-capture-${TS}"
  mkdir -p "${OUTDIR}"

  ## Capture file names
  local OUT_HTML="${OUTDIR}/index.html"
  local OUT_PNG="${OUTDIR}/snapshot.png"
  local OUT_PDF="${OUTDIR}/snapshot.pdf"

  (>&2 echo ">>> Capturing dynamic snapshot for ${URL}")
  (>&2 echo ">>> Output directory: ${OUTDIR}")

  ## Capture rendered HTML
  capture-website "${URL}" \
    --output "${OUT_HTML}" \
    --full-page \
    --type=html \
    --overwrite \
    --dark-mode=false \
    --timeout=120 \
    --delay=2s \
    && (>&2 echo ">>> HTML snapshot saved: ${OUT_HTML}") \
    || (>&2 echo "✗ HTML snapshot failed.")

  ## Capture screenshot (optional visual)
  capture-website "${URL}" \
    --output "${OUT_PNG}" \
    --full-page \
    --type=png \
    --dark-mode=false \
    --timeout=120 \
    --delay=2s \
    && (>&2 echo ">>> PNG screenshot saved: ${OUT_PNG}") \
    || (>&2 echo "✗ PNG screenshot failed.")

  ## Capture PDF (for recordkeeping)
  capture-website "${URL}" \
    --output "${OUT_PDF}" \
    --type=pdf \
    --timeout=120 \
    --delay=2s \
    && (>&2 echo ">>> PDF snapshot saved: ${OUT_PDF}") \
    || (>&2 echo "✗ PDF snapshot failed.")

  (>&2 echo ">>> To preview locally:")
  (>&2 echo "    cd '${OUTDIR}' && python3 -m http.server 8181")
}


###----------------------------------------------------------
## List all cloned sites in $HOME/public_html
## Usage: lsd-mod.www.clone-site.list
###----------------------------------------------------------
function lsd-mod.www.clone-site.list() {
  local PUB_DIR="${HOME}/public_html"
  [[ ! -d "${PUB_DIR}" ]] && { (>&2 echo "No public_html directory found."); return 1; }
  (>&2 echo ">>> Listing cloned site directories under ${PUB_DIR}:")
  ls -1t "${PUB_DIR}" | grep -E '[0-9]{6}_[0-9]{6}' | awk '{printf "%-50s %s\n", $1, strftime("%Y-%m-%d %H:%M:%S", systime())}'
}
