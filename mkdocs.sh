#!/bin/bash

## __author__='mangalbhaskar'


function mkdocs-api() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local mkdocs_yml=$1
  [[ ! -z ${mkdocs_yml} ]] || mkdocs_yml="${LSCRIPTS}/mkdocs.yml"

  echo "Using Mkdocs YAML: ${mkdocs_yml}"
  ## local execstart_path=${AI_PY_VENV_PATH}/skydnn/bin
  ## ${execstart_path}/mkdocs build --clean -f ${mkdocs_yml}
  mkdocs build --clean -f ${mkdocs_yml}
}

mkdocs-api "$@"
