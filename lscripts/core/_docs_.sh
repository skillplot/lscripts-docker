#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## documentation utility functions
#
## References:
## How to read a file line by line
##  * https://stackoverflow.com/a/10929511
##  * https://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable?answertab=active#tab-top
##  Use IFS (internal field separator) tool in bash, defines the character using to separate lines into tokens, by default includes <tab> /<space> /<newLine>
#
## https://unix.stackexchange.com/questions/41357/what-is-the-most-correct-way-to-pass-an-array-to-a-function
## https://tecadmin.net/how-to-extract-filename-extension-in-shell-script/
## https://matthewsetter.com/convert-markdown-to-asciidoc-with-kramdown-asciidoc/
## https://www.howtogeek.com/435164/how-to-use-the-xargs-command-on-linux/
#
## ls -d -1 userguide/*.adoc | xargs printf -- 'include::%s[]\n' > /AI_ML_Hub/docs/userguide.adoc
## gem install kramdown-asciidoc
###----------------------------------------------------------


function lsd-mod.docs.get__vars() {
  ## Todo
  lsd-mod.log.echo "Coming soon..."
}


function lsd-mod.docs.mkdocs() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

  local __path
  [[ -n "${args['path']+1}" ]] && __path=${args['path']}

  local mkdocs_yml=${__path}
  local current_dir=${PWD}
  [[ ! -z ${mkdocs_yml} ]] || mkdocs_yml="${current_dir}/mkdocs.yml"

  [[ -f ${mkdocs_yml} ]] || lsd-mod.log.fail "${mkdocs_yml} file does not exists."

  lsd-mod.log.echo "Using Mkdocs YAML: ${mkdocs_yml}"

  (
    type mkdocs &>/dev/null && mkdocs build --clean -f ${mkdocs_yml} || \
      lsd-mod.log.fail "mkdocs: command not found."
  )
}

function lsd-mod.docs.pandoc.markdown2latex() {
  type pandoc &>/dev/null && {
    ## pbpaste: xsel --clipboard --output
    ## pbcopy: xsel --clipboard --input
    xsel --clipboard --output | pandoc -f markdown -t latex | sed -e 's/\\tightlist//'  | xsel --clipboard --input &&
      lsd-mod.log.echo "Converted LaTeX is also copied to clipboard.\n\n"
      xsel --clipboard --output
  } || lsd-mod.log.echo "pandoc is not installed! Use: lsd-install.pandoc-wget-dpkg"
}

function lsd-mod.docs.mkdocs.link() {
  local www_root="$HOME/public_html"
  local www_docs="${www_root}/docs"

  local current_dir=${PWD}
  local host_dir_name=$(basename ${current_dir})
  local host_dir=${host_dir_name}-$(lsd-mod.date.get__timestamp)
  [[ -d ${current_dir}/_site ]] && {
    mkdir -p "${www_docs}"
    lsd-mod.log.echo "www_docs:: ${www_docs}"

    lsd-mod.log.echo "ln -s ${current_dir}/_site ${www_docs}/${host_dir}"

    [[ ! -d ${www_docs}/${host_dir} ]] && \
      ln -s ${current_dir}/_site ${www_docs}/${host_dir} || \
      lsd-mod.log.warn "${www_docs}/${host_dir} already exists. Rename or remove it first."

    [[ -L ${www_docs}/${host_dir_name} ]] && \
      unlink ${www_docs}/${host_dir_name}

    [[ -d ${www_docs}/${host_dir_name} ]] && \
      mv ${www_docs}/${host_dir_name} ${host_dir_name}-$(lsd-mod.date.get__timestamp)

    lsd-mod.log.echo "ln -s ${www_docs}/${host_dir} ${www_docs}/${host_dir_name}"
    ln -s ${www_docs}/${host_dir} ${www_docs}/${host_dir_name}

    lsd-mod.log.echo "Timestamped:: http://localhost/~$(id -un)/docs/${host_dir}"
    lsd-mod.log.ok "Default (latest):: http://localhost/~$(id -un)/docs/${host_dir_name}"
    ls -ltr ${www_docs} 2>/dev/null
  } || lsd-mod.log.warn "${current_dir}/_site directory does not exists."
}


function lsd-mod.docs.mkdocs.deploy() {
  lsd-mod.docs.mkdocs "$@"
  lsd-mod.docs.mkdocs.link "$@"
}


