#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Python utilities functions
###----------------------------------------------------------
## References
## * https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html#why-use-venv-based-virtual-environments
## * https://stackoverflow.com/questions/36539623/how-do-i-find-the-name-of-the-conda-environment-in-which-my-code-is-running
###----------------------------------------------------------


function lsd-mod.python.virtualenvwrapper.getconfig_file() {
  local __PY_VIRTUALENVWRAPPER
  lsd-mod.log.debug "/usr/local/bin/${_LSD__PY_VIRTUALENVWRAPPER}"
  {
    ls -1 "/usr/local/bin/${_LSD__PY_VIRTUALENVWRAPPER}" &>/dev/null && __PY_VIRTUALENVWRAPPER="/usr/local/bin/${_LSD__PY_VIRTUALENVWRAPPER}"
  } || {
    ls -1 "${HOME}/.local/bin/${_LSD__PY_VIRTUALENVWRAPPER}" &>/dev/null && __PY_VIRTUALENVWRAPPER="${HOME}/.local/bin/${_LSD__PY_VIRTUALENVWRAPPER}"
  }
  lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"

  echo ${__PY_VIRTUALENVWRAPPER}
}


function lsd-mod.python.virtualenvwrapper.config() {
  ## Todo: not used and to be seen the utility of this function
  [[ -f ${_LSD__BASHRC_FILE} ]] || lsd-mod.log.fail "File does not exits,_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"

  local LINE
  LINE="export WORKON_HOME=${_LSD__PYVENV_PATH}"
  lsd-mod.fio.inject_in_file --file="${_LSD__BASHRC_FILE}" --line="${LINE}"

  __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
  lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
  LINE="source ${__PY_VIRTUALENVWRAPPER}"
  lsd-mod.fio.inject_in_file --file="${_LSD__BASHRC_FILE}" --line="${LINE}"

  source ${_LSD__BASHRC_FILE}
}


function lsd-mod.python.list() {
  ls -1 /usr/bin/python[1-9].[1-9] && ls -1 /usr/local/bin/python[1-9].[1-9]
}


function lsd-mod.python.find_vers() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

  local version
  [[ -n "${args['version']+1}" ]] && version=${args['version']}

  [[ -z ${version} ]] && {
    local _versions=$(curl -s https://www.python.org/ftp/python/  | sed 's/^.*">//;s/<.*//' | sed 's/\///' | grep ^[1-9].[1-9])
    echo "${_versions}"
  } || {
    lsd-mod.log.echo "searching for version: ${version}"
    local _match=$(curl -s https://www.python.org/ftp/python/  | sed 's/^.*">//;s/<.*//' | sed 's/\///' | grep ^[1-9].[1-9] | grep ${version})
    [[ -z ${_match} ]] && echo "-1" || echo "${_match}"
  }
}


function lsd-mod.python.path() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local scriptname=$(basename ${BASH_SOURCE[0]})

  source ${LSCRIPTS}/argparse.sh "$@"

  local py=python3
  local pyPath

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.echo "py: ${py}"
  lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null
  echo "${pyPath}"
}


function lsd-mod.python.venv.name() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local scriptname=$(basename ${BASH_SOURCE[0]})

  source ${LSCRIPTS}/argparse.sh "$@"

  local py=python3
  local pyPath

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  # lsd-mod.log.echo "py: ${py}"
  # lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null && {
    ## this is the fullpath of the input python executable you want to use
    local __pyVer=$(${py} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
    local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  } 2>/dev/null
  echo "${py_env_name}"
}


