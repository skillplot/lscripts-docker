#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ruby latest version using rbenv setup
###----------------------------------------------------------


sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev \
autoconf bison build-essential libyaml-dev libncurses5-dev \
libffi-dev libgdbm-dev libdb-dev

git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Add to your .bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Apply changes to your current session
source ~/.bashrc

mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# This may take several minutes as it compiles Ruby
rbenv install 3.2.2

# Set it as your global version
# rbenv global 3.2.2
# rbenv rehash
rbenv local 3.2.2
## Verify the installation
ruby -v

gem install bundler
gem update --system 4.0.6

## building jeykll site locally
# cd docs
# bundle config set --local path vendor/bundle
# bundle install
# bundle exec jekyll serve --livereload
