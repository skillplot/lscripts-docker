#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## pyenv installation
#
## References:
## * https://realpython.com/intro-to-pyenv/
## * https://medium.com/python-programming-at-work/multiple-python-versions-with-pyenv-266e1801ff3d
## * https://gist.github.com/mttmantovani/a8b820a9ccc673f6ec7265d234000635
## * https://github.com/pyenv/pyenv-virtualenvwrapper
#
## * pyenv manages multiple versions of Python itself.
## * virtualenv/venv manages virtual environments for a specific Python version.
## * pyenv-virtualenv manages virtual environments for across varying versions of Python.
#
## ```
## pyenv global system
## pyenv versions
### Install specific python version
## pyenv install 3.6.15
### Activate specific to a terminal only
## pyenv shell 3.6.15
## Install virtualenv virtualenvwrapper
## pip install virtualenv virtualenvwrapper
## ```
###----------------------------------------------------------


function python-pyenv-prequiresite() {
  sudo apt -y install --no-install-recommends \
    make \
    build-essential \
    libssl-dev zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    libxml2-dev \
    libxmlsec1-dev \
    python-openssl
}


function __python-pyenv-install() {
  export PYENV_ROOT="${__DATAHUB_ROOT__}/.pyenv"
  curl -s -S -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
}


function python-pyenv-config() {
  ## FYI: not required with boozo stack, as it's pre-configured

  [[ -f ${_LSD__BASHRC_FILE} ]] || lsd-mod.log.fail "File does not exits,_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"

  local LINE
  local FILE=${_LSD__BASHRC_FILE}

  export PYENV_ROOT="${__DATAHUB_ROOT__}/.pyenv"
  # LINE='export PYENV_ROOT="${HOME}/.pyenv"'
  LINE='export PYENV_ROOT="${__DATAHUB_ROOT__}/.pyenv"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export PATH="${PYENV_ROOT}/bin:$PATH"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='type pyenv &>/dev/null && eval "$(pyenv init -)"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  # LINE='export PYENV_VIRTUALENVWRAPPER_PREFER_PYENV="true"'
  # grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='type pyenv &>/dev/null && eval "$(pyenv virtualenv-init -)"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  # this will work only if the script is invoked with `source` command
  source ${FILE}
}


function python-pyenv-list() {
  type pyenv &>/dev/null && pyenv install --list | grep " 3\.[678]" || {
    lsd-mod.log.echo "pyenv not installed or configured properly"
  }
}


function python-pyenv-main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  source ${LSCRIPTS}/core/argparse.sh "$@"

  ## keeping the fail check here and not the beginning because want to print the CUDA stack details
  local _default=no
  local _que
  local _msg
  local _prog

  _prog="python-pyenv"


  _que="Install ${_prog} prequiresite now"
  _msg="Skipping ${_prog} prequiresite installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && (
    # set -x
    lsd-mod.log.echo "Installing prequiresite..."
    ${_prog}-prequiresite "$@"
    # set +x
  ) || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && (
    # set -x
    lsd-mod.log.echo "Installing..."
    __${_prog}-install "$@"
    # set +x
  ) || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

  _que="Configure ${_prog} now"
  _msg="Skipping ${_prog} configuration!"
  lsd-mod.fio.yesno_${_default} "${_que}" && (
    # set -x
    lsd-mod.log.echo "Configuring..."
    ${_prog}-config "$@"
    # set +x
  ) || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

  _que="Listing ${_prog} now"
  _msg="Skipping ${_prog} listing!"
  lsd-mod.fio.yesno_${_default} "${_que}" && (
    # set -x

    [[ -f ${_LSD__BASHRC_FILE} ]] || lsd-mod.log.fail "File does not exits,_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"
    local FILE=${_LSD__BASHRC_FILE}

    source ${FILE}

    # exec "$SHELL"


    lsd-mod.log.echo "Listing..."
    ${_prog}-list "$@"

    lsd-mod.log.echo "Pyenv help menu..."
    pyenv

    lsd-mod.log.echo "Current python version..."
    # pyenv version
    pyenv versions
    # set +x

    # lsd-mod.log.echo "PYENV_VERSION"

    lsd-mod.log.echo "pyenv root::"
    pyenv root

    lsd-mod.log.echo "PYENVY_ROOT: ${PYENVY_ROOT}"
  ) || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

}


python-pyenv-main "$@"