function lsd-mod.python.venv.list() {
  ###----------------------------------------------------------
  ## List all the python vistual environment.
  ###----------------------------------------------------------
  [[ -d ${_LSD__PYVENV_PATH} ]] && {
    export WORKON_HOME=${_LSD__PYVENV_PATH}
    __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
    lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
    source "${__PY_VIRTUALENVWRAPPER}"

    local pyenv
    declare -a pyenvs=($(lsvirtualenv | tr -d [=]))

    lsd-mod.log.echo "${gre}Listing all of the python virtual environments:${nocolor}"
    lsd-mod.log.echo "${biyel}Total: ${#pyenvs[@]}${nocolor}"
    for pyenv in ${pyenvs[@]}; do echo -e "${gre}${pyenv}${nocolor}"; done 
  } || lsd-mod.log.error "_LSD__PYVENV_PATH does not exists: ${_LSD__PYVENV_PATH}"
}


function lsd-mod.python.virtualenvwrapper.test() {
  lsd-mod.log.warn "Testing Usage and Installation: "

  local py=python3
  local pyPath
  local __PY_VIRTUALENVWRAPPER

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.echo "py: ${py}"
  lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null

  # pyPath=$(lsd-mod.python.path)
  lsd-mod.log.debug "Creating...pyPath: ${pyPath}"

  local __pyVer=$(${pyPath} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  local py_env_name="test_py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  lsd-mod.log.debug "Creating...py_env_name: ${py_env_name}"

  lsd-mod.log.debug "_LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
  [[ -d ${_LSD__PYVENV_PATH} ]] || {
    lsd-mod.log.info "_LSD__PYVENV_PATH Does not exists: ${_LSD__PYVENV_PATH}"

    local _que="Do you want to Create _LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
    local _msg="Skipping _LSD__PYVENV_PATH creation!"
    lsd-mod.fio.yesno_yes "${_que}" && {
      lsd-mod.log.echo "Creating _LSD__PYVENV_PATH..."
      mkdir -p ${_LSD__PYVENV_PATH}
    } || lsd-mod.log.echo "${_msg}"
  }

  [[ -d ${_LSD__PYVENV_PATH} ]] && {
    export WORKON_HOME=${_LSD__PYVENV_PATH}
    __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
    lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
    source "${__PY_VIRTUALENVWRAPPER}"

    lsd-mod.log.info "Creating py_env_name: ${py_env_name} folder inside: ${_LSD__PYVENV_PATH}"
    ## creates the my_project folder inside ${_LSD__PYVENV_PATH}
    mkvirtualenv -p $(which ${pyPath}) ${py_env_name} &>/dev/null && {
      lsd-mod.log.info "lsvirtualenv: ## List all of the environments."
      lsvirtualenv
    
      lsd-mod.log.info "cdvirtualenv: ## Navigate into the directory of the currently activated virtual environment, so you can browse its site-packages."
      cdvirtualenv
    
      lsd-mod.log.info "cdsitepackages: ## Like the above, but directly into site-packages directory."
      cdsitepackages
    
      lsd-mod.log.info "lssitepackages: ## Shows contents of site-packages directory."
      lssitepackages
      #
      lsd-mod.log.info "workon <py_env_name>: ## workon also deactivates whatever environment you are currently in, so you can quickly switch between environments."
      lsd-mod.log.info "workon ${py_env_name}"
      workon ${py_env_name}
      ##
      lsd-mod.log.info "deactivate: ## Deactivates whatever environment you are currently in."
      deactivate
      #
      ## Rename
      ## https://stackoverflow.com/questions/9540040/rename-an-environment-with-virtualenvwrapper
      lsd-mod.log.info "cpvirtualenv <py_env_name> new_<py_env_name>: ## copy the virtualenv environment. Used as workaround for renaming."
      cpvirtualenv ${py_env_name} new_${py_env_name}
      deactivate
      rmvirtualenv ${py_env_name}
    
      ## Remove
      lsd-mod.log.info "rmvirtualenv new_<py_env_name>: ## Removes the virtualenv environment."
      rmvirtualenv new_${py_env_name}
    } || lsd-mod.log.error "python virtualenvwrapper is not installed / configured properly. check: WORKON_HOME: ${WORKON_HOME}"
  } || lsd-mod.log.error "_LSD__PYVENV_PATH does not exists: ${_LSD__PYVENV_PATH}"
}


function lsd-mod.python.conda.create() {
  local __pyVer
  local py_env_name

  [[ -n "${args['version']+1}" ]] && __pyVer=${args['version']}
  lsd-mod.log.echo "args:__pyVer: ${__pyVer}"

  [[ -n "${args['name']+1}" ]] && py_env_name=${args['name']}
  lsd-mod.log.echo "args:py_env_name: ${py_env_name}"

  ## initialize __pyVer from default system python version if version is not mentioned
  ## alternatively; could have used two different commands; but then I did not like that option as it is not consistent
  [[ ! -z ${__pyVer} ]] || {
    local py=python3
    local pyPath

    type ${pyPath} &>/dev/null && pyPath=$(which ${py})

    [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
    type ${pyPath} &>/dev/null && py=${pyPath}

    pyPath=$(which ${py})

    lsd-mod.log.echo "py: ${py}"
    lsd-mod.log.echo "pyPath: ${pyPath}"

    type ${pyPath} &>/dev/null

    # pyPath=$(lsd-mod.python.path)
    lsd-mod.log.debug "pyPath: ${pyPath}"

    __pyVer=$(${pyPath} -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
  }

  lsd-mod.log.echo "__pyVer: ${__pyVer}"

  [[ ! -z ${py_env_name} ]] || {
    py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  }

  lsd-mod.log.echo "py_env_name: ${py_env_name}"

  local _cmd='conda'
  type ${_cmd} &>/dev/null && {
    ## list conda environments
    # conda info --env
    # conda env list
    # cat ~/.conda/environments.txt

    conda env list | grep ${py_env_name} &>/dev/null
    [[ $? -eq 0 ]] && {
      lsd-mod.log.warn "Already exists: ${py_env_name} folder inside: ${_LSD__PYCONDA_PATH}"
    } || {
      lsd-mod.log.warn "Creating: ${py_env_name} folder inside: ${_LSD__PYCONDA_PATH}"

      conda create --name ${py_env_name} -y python=${__pyVer}
    }
  } 1>&2 || {
    lsd-mod.log.error "${_cmd} not installed or corrupted!"
    # return -1
  }
}


function lsd-mod.python.virtualenvwrapper.create() {
  local py=python3
  local pyPath
  local __PY_VIRTUALENVWRAPPER

  type ${pyPath} &>/dev/null && pyPath=$(which ${py})

  [[ -n "${args['path']+1}" ]] && pyPath=${args['path']}
  type ${pyPath} &>/dev/null && py=${pyPath}

  pyPath=$(which ${py})

  lsd-mod.log.echo "py: ${py}"
  lsd-mod.log.echo "pyPath: ${pyPath}"

  type ${pyPath} &>/dev/null

  # pyPath=$(lsd-mod.python.path)
  lsd-mod.log.debug "pyPath: ${pyPath}"

  local __pyVer=$(${pyPath} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')
  # local _timestamp=$(lsd-mod.date.get__timestamp)
  # local _timestamp="$(date -d now +'%d%m%y_%H%M%S')"
  local py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"
  lsd-mod.log.debug "Creating...py_env_name: ${py_env_name}"

  lsd-mod.log.debug "_LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"
  [[ -d ${_LSD__PYVENV_PATH} ]] || lsd-mod.log.fail "Does not exists _LSD__PYVENV_PATH: ${_LSD__PYVENV_PATH}"

  export WORKON_HOME=${_LSD__PYVENV_PATH}
  __PY_VIRTUALENVWRAPPER=$(lsd-mod.python.virtualenvwrapper.getconfig_file)
  lsd-mod.log.debug "__PY_VIRTUALENVWRAPPER: ${__PY_VIRTUALENVWRAPPER}"
  source "${__PY_VIRTUALENVWRAPPER}"

  local _cmd='lsvirtualenv'
  type ${_cmd} &>/dev/null && {
    lsvirtualenv | grep ${py_env_name}
    [[ $? -eq 0 ]] || {
      lsd-mod.log.warn "Creating: ${py_env_name} folder inside: ${_LSD__PYVENV_PATH}"
      mkvirtualenv -p $(which ${pyPath}) ${py_env_name} &>/dev/null && workon ${py_env_name} || lsd-mod.log.error "Internal lsd-mod.log.error in mkvirtualenv!"
    }
  } 1>&2 || {
    lsd-mod.log.error "${_cmd} not installed or corrupted!"
    # return -1
  }
}


function lsd-mod.python.libs.test-pytorch() {
  python -c 'import torch; print(torch.rand(5, 3)); print(torch.cuda.is_available())'
}


function lsd-mod.python.conda.create.hpc() {
  local __pyVer py_env_name
  local CONDA_ROOT CONDA_CMD

  # --- Step 1: Try to locate conda root generically ------------------------
  CONDA_CMD=$(command -v conda 2>/dev/null)

  # Case 1: Conda already in PATH
  if [[ -n "${CONDA_CMD}" ]]; then
    CONDA_ROOT=$(dirname "$(dirname "${CONDA_CMD}")")
  # Case 2: Common cluster shared Miniconda
  elif [[ -d "/nfs_home/software/miniconda" ]]; then
    CONDA_ROOT="/nfs_home/software/miniconda"
  # Case 3: Fallback (standalone-style path)
  elif [[ -d "/datahub/conda" ]]; then
    CONDA_ROOT="/datahub/conda"
  else
    lsd-mod.log.error "No valid Conda installation found in PATH or known locations!"
    return 1
  fi

  lsd-mod.log.echo "Detected Conda root: ${CONDA_ROOT}"

  # --- Step 2: Source Conda and ensure usability --------------------------
  if [[ -f "${CONDA_ROOT}/etc/profile.d/conda.sh" ]]; then
    source "${CONDA_ROOT}/etc/profile.d/conda.sh"
  else
    export PATH="${CONDA_ROOT}/bin:${PATH}"
  fi

  # --- Step 3: Force classic solver (safe everywhere) ---------------------
  conda config --set solver classic >/dev/null 2>&1

  # --- Step 4: Parse inputs ------------------------------------------------
  [[ -n "${args['version']+1}" ]] && __pyVer=${args['version']}
  [[ -n "${args['name']+1}" ]] && py_env_name=${args['name']}
  [[ -z "${__pyVer}" ]] && __pyVer=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
  [[ -z "${py_env_name}" ]] && py_env_name="py_${__pyVer}_$(date -d now +'%d%m%y_%H%M%S')"

  lsd-mod.log.echo "__pyVer: ${__pyVer}"
  lsd-mod.log.echo "py_env_name: ${py_env_name}"

  # --- Step 5: Determine where to create environments ---------------------
  local TARGET_ROOT="${HOME}/datahub/conda/envs"
  mkdir -p "${TARGET_ROOT}"
  local ENV_PATH="${TARGET_ROOT}/${py_env_name}"

  lsd-mod.log.echo "Environment target: ${ENV_PATH}"

  # --- Step 6: Create environment safely ----------------------------------
  conda env list | grep -q "${py_env_name}" && {
    lsd-mod.log.warn "Already exists: ${py_env_name}"
  } || {
    lsd-mod.log.warn "Creating: ${py_env_name}"
    conda create -p "${ENV_PATH}" -y python="${__pyVer}" || {
      lsd-mod.log.error "conda create failed for ${py_env_name}"
      return 1
    }
  }

  # --- Step 7: Success message --------------------------------------------
  lsd-mod.log.info "Conda environment created at: ${ENV_PATH}"
  lsd-mod.log.info "Activate with: conda activate ${ENV_PATH}"
}
