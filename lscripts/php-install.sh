#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## PHP
###----------------------------------------------------------


function __php-install() {
  if [ -z "${PHP_VER}" ]; then
    local PHP_VER="7.2"
    echo "Unable to get PHP_VER version, falling back to default version#: ${PHP_VER}"
  fi

  ##----------------------------------------------------------
  ## Ubuntu 16.04 LTS
  ##----------------------------------------------------------
  #[php7 on Ubuntu 14.04](https://askubuntu.com/questions/873768/how-do-i-install-php7-on-ubuntu-14-04)
  #[composer](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-14-04)

  ## Ubuntu 16.04 LTS
  [[ ${LINUX_VERSION} == "16.04" ]] && (
    echo ${LINUX_VERSION}
    ## Add ppa
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt -y update
    ##apt-cache search php7
    # 7.0, 7.1, 7.2 are available
  )

  ##----------------------------------------------------------
  ## Ubuntu 18.04 LTS
  ## https://ubuntuforums.org/showthread.php?t=2393823
  ##----------------------------------------------------------

  local _php=php${PHP_VER}
  # Ubuntu 18.04 LTS
  if [[ ${LINUX_VERSION} == "18.04" ]]; then
    echo ${LINUX_VERSION}
    ## Uninstall ppa
    sudo apt-add-repository -y --remove ppa:ondrej/php
    sudo apt purge ${_php} ${_php}-common
  fi

  ## bullseye for RPI
  if [[ ${LINUX_CODE_NAME} == "bullseye" ]]; then
    echo ${LINUX_CODE_NAME}
    sudo wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    # echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
    echo "deb https://packages.sury.org/php/ ${LINUX_CODE_NAME} main" | sudo tee /etc/apt/sources.list.d/php.list
  fi

  sudo apt -y install curl git
  sudo apt -y install ${_php} ${_php}-cli

  sudo apt -y install php-mysql

  sudo apt -y install \
    ${_php}-fpm \
    ${_php}-gd \
    ${_php}-mysql \
    ${_php}-readline \
    ${_php}-xml \
    ${_php}-mbstring \
    ${_php}-curl \
    ${_php}-zip

  ## TODO: conditionaly check only for php < 8.0 as
  ## Reference: https://php.watch/versions/8.0/ext-json
  sudo apt -y install ${_php}-json
  ##----------------------------------------------------------
  ### Install PHP 7 Imagick Extension
  ## Tested on Ubuntu 16.04
  ##----------------------------------------------------------
  ## https://linoxide.com/ubuntu-how-to/install-php7-imagick-ubuntu-16/
  ##----------------------------------------------------------

  # sudo apt install python-software-properties software-properties-common
  sudo apt -y install php-imagick
  echo ""
  echo "PHP_VERify the installation: "
  echo ""
  php -m | grep imagick
}


function __php_composer-install() {
  ##----------------------------------------------------------
  ### Install composer
  ##----------------------------------------------------------
  source ${LSCRIPTS}/php_composer-install.sh
}


function php-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _default=no
  local _que
  local _msg
  local _prog

  _prog="php"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install || {
      lsd-mod.log.echo "${_msg}"
    }

  _prog="php_composer"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install || {
      lsd-mod.log.echo "${_msg}"
    }
}

php-install.main "$@"
