#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Docker Utility Functions
#
## References:
##  - https://docs.docker.com/network/host/
##  - https://github.com/facebookresearch/detectron2/tree/master/docker
#
# cd docker/
# # Build:
# docker build --build-arg USER_ID=$UID -t detectron2:v0 .
# # Run:
# docker run --gpus all -it \
#   --shm-size=8gb --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#   --name=detectron2 detectron2:v0

# # Grant docker access to host X server to show images
# xhost +local:`docker inspect --format='{{ .Config.Hostname }}' detectron2`
###----------------------------------------------------------


function lsd-mod.docker.get__vars() {
  lsd-mod.log.echo "DOCKER_CMD: ${bgre}${DOCKER_CMD}${nocolor}"
  lsd-mod.log.echo "DOCKER_COMPOSE_CMD: ${bgre}${DOCKER_COMPOSE_CMD}${nocolor}"
  lsd-mod.log.echo "DOCKER_VERSION: ${bgre}${DOCKER_VERSION}${nocolor}"
  lsd-mod.log.echo "DOCKER_REPO_URL: ${bgre}${DOCKER_REPO_URL}${nocolor}"
  lsd-mod.log.echo "DOCKER_KEY_URL: ${bgre}${DOCKER_KEY_URL}${nocolor}"
  lsd-mod.log.echo "DOCKER_REPO_KEY: ${bgre}${DOCKER_REPO_KEY}${nocolor}"
  lsd-mod.log.echo "DOCKER_COMPOSE_VER: ${bgre}${DOCKER_COMPOSE_VER}${nocolor}"
  lsd-mod.log.echo "DOCKER_COMPOSE_URL: ${bgre}${DOCKER_COMPOSE_URL}${nocolor}"
}


function lsd-mod.docker.get__os_vers_avail() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  declare -a cuda_linux_distributions=(`echo $(basename -a ${LSCRIPTS}/ubuntu*)`)
  local distribution
  # (>&2 echo -e "Total cuda_linux_distributions: ${#cuda_linux_distributions[@]}\n cuda_linux_distributions: ${cuda_linux_distributions[@]}")
  # (for distribution in "${cuda_linux_distributions[@]}"; do (>&2 echo -e "distributions => ${distribution}"); done)
  echo "${cuda_linux_distributions[@]}"
}


function lsd-mod.docker.local_volumes() {
  ###----------------------------------------------------------
  ## NOTE:
  ##  - Bind mounting the Docker daemon socket gives a lot of power to a container
  ##  as it can control the daemon. It must be used with caution, and only with containers we can trust.
  ###----------------------------------------------------------
  local volumes="${DOCKER_VOLUMES} "
  volumes="${volumes} -v ${HUSER_HOME}/.cache:${HUSER_HOME}/.cache"
  volumes="${volumes} -v /dev:/dev \
    -v /media:/media \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/src:/usr/src \
    -v /lib/modules:/lib/modules"

  ## https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
  ## This looks like Docker-in-Docker, feels like Docker-in-Docker, but it’s not Docker-in-Docker:
  volumes="${volumes} -v /var/run/docker.sock:/var/run/docker.sock "
  echo "${volumes}"
}

function lsd-mod.docker.port_maps() {
  local docker_ports="${DOCKER_PORTS} "
  echo "${docker_ports}"
}


function lsd-mod.docker.envvars() {
  local envvars="${DOCKER_ENVVARS} "
  envvars="${envvars} -e DOCKER_IMG=${DOCKER_IMG} "
  envvars="${envvars} -e DISPLAY=${DDISPLAY} "
  envvars="${envvars} -e HOST_PERMS=$(id -u):$(id -g) "
  envvars="${envvars} -e HUSER=${HUSER} "
  envvars="${envvars} -e HUSER_ID=${HUSER_ID} "
  envvars="${envvars} -e HUSER_GRP=${HUSER_GRP} "
  envvars="${envvars} -e HUSER_GRP_ID=${HUSER_GRP_ID} "
  envvars="${envvars} -e DUSER=${DUSER} "
  envvars="${envvars} -e DUSER_ID=${DUSER_ID} "
  envvars="${envvars} -e DUSER_GRP=${DUSER_GRP} "
  envvars="${envvars} -e DUSER_GRP_ID=${DUSER_GRP_ID} "
  envvars="${envvars} -e DUSER_HOME=${DUSER_HOME} "
  envvars="${envvars} -e PYVENV_PATH=${PYVENV_PATH} "
  envvars="${envvars} -e PYVENV_NAME=${PYVENV_NAME} "
  echo "${envvars}"
}


