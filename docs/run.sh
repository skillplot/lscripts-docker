#!/bin/bash

port=$1
[[ -z ${port} ]] || port=4040
bundle exec jekyll serve --incremental -o --livereload --port ${port}
