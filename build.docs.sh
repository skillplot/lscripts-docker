#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ruby latest version using rbenv setup
###----------------------------------------------------------

## building jeykll site locally

_LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

pushd ${_LSCRIPTS}/docs
bundle config set --local path vendor/bundle
bundle install

popd ${_LSCRIPTS}/docs
