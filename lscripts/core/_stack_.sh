#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## stack utility functions
###----------------------------------------------------------


function lsd-mod.stack.get__vars() {
  lsd-mod.log.echo "BUILD_FOR_CUDA_VER=${BUILD_FOR_CUDA_VER}"
  lsd-mod.log.echo "CMAKE_VER=${CMAKE_VER}"
  lsd-mod.log.echo "CMAKE_VER=${CMAKE_VER}"
  lsd-mod.log.echo "CMAKE_REL=${CMAKE_REL}"
  lsd-mod.log.echo "PHP_VER=${PHP_VER}"
  lsd-mod.log.echo "NODEJS_VER=${NODEJS_VER}"
  lsd-mod.log.echo "NODE_NVM_VER=${NODE_NVM_VER}"
  lsd-mod.log.echo "YARN_REPO_URL=${YARN_REPO_URL}"
  lsd-mod.log.echo "YARN_KEY_URL=${YARN_KEY_URL}"
  lsd-mod.log.echo "JAVA_JDK_VER=${JAVA_JDK_VER}"
  lsd-mod.log.echo "SUITE_PARSE_VER=${SUITE_PARSE_VER}"
  lsd-mod.log.echo "CERES_SOLVER_REL=${CERES_SOLVER_REL}"
  lsd-mod.log.echo "CERES_SOLVER_REL_TAG=${CERES_SOLVER_REL_TAG}"
  lsd-mod.log.echo "PROTOBUF_REL=${PROTOBUF_REL}"
  lsd-mod.log.echo "PROJ_VER=${PROJ_VER}"
  lsd-mod.log.echo "TIFF_VER=${TIFF_VER}"
  lsd-mod.log.echo "GEOTIFF_VER=${GEOTIFF_VER}"
  lsd-mod.log.echo "LASzip_REL=${LASzip_REL}"
  lsd-mod.log.echo "LIBKML_REL=${LIBKML_REL}"
  lsd-mod.log.echo "GEOS_VER=${GEOS_VER}"
  lsd-mod.log.echo "BOOST_VER=${BOOST_VER}"
  lsd-mod.log.echo "EIGEN_REL=${EIGEN_REL}"
  lsd-mod.log.echo "MPIR_REL_TAG=${MPIR_REL_TAG}"
  lsd-mod.log.echo "LAZ_PERF_REL=${LAZ_PERF_REL}"
  lsd-mod.log.echo "LIBLAS_REL=${LIBLAS_REL}"
  lsd-mod.log.echo "LASZIP_VER=${LASZIP_VER}"
  lsd-mod.log.echo "GEOWAVE_REL_TAG=${GEOWAVE_REL_TAG}"
  lsd-mod.log.echo "GDAL_VER=${GDAL_VER}"
  lsd-mod.log.echo "PCL_REL=${PCL_REL}"
  lsd-mod.log.echo "PDAL_MARJOR_VER=${PDAL_MARJOR_VER}"
  lsd-mod.log.echo "PDAL_VER=${PDAL_VER}"
  lsd-mod.log.echo "PDAL_REL=${PDAL_REL}"
  lsd-mod.log.echo "ENTWINE_VER=${ENTWINE_VER}"
  lsd-mod.log.echo "SIMPLE_WEB_SERVER_VER=${SIMPLE_WEB_SERVER_VER}"
  lsd-mod.log.echo "VTK_VER=${VTK_VER}"
  lsd-mod.log.echo "VTK_BUILD=${VTK_BUILD}"
  lsd-mod.log.echo "VTK_RELEASE=${VTK_RELEASE}"
  lsd-mod.log.echo "OpenCV_REL=${OpenCV_REL}"
  lsd-mod.log.echo "OpenSfM_REL=${OpenSfM_REL}"
  lsd-mod.log.echo "OpenDroneMap_REL=${OpenDroneMap_REL}"
  lsd-mod.log.echo "OpenImageIO_REL=${OpenImageIO_REL}"
  lsd-mod.log.echo "OPENEXR_REL=${OPENEXR_REL}"
  lsd-mod.log.echo "ALEMBIC_REL=${ALEMBIC_REL}"
  lsd-mod.log.echo "GEOGRAM_VER=${GEOGRAM_VER}"
  lsd-mod.log.echo "MESHROOM_REL=${MESHROOM_REL}"
  lsd-mod.log.echo "CloudCompare_REL=${CloudCompare_REL}"
  lsd-mod.log.echo "HAROOPAD_VER=${HAROOPAD_VER}"
  lsd-mod.log.echo "PANDOC_VER=${PANDOC_VER}"
  lsd-mod.log.echo "FREEFILESYNC_VER=${FREEFILESYNC_VER}"
  lsd-mod.log.echo "MAGMA_VER=${MAGMA_VER}"
  lsd-mod.log.echo "ASCIIDOC_REL=${ASCIIDOC_REL}"
  lsd-mod.log.echo "SHOTCUT_REL=${SHOTCUT_REL}"
  lsd-mod.log.echo "GRAFANA_VER=${GRAFANA_VER}"
  lsd-mod.log.echo "GITLFS_VER=${GITLFS_VER}"
  lsd-mod.log.echo "ZOOKEEPER_VER=${ZOOKEEPER_VER}"
  lsd-mod.log.echo "KAFKA_REL=${KAFKA_REL}"
  lsd-mod.log.echo "KAFKA_VER=${KAFKA_VER}"
  lsd-mod.log.echo "GITLAB_INSTALLER_EE_URL=${GITLAB_INSTALLER_EE_URL}"
  lsd-mod.log.echo "GITLAB_INSTALLER_CE_URL=${GITLAB_INSTALLER_CE_URL}"
  lsd-mod.log.echo "GITLAB_INSTALLER_URL=${GITLAB_INSTALLER_URL}"
  lsd-mod.log.echo "VIRTUALBOX_REPO_URL=${VIRTUALBOX_REPO_URL}"
}


