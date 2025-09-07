#!/bin/bash
## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__='mangalbhaskar'
###----------------------------------------------------------
## figma desktop (linux wrapper) installation for Ubuntu 22.04 LTS
##
## Methods supported:
## * flatpak  (io.github.Figma_Linux.figma_linux)  [recommended]
## * deb      (github.com/Figma-Linux/figma-linux releases)
## * snap     (figma-linux)
##
## Env overrides (optional):
##   FIGMA_METHOD=flatpak|deb|snap
##   FIGMA_DEB_URL=https://github.com/Figma-Linux/figma-linux/releases/download/v0.10.0/figma-linux_0.10.0_linux_amd64.deb
###----------------------------------------------------------

function figma-uninstall() {
  local method="${FIGMA_METHOD:-flatpak}"
  if [[ "${method}" == "flatpak" ]]; then
    flatpak uninstall -y io.github.Figma_Linux.figma_linux || true
  elif [[ "${method}" == "deb" ]]; then
    sudo apt -y remove figma-linux || true
  elif [[ "${method}" == "snap" ]]; then
    sudo snap remove figma-linux || true
  fi
}

function figma-desktop-entry() {
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/figma-linux.desktop <<'EOF'
[Desktop Entry]
Name=Figma
Comment=Figma Desktop (Flatpak)
Exec=flatpak run io.github.Figma_Linux.figma_linux %u
Terminal=false
Type=Application
Icon=io.github.Figma_Linux.figma_linux
Categories=Graphics;Design;Development;
StartupWMClass=Figma
MimeType=x-scheme-handler/figma;
EOF

update-desktop-database ~/.local/share/applications || true

xdg-mime default figma-linux.desktop x-scheme-handler/figma

}

function figma-wrapper() {
  echo '#!/usr/bin/env bash
flatpak run io.github.Figma_Linux.figma_linux "$@"' | sudo tee /usr/local/bin/figma >/dev/null
sudo chmod +x /usr/local/bin/figma
}

function figma-addrepo() {
  local method="${FIGMA_METHOD:-flatpak}"
  if [[ "${method}" == "flatpak" ]]; then
    sudo apt -y update
    sudo apt -y install flatpak || true
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    lsd-mod.log.info "Added/verified Flathub remote for Flatpak."
  elif [[ "${method}" == "deb" ]]; then
    sudo apt -y update
    sudo apt -y install wget gdebi-core || sudo apt -y install wget && sudo apt -y install gdebi-core
    lsd-mod.log.info "gdebi-core installed for .deb handling."
  elif [[ "${method}" == "snap" ]]; then
    sudo snap list >/dev/null 2>&1 || sudo apt -y install snapd
    lsd-mod.log.info "Snap is available."
  fi
}

function __figma-install() {
  local method="${FIGMA_METHOD:-flatpak}"
  local deb_url="${FIGMA_DEB_URL:-https://github.com/Figma-Linux/figma-linux/releases/download/v0.10.0/figma-linux_0.10.0_linux_amd64.deb}"

  if [[ "${method}" == "flatpak" ]]; then
    flatpak install -y flathub io.github.Figma_Linux.figma_linux
  elif [[ "${method}" == "deb" ]]; then
    local deb_file="/tmp/figma-linux_amd64.deb"
    wget -O "${deb_file}" "${deb_url}"
    sudo apt -y install "${deb_file}" || sudo gdebi -n "${deb_file}"
  elif [[ "${method}" == "snap" ]]; then
    sudo snap install figma-linux
  fi
}

function figma-configure() {
  local method="${FIGMA_METHOD:-flatpak}"
  if [[ "${method}" == "flatpak" ]]; then
    lsd-mod.log.info "Flatpak app will create desktop entry automatically."
  elif [[ "${method}" == "deb" ]]; then
    lsd-mod.log.info ".deb package ships a desktop entry; no extra configuration."
  elif [[ "${method}" == "snap" ]]; then
    lsd-mod.log.info "Snap provides autostart/desktop entry by default."
  fi
}

function figma-verify() {
  local method="${FIGMA_METHOD:-flatpak}"
  local ok=1

  if [[ "${method}" == "flatpak" ]]; then
    flatpak list | grep -q "io.github.Figma_Linux.figma_linux" && ok=0
  elif [[ "${method}" == "deb" ]]; then
    command -v figma-linux >/dev/null 2>&1 && ok=0
  elif [[ "${method}" == "snap" ]]; then
    snap list | grep -q "figma-linux" && ok=0
  fi

  if [[ ${ok} -eq 0 ]]; then
    lsd-mod.log.info "Figma Desktop appears installed. Try launching:"
    if [[ "${method}" == "flatpak" ]]; then
      lsd-mod.log.echo "flatpak run io.github.Figma_Linux.figma_linux"
    elif [[ "${method}" == "deb" ]]; then
      lsd-mod.log.echo "figma-linux"
    else
      lsd-mod.log.echo "figma-linux"
    fi
  else
    lsd-mod.log.warn "Figma Desktop not detected. Check logs above."
  fi
}

function figma-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/lscripts.config.sh"

  local scriptname=$(basename "${BASH_SOURCE[0]}")
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="figma"
  local _default=yes
  local _que
  local _msg

  lsd-mod.log.info "Install ${_prog} desktop on Ubuntu 22.04 LTS"
  lsd-mod.log.warn "sudo access is required!"
  lsd-mod.log.info "Selected method: ${FIGMA_METHOD:-flatpak}"

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
    lsd-mod.log.echo "Uninstalling..." && \
    ${_prog}-uninstall \
    || lsd-mod.log.echo "${_msg}"

  _que="Add ${_prog} repo/prereqs for method: ${FIGMA_METHOD:-flatpak}"
  _msg="Skipping repo/prereqs!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
    lsd-mod.log.echo "Adding repo/prereqs..." && \
    ${_prog}-addrepo \
    || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now via ${FIGMA_METHOD:-flatpak}"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
    lsd-mod.log.echo "Installing..." && \
    __${_prog}-install \
    || lsd-mod.log.echo "${_msg}"

  _que="Configure ${_prog} (desktop entries, etc.)"
  _msg="Skipping ${_prog} configuration!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
    lsd-mod.log.echo "Configuring..." && \
    ${_prog}-configure \
    || lsd-mod.log.echo "${_msg}"

  _que="Verify ${_prog} installation now"
  _msg="Skipping ${_prog} verification!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
    lsd-mod.log.echo "Verifying..." && \
    ${_prog}-verify \
    || lsd-mod.log.echo "${_msg}"
}

figma-install.main "$@"