function lsd-mod.docker.restart_policy() {
  local restart=""
  restart="--restart always"
  echo "${restart}"
}


function lsd-mod.docker.enable_nvidia_gpu() {
  local gpus=""
  gpus="--gpus all"
  echo "${gpus}"
}


function lsd-mod.docker.container.exec() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

  [[ "$#" -lt "1" ]] && lsd-mod.log.fail "Invalid number of paramerters: required [--name] given $#"
  [[ -n "${args['name']+1}" ]] || lsd-mod.log.fail "Required params: --name=<containerName>"

  local DOCKER_CONTAINER_NAME=${args['name']}

  xhost +local:root 1>/dev/null 2>&1
  docker container start ${DOCKER_CONTAINER_NAME} &>/dev/null && docker exec \
      -u $(id -u):$(id -g) \
      -it ${DOCKER_CONTAINER_NAME} \
      /bin/bash
  xhost -local:root 1>/dev/null 2>&1
}


function lsd-mod.docker.image.build() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

  lsd-mod.log.debug "Total args: $# with args value: ${args[@]}"

  [[ "$#" -ne "3" ]] && \
    lsd-mod.log.info "\nUsage: --tag=<tag> --dockerfile=<dockerfile> --context=<context_dir>" && \
    lsd-mod.log.fail "Invalid inputs!"

  local key
  for key in 'tag' 'dockerfile' 'context'; do
    lsd-mod.log.debug "verifying key: ${key}"
    [[ -n "${args[${key}]+1}" ]] || lsd-mod.log.fail "Key does not exists: ${key}"
  done

  lsd-mod.log.debug "\n --tag=${args['tag']}, --dockerfile=${args['dockerfile']}, --context=${args['context']}"

  ## Fail on first error.
  set -e
  [[ -f ${args['dockerfile']} ]] && {
    docker build -t "${args['tag']}" -f "${args['dockerfile']}" "${args['context']}" && \
      lsd-mod.log.info "Built new image with ${tag}" || lsd-mod.log.fail "built docker image failed"
  } || lsd-mod.log.fail "File does not exists: ${args['dockerfile']}"
}


function lsd-mod.docker.adduser_to_sudoer() {
  ## This assumes user already exists and `apt install sudo` is already installed
  if [ "${HUSER}" != "root" ]; then

    local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
    source ${LSCRIPTS}/argparse.sh "$@"

    [[ "$#" -lt "1" ]] && lsd-mod.log.fail "Invalid number of paramerters: required [--name] given $#"
    [[ -n "${args['name']+1}" ]] || lsd-mod.log.fail "Required params: --name=<containerName>"

    local DOCKER_CONTAINER_NAME=${args['name']}

    ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c  "adduser ${DUSER} sudo && \
      /bin/echo \"user ALL=(root) NOPASSWD:ALL\" > /etc/sudoers.d/user && \
      /bin/echo \"%sudo ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/user
    "
  fi
}


function lsd-mod.docker.userfix() {
  ## WARNING: This function is not re-entrant, and multiple entries in bashrc will be created
  ## Todo; make it re-entrant function

  if [ "${HUSER}" != "root" ]; then

    local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
    source ${LSCRIPTS}/argparse.sh "$@"

    [[ "$#" -lt "1" ]] && lsd-mod.log.fail "Invalid number of paramerters: required [--name] given $#"
    [[ -n "${args['name']+1}" ]] || lsd-mod.log.fail "Required params: --name=<containerName>"

    local DOCKER_CONTAINER_NAME=${args['name']}

    ###----------------------------------------------------------
    ## docker add user
    ###----------------------------------------------------------

    ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "export DEBIAN_FRONTEND=noninteractive && \
      sudo addgroup --gid ${HUSER_GRP_ID} ${HUSER_GRP} && \
      sudo useradd -ms /bin/bash ${DUSER} --uid ${DUSER_ID} --gid ${DUSER_GRP_ID} && \
      sudo /bin/echo ${DUSER}:${DUSER} | chpasswd
    "

    ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "/bin/cp -r /etc/skel/. /home/${DUSER} && \
      chown ${DUSER}:${DUSER_GRP} /home/${DUSER} && \
      /bin/ls -ad /home/${DUSER}/.??* | xargs chown -R ${DUSER}:${DUSER_GRP}
    "



    ###----------------------------------------------------------
    ## docker_bashrc_patch_1: alias and PS1 prompt
    ###----------------------------------------------------------

    ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c  "echo ' \

export PATH=${PATH}:/usr/local/bin
export PS1=\"\[\e[0;31m\]\u\[\033[00m\]@\h:\[\033[01;32m\]\t\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$\"
alias lt=\"ls -lrth\"
alias l=\"ls -lrth\"
ulimit -c unlimited

' >> \"/home/${HUSER}/.bashrc\"
"

    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chown -R ${HUSER}:${HUSER_GRP} ${WORK_BASE_PATH}"
    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "[ -d ${WORK_BASE_PATH} ] && chown -R ${HUSER}:${HUSER_GRP} ${WORK_BASE_PATH} && \
    #   chmod a+w ${WORK_BASE_PATH}"
    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "[ -d ${OTHR_BASE_PATHS} ] && chown -R ${HUSER}:${HUSER_GRP} ${OTHR_BASE_PATHS} && \
    #   chmod a+w ${OTHR_BASE_PATHS}"

    # ## testing
    # declare -a DATA_DIRS
    # DATA_DIRS=("${WORK_BASE_PATH}/test1"
    #            "${WORK_BASE_PATH}/test2")
    
    # for DATA_DIR in "${DATA_DIRS[@]}"; do
    #   ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} bash -c \
    #       "mkdir -p '${DATA_DIR}'; chown -R ${DOCKER_USER}:${DOCKER_GRP} '${DATA_DIR}'"
    #       "mkdir -p '${DATA_DIR}'; chmod a+rw -R '${DATA_DIR}'"
    # done
  fi
}