function lsd-mod.docs.arxiv.download() {
  local _dirpath
  lsd-mod.log.echo "Enter the directory path [ Press Enter for default: /tmp]:"
  read _dirpath

  [[ -d "${_dirpath}" ]] && _dirpath=${_dirpath%/} || _dirpath="/tmp"
  lsd-mod.log.echo "Using directory path: ${_dirpath}"

  # local _filepath="${_dirpath}/$(basename "${_dirpath}")-$(date -d now +'%d%m%y_%H%M%S')"
  # lsd-mod.log.echo ${_filepath}

  local _filepath="arxiv.org.ids"

  [[ -f "${_filepath}" ]] || lsd-mod.log.fail "Invalid _filepath: ${_filepath}"
  lsd-mod.log.echo "Using directory path: ${_filepath}"

  mkdir -p ${_dirpath}
  lsd-mod.log.echo "Download path: ${_dirpath}"

  local line
  local waittime=10
  while IFA='' read -r line; do
    local _filepath="${_dirpath}/${line}.pdf"
    local _url="https://arxiv.org/abs/${line}"
    local _url_pdf="https://arxiv.org/pdf/${line}.pdf"

    # lsd-mod.log.echo "LINE: ${line}"
    lsd-mod.log.echo "URL: ${_url}"
    lsd-mod.log.echo "sleep for ${waittime} seconds..."
    lsd-mod.log.echo "wget --user-agent='Mozilla' -c ${_url_pdf} -P ${_dirpath}"

    [[ -f ${_filepath} ]] && lsd-mod.log.echo "Already exists: ${_filepath}" || {
      sleep ${waittime} && wget --user-agent="Mozilla" -c ${_url_pdf} -P ${_dirpath}
    }
    ls -ltr ${_filepath}
  done < "${_filepath}"
}


function lsd-mod.docs.asciidoc.create_pdf() {
  local SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local _out_filepath=$1
  local _in_asciidoc_filepath=$2
  local _stylesheets_path=${SCRIPTS_DIR}/stylesheets/colony.css

  if [[ ! -z $3 ]]; then
    _stylesheets_path=$3
  fi

  lsd-mod.log.echo "out-file: ${_out_filepath}"
  lsd-mod.log.echo "in-file: ${_in_asciidoc_filepath}"

  # asciidoctor-pdf --trace -v \
  asciidoctor-pdf \
    -d book \
    -a stylesheet=${_stylesheets_path} \
    -a linkcss! \
    -a icons=font \
    -a icon-set=pf \
    -a source-highlighter=highlightjs \
    -a toc \
    -a toc2 \
    -a toclevels=3 \
    -a toc=right \
    -a idprefix! \
    -a idseparator=- \
    -a sectanchors \
    -a data-uri \
    -a allow-uri-read \
    --out-file ${_out_filepath} \
    ${_in_asciidoc_filepath}

  # lsd-mod.log.echo "evince ${_out_filepath}"
}


function lsd-mod.docs.asciidoc.create_html() {
  local _out_filepath=$1
  local _in_asciidoc_filepath=$2
  local _stylesheets_path=${SCRIPTS_DIR}/stylesheets/colony.css

  if [[ ! -z $3 ]]; then
    _stylesheets_path=$3
  fi

  lsd-mod.log.echo "out-file: ${_out_filepath}"
  lsd-mod.log.echo "in-file: ${_in_asciidoc_filepath}"

  # asciidoctor --trace -v \
  asciidoctor \
    -d book \
    -b html5 \
    -a stylesheet=${_stylesheets_path} \
    -a linkcss! \
    -a icons=font \
    -a source-highlighter=highlightjs \
    -a toc \
    -a toc2 \
    -a toclevels=3 \
    -a toc=right \
    -a idprefix! \
    -a idseparator=- \
    -a sectanchors \
    -a data-uri \
    -a allow-uri-read \
    --out-file ${_out_filepath} \
    ${_in_asciidoc_filepath}

  # yelp ${SPEC_ASCIIDOC}.xml
  # lsd-mod.log.echo "chromium-browser ${WWW_HOST}/$(echo ${_out_filepath}| rev | cut -d'/' -f1| rev)"
}


