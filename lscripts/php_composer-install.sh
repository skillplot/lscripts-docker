#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install PHP Composer
###----------------------------------------------------------


function php_composer-install.main() {
  curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

  ## local (without sudo)
  # mkdir $HOME/bin
  # curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer
  # FILE=$HOME/.bashrc
  # LINE='export PATH="$PATH:$HOME/bin"'
  # grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  # source $FILE

  #sudo mv composer.phar /usr/local/bin/composer
  composer -h
}

php_composer-install.main "$@"