# function lsd-mod.docker.bashrc_patch_2() {
#   echo '
#   source /usr/local/bin/virtualenvwrapper.sh
#   export WORKON_HOME=${PYVENV_PATH}
#   ' >> "/home/${HUSER}/.bashrc"
# }


function lsd-mod.docker.adduser() {
  ###----------------------------------------------------------
  ## Docker adduser to container
  ## NOTE: this is deprecated and only for reference, though it may work
  #
  ## References
  ## https://www.computerhope.com/unix/adduser.htm
  ## https://www.cyberciti.biz/faq/linux-change-user-group-uid-gid-for-all-owned-files/
  ## https://wiki.bash-hackers.org/scripting/debuggingtips
  ###----------------------------------------------------------

  addgroup --gid "${HUSER_GRP_ID}" "${HUSER_GRP}"
  adduser --disabled-password --force-badname --gecos '' "${HUSER}" --uid "${HUSER_ID}" --gid "${HUSER_GRP_ID}" 2>/dev/null
  usermod -aG sudo "${HUSER}"
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

  # addgroup --gid "${HUSER_GRP_ID}" "${HUSER_GRP}"
  # useradd -ms /bin/bash ${HUSER} --uid ${HUSER_ID} --gid ${HUSER_ID}
  # echo "${HUSER}:${HUSER}" | chpasswd
  # adduser ${HUSER} sudo
  # echo "user ALL=(root) NOPASSWD:ALL" >> /etc/sudoers.d/user
  # echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/user

  cp -r /etc/skel/. /home/${HUSER}
  # Set user files ownership to current user, such as .bashrc, .profile, etc.
  chown ${HUSER}:${HUSER_GRP} /home/${HUSER}
  ls -ad /home/${HUSER}/.??* | xargs chown -R ${HUSER}:${HUSER_GRP}
}


function lsd-mod.docker.container.list {
  # declare -a cids=$(echo $(docker container ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}"))
  # echo "${cids[@]}"
  docker container ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"
}


