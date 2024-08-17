#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker:: create container for tensorflow
###----------------------------------------------------------


function docker_main() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${SCRIPTS_DIR}/docker.config.sh $2
  source ${SCRIPTS_DIR}/docker.fn.sh

  ${DOCKER_CMD} --version

  ## change image name
  DOCKER_CONTAINER_IMG="tensorflow/tensorflow:devel-gpu-py3"
  DOCKER_CONTAINER_NAME="tf-dev-1"

  function create_container() {
      ${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null

      if [ $? == 0 ]; then
        ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null
        ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null
      fi

      ${DOCKER_CMD} start ${DOCKER_CONTAINER_NAME} 1>/dev/null

      echo $(local_volumes)
      
      # https://docs.docker.com/network/host/
      ## WARNING: Published ports are discarded when using host network mode

      ##TODO: config file throws permission error
      echo "${DOCKER_CMD} run -d -it \
        --gpus all \
        --name ${DOCKER_CONTAINER_NAME} \
        $(_docker_.envvars) \
        $(local_volumes) \
        $(restart_policy) \
        --net host \
        --add-host ${LOCAL_HOST}:127.0.0.1 \
        --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
        --hostname ${DOCKER_LOCAL_HOST} \
        --shm-size ${SHM_SIZE} \
        ${DOCKER_CONTAINER_IMG}"

      ${DOCKER_CMD} run -d -it \
        --gpus all \
        --name ${DOCKER_CONTAINER_NAME} \
        $(_docker_.envvars) \
        $(local_volumes) \
        $(restart_policy) \
        --net host \
        --add-host ${LOCAL_HOST}:127.0.0.1 \
        --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
        --hostname ${DOCKER_LOCAL_HOST} \
        --shm-size ${SHM_SIZE} \
        ${DOCKER_CONTAINER_IMG}

      ## https://unix.stackexchange.com/questions/7704/what-is-the-meaning-of-in-a-shell-script
      ## $? provide us the execution status of last execute command on prompt.
      ## Value '0' denotes that the command was executed successfuly and '1' is for not success.
      if [ $? -ne 0 ];then
          lsd-mod.log.error "Failed to start docker container \"${DOCKER_CONTAINER_NAME}\" based on image: ${DOCKER_CONTAINER_IMG}"
          # exit 1
          return
      fi

      # if [ "${HUSER}" != "root" ]; then
      #   # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.userfix.sh"
      #   # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chown -R ${HUSER}:${HUSER_GRP} ${WORK_BASE_PATH}"
      #   # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chmod a+w ${WORK_BASE_PATH}"
      #   ##

      #   # ## testing
      #   # declare -a DATA_DIRS
      #   # DATA_DIRS=("${WORK_BASE_PATH}/test1"
      #   #            "${WORK_BASE_PATH}/test2")
        
      #   # for DATA_DIR in "${DATA_DIRS[@]}"; do
      #   #   ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} bash -c \
      #   #       "mkdir -p '${DATA_DIR}'; chown -R ${DOCKER_USER}:${DOCKER_GRP} '${DATA_DIR}'"
      #   #       "mkdir -p '${DATA_DIR}'; chmod a+rw -R '${DATA_DIR}'"
      #   # done
      # fi

      # lsd-mod.log.info "MONGODB_USER:MONGODB_USER_ID:: $MONGODB_USER:$MONGODB_USER_ID"
      # lsd-mod.log.info "MONGODB_GRP:MONGODB_GRP_ID:: $MONGODB_GRP:$MONGODB_GRP_ID"

      # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.mongodb.userfix.sh"

      # ${DOCKER_CMD} exec -u ${USER} -it ${DOCKER_CONTAINER_NAME} "${WORK_BASE_PATH}/scripts/bootstrap.sh"

      echo -e "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with:\n source $(pwd)/docker.exec-aidev.sh ${DOCKER_CONTAINER_NAME}"
      echo "Enjoy!"
  }

  create_container
}

docker_main $1 $2