function lsd-mod.stack.list() {
  ## References:
  ## * https://unix.stackexchange.com/a/625927
  ## * https://stackoverflow.com/questions/16553089/dynamic-variable-names-in-bash
  ## * http://mywiki.wooledge.org/BashFAQ/006
  ## * https://wiki.bash-hackers.org/syntax/arrays#indirection

  # ${1:+:} return 1

  # local error_msg="Usage: bash $0 <stack-name>"
  # : ${1? "${error_msg}" }

  local _name=$1
  [[ ! -z ${_name} ]] || _name="items"
  declare -n array="_stack_install_${_name}" 2>/dev/null && {
    lsd-mod.log.echo "\n${_name} ${gre}arrayname is ${red}${!array} ${gre}with total items to be installed: ${red}${#array[@]} in the given order."
    lsd-mod.log.echo "${gre}During installation it will prompt for Yes[Y] or No[N] before continuing the installation."
    lsd-mod.log.echo "${gre}sudo access would be required for any installation.\n"
    # lsd-mod.log.info "$1:: ${array[@]}"
    # lsd-mod.log.info "$1:: ${!array[@]}"

    local item
    for item in "${!array[@]}";do
      lsd-mod.log.echo "[${item}]: ${array[${item}]}"
      # lsd-mod.log.echo "[${item}]: ${!array[${item}]}"
      # local _item_filepath="${LSCRIPTS}/stack-setup-${item}.sh"
      # # lsd-mod.log.echo "Checking for installer..." && \
      # ls -1 "${_item_filepath}" &>/dev/null && {
      #   ## create alias
      #   alias lsd-stack.${item}="source ${_item_filepath} || lsd-mod.log.error ${_item_filepath}"
      # } || lsd-mod.log.error "Installer not found: ${item}!"
    done
    lsd-mod.log.echo "\n${gre}You can get more details by executing command:\n${bred}lsd-stack.list <name_of_the_item>\n"


  } || lsd-mod.log.info "${_name} is either invalid value. Or, it's directly installable, ${red}refer: lsd-install.${_name}"
}