function lsd-mod.docs.asciidoc.convert_adoc() {
  local spec_filepath=$1
  local out_dir=$2
  local _type=$3

  if [[ -z ${spec_filepath} ]] && [[ -f ${spec_filepath} ]]; then
    lsd-mod.log.echo "Invalid spec_filepath: ${spec_filepath}"
    return
  fi

  if [[ -z ${out_dir} ]]; then
    out_dir=${spec_filepath}
  fi

  if [[ -z ${spec_filepath} ]] && [[ -f ${spec_filepath} ]]; then
    lsd-mod.log.echo "Invalid spec_filepath: ${spec_filepath}"
    return
  fi

  local out_dir_type=${out_dir}/${_type}

  local _spec_name=$(basename ${spec_filepath})
  _spec_name="${_spec_name%.*}"

  local _spec_basepath=$(dirname ${spec_filepath})/${_spec_name}
  lsd-mod.log.echo "_spec_name: ${_spec_name}"
  lsd-mod.log.echo "_spec_basepath: ${_spec_basepath}"

  lsd-mod.log.echo "out_dir_type: ${out_dir_type}"
  lsd-mod.log.echo "spec_filepath: ${spec_filepath}"

  [ -d ${_spec_basepath} ] && declare -a _ARRAY=($(find ${_spec_basepath}/* -iname "*.adoc" -type f))

  if [ ${#_ARRAY[@]} -gt 0 ]; then
    [ ! -d ${out_dir_type} ] && mkdir -p ${out_dir_type} && lsd-mod.log.echo "Created: ${out_dir_type}"

    if [[ "${_type}" = "html" ]]; then
      ## create hyperlink to index.html
      [ -f "${_spec_basepath}/README.html" ] && [ ! -L "${out_dir_type}/index.html" ] && ln -s README.html "${out_dir_type}/index.html"
      lsd-mod.log.echo "Link to index.html: ${out_dir_type}/index.html"
      ## lsd-mod.log.echo "chromium-browser ${WWW_HOST}/$(echo ${_out_filepath}| rev | cut -d'/' -f1| rev)"
    fi
    lsd-mod.docs.asciidoc._exec_create "${_type}" "${out_dir_type}" "${_ARRAY[@]}"
  fi

  ## For complete file
  [ -f ${spec_filepath} ] && declare -a _ARRAY=(${spec_filepath}) && out_dir=$(dirname ${spec_filepath})
  lsd-mod.docs.asciidoc._exec_create "${_type}" "${out_dir_type}" "${_ARRAY[@]}"

}

function lsd-mod.docs.asciidoc._exec_create() {
  local _type=$1
  local out_dir_type=$2
  _ARRAY=$3

  lsd-mod.log.echo "Total files: ${#_ARRAY[@]}"
  lsd-mod.log.echo "File: ${_ARRAY[@]}"

  local filepath
  local fname
  local out_filepath
  for filepath in "${_ARRAY[@]}"; do
    lsd-mod.log.echo "lsd-mod.docs.asciidoc._exec_create filepath: ${filepath}"

    if [[ ! -f ${filepath} ]]; then
      lsd-mod.log.echo "File does not exists: ${filepath}"
    fi
    ## fname=$(echo ${filepath} | rev | cut -d'/' -f1 | rev | sed "s/\.adoc/\.${_type}/g")
    fname=$(basename ${filepath} | sed "s/\.adoc/\.${_type}/g")
    out_filepath=${out_dir_type}/${fname}
    if [[ "${_type}" = "html" ]]; then
      lsd-mod.log.echo "html: ${out_filepath}"
      lsd-mod.docs.asciidoc.create_html ${out_filepath} ${filepath}
    elif [[ "${_type}" = "pdf" ]]; then
      lsd-mod.log.echo "pdf: ${out_filepath}"
      lsd-mod.docs.asciidoc.create_pdf ${out_filepath} ${filepath}
    fi
  done
}


function lsd-mod.docs.asciidoc.md_to_adoc() {
  local filepath=$1
  if [[ -z ${filepath} ]]; then
    return
  fi
  local out_filepath=$2
  if [[ -z ${out_filepath} ]]; then
    out_filepath=${filepath}
  fi
  lsd-mod.log.echo ${filepath}
  lsd-mod.log.echo ${out_filepath}

  kramdoc --format=GFM \
    --output=${out_filepath}.adoc \
    --wrap=ventilate \
    ${filepath}
}


function lsd-mod.docs.asciidoc.convert_md_to_adoc() {
  local _dir=$1
  local out_basepath=$2
  if [[ -z ${_dir} ]]; then
    return
  fi

  if [[ -z ${out_basepath} ]]; then
    out_basepath=${_dir}
  fi

  lsd-mod.log.echo "out_basepath: ${out_basepath}"
  [ ! -d ${out_basepath} ] && mkdir -p ${out_basepath}

  # [ -d ${_dir} ] && declare -a _ARRAY=($(ls -d -1 ${_dir}/*.md))
  [ -d ${_dir} ] && declare -a _ARRAY=($(find ${_dir}/* -iname "*.md" -type f))

  lsd-mod.log.echo "Total files: ${#_ARRAY[@]}"

  local filepath
  local fname
  local out_filepath
  for filepath in "${_ARRAY[@]}"; do
    # lsd-mod.log.echo ${filepath}
    fname=$(echo ${filepath} | rev | cut -d'/' -f1 | rev)
    # lsd-mod.log.echo ${fname}
    out_filepath=${out_basepath}/${fname}
    # lsd-mod.log.echo ${out_filepath}
    lsd-mod.docs.asciidoc.md_to_adoc ${filepath} ${out_filepath}
  done
}


function lsd-mod.docs.asciidoc.build() {
  # lsd-mod.docs.asciidoc.build $1 $2
  local IN_SPEC_FILEPATH

  if [[ ! -z $1 ]]; then
    IN_SPEC_FILEPATH=$1
  else
    lsd-mod.log.echo "IN_SPEC_FILEPATH is mandatory"
    exit 0
  fi

  local OUT_BASEPATH=$(dirname ${IN_SPEC_FILEPATH})
  if [[ ! -z $2 ]]; then
    OUT_BASEPATH=$2
  fi

  lsd-mod.log.echo "IN_SPEC_FILEPATH: ${IN_SPEC_FILEPATH}"
  lsd-mod.log.echo "OUT_BASEPATH: ${OUT_BASEPATH}"

  mkdir -p ${OUT_BASEPATH}

  ## create html docs
  lsd-mod.docs.asciidoc.convert_adoc ${IN_SPEC_FILEPATH} ${OUT_BASEPATH} "html"

  ## create pdf docs
  lsd-mod.docs.asciidoc.convert_adoc ${IN_SPEC_FILEPATH} ${OUT_BASEPATH} "pdf"
}
