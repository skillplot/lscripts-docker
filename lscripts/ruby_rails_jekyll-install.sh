#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Ruby
###----------------------------------------------------------


function ruby_rails_jekyll-install.main() {
  # sudo apt install ruby ruby-dev
  sudo apt install -y ruby`ruby -e 'puts RUBY_VERSION[/\d+\.\d+/]'`-dev
  ruby -v

  ##----------------------------------------------------------
  ### bundler, Jekyll
  ##----------------------------------------------------------
  sudo gem update --system

  # sudo gem install jekyll -v 2.4.0
  sudo gem install bundler jekyll
  gem -v

  ## To allow non-sudo user to install to the RubyGems
  bundle config set --local path 'vendor/bundle'
}

ruby_rails_jekyll-install.main "$@"