function lsd-mod.docker.container.list-ids {
  ## References:
  ## https://www.unix.com/unix-for-beginners-questions-and-answers/282491-how-convert-any-shell-command-output-json-format.html
  ## https://stackoverflow.com/questions/38860529/create-json-using-jq-from-pipe-separated-keys-and-values-in-bash/38862221#38862221
  ## https://stackoverflow.com/questions/44656515/how-to-remove-double-quotes-in-jq-output-for-parsing-json-files-in-bash

  local DOCKER_IMAGE_NAME=$1
  [[ -z ${DOCKER_IMAGE_NAME} ]] && DOCKER_IMAGE_NAME="hello-world"

  declare -a cids=$(echo $(docker container ps -a --format "table {{.ID}},{{.Image}},{{.Names}}" | jq -nR '[ 
      ( input | split(",") ) as $keys | 
      ( inputs | split(",") ) as $vals | 
      [ [$keys, $vals] | 
      transpose[] | 
      {key:.[0],value:.[1]} ] | 
      from_entries ]') | jq -c '.[] | select( .IMAGE | contains("'${DOCKER_IMAGE_NAME}'"))' | jq -rc '.["CONTAINER ID"]')

  echo "${cids[@]}"
}


function lsd-mod.docker.container.list-ids-all {
  declare -a cids=$(echo $(docker container ps -a --format "table {{.ID}},{{.Image}},{{.Names}}" | jq -nR '[ 
      ( input | split(",") ) as $keys | 
      ( inputs | split(",") ) as $vals | 
      [ [$keys, $vals] | 
      transpose[] | 
      {key:.[0],value:.[1]} ] | 
      from_entries ]') | jq -c '.[]' | jq -rc '.["CONTAINER ID"]')

  echo "${cids[@]}"
}


function lsd-mod.docker.container.exec-byname {
  : ${1?
    "Usage:
    bash $0 <DOCKER_CONTAINER_NAME>"
  }

  local DOCKER_CONTAINER_NAME=$1
  [[ ! -z $(docker container ps -a --format "{{.Names}}" | grep ${DOCKER_CONTAINER_NAME}) ]] && {
    docker exec -u $(id -u):$(id -g) -it ${DOCKER_CONTAINER_NAME} /bin/bash && xhost -local:root 1>/dev/null 2>&1
    [[ $? -ne 0 ]] && lsd-mod.log.error "Unable execute container with name: ${DOCKER_CONTAINER_NAME}" || lsd-mod.log.ok "Bye from ${DOCKER_CONTAINER_NAME}!"
  } || lsd-mod.log.error "Container name not found or not started: ${DOCKER_CONTAINER_NAME}"
}


function lsd-mod.docker.container.status {
  # https://gist.github.com/paulosalgado/91bd74c284e262a4806524b0dde126ba
  : ${1?
    "Usage:
    bash $0 <DOCKER_CONTAINER_NAME>"
  }

  local DOCKER_CONTAINER_NAME=$1
  local RUNNING=$(docker inspect --format="{{.State.Running}}" ${DOCKER_CONTAINER_NAME} 2> /dev/null)
  local RESTARTING=$(docker inspect --format="{{.State.Restarting}}" ${DOCKER_CONTAINER_NAME})
  local STARTED=$(docker inspect --format="{{.State.StartedAt}}" ${DOCKER_CONTAINER_NAME})
  local NETWORK=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" ${DOCKER_CONTAINER_NAME})

  lsd-mod.log.echo "RUNNING: \e[1;32m${RUNNING}"
  lsd-mod.log.echo "RESTARTING: \e[1;32m${RESTARTING}"
  lsd-mod.log.echo "STARTED: \e[1;32m${STARTED}"
  lsd-mod.log.echo "NETWORK: \e[1;32m${NETWORK}"
}


function lsd-mod.docker.container.stop-all() {
  docker stop $(docker ps -a -q) && lsd-mod.log.info "All containers stopped!"
  docker ps -a
}


function lsd-mod.docker.container.delete-all() {
  local _que="Are you sure you want to delete all containers"
  local _msg="Skipping deleting all containers!"
  lsd-mod.fio.yesno_no "${_que}" && {
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
    lsd-mod.log.info "All containers are deleted!"
    docker ps -a
  } || lsd-mod.log.echo "${_msg}"
}


function lsd-mod.docker.container.delete-byimage {
  local DOCKER_IMAGE_NAME=$1
  [[ -z ${DOCKER_IMAGE_NAME} ]] && DOCKER_IMAGE_NAME="hello-world"

  local _que="Are you sure you want to delete all containers of image: ${DOCKER_IMAGE_NAME}"
  local _msg="Skipping deleting all containers  of image: ${DOCKER_IMAGE_NAME}!"
  lsd-mod.fio.yesno_no "${_que}" && {
    declare -a cids=$(lsd-mod.docker.container.list-ids ${DOCKER_IMAGE_NAME})
    echo "cids:${cids[@]}"
    ## Todo:: if array is empty condition
    docker stop ${cids[@]} && docker rm ${cids[@]}
    lsd-mod.log.info "All containers with image: ${DOCKER_IMAGE_NAME} cids are deleted!"
    docker ps -a
  } || lsd-mod.log.echo "${_msg}"
}


function lsd-mod.docker.container.test() {
  local DOCKER_BLD_CONTAINER_IMG
  [[ ! -z "$1" ]] && DOCKER_BLD_CONTAINER_IMG="$1" || lsd-mod.log.fail "Empty DOCKER_BLD_CONTAINER_IMG: ${DOCKER_BLD_CONTAINER_IMG}"
  lsd-mod.log.info "Creating self-destructing test container using image: ${DOCKER_BLD_CONTAINER_IMG}"
  ${DOCKER_CMD} run --name $(uuid) --user $(id -u):$(id -u) --gpus all --rm -it "${DOCKER_BLD_CONTAINER_IMG}" bash
}
