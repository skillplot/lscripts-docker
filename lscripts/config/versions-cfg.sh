#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## version - version variables for the installed softwares
#
## NOTE:
## - Last one is what is used if not commented#
###----------------------------------------------------------


local __LINUX_VERSION
type lsb_release &>/dev/null && __LINUX_VERSION="$(lsb_release -sr)" || {
  __LINUX_VERSION=$(. /etc/os-release;echo ${VERSION_ID})
}
#
local CMAKE_VER="3.11"
local CMAKE_BUILD="0"
#
local CMAKE_VER="3.16"
local CMAKE_BUILD="0"
#
local CMAKE_REL="${CMAKE_VER}.${CMAKE_BUILD}"
#
##----------------------------------------------------------
## PHP version
##----------------------------------------------------------
local PHP_VER="7.0"
local PHP_VER="7.1"
local PHP_VER="7.2"
[[ "${__LINUX_VERSION}" == "18.04" ]] && PHP_VER="7.2"
[[ "${__LINUX_VERSION}" == "20.04" ]] && PHP_VER="7.4"

## for ubuntu 20.04 LTS
#local 
#
##----------------------------------------------------------
## Node JS, NVM version
##----------------------------------------------------------
## https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04
local NODEJS_VER=7
local NODEJS_VER=8
local NODEJS_VER=9
local NODEJS_VER=10
local NODEJS_VER=16
#
local NODE_NVM_VER=v0.35.3
local NODE_NVM_VER=v0.38.0
#
##----------------------------------------------------------
## Yarn
##----------------------------------------------------------
local YARN_REPO_URL="https://dl.yarnpkg.com/debian"
local YARN_KEY_URL="${YARN_REPO_URL}/pubkey.gpg"
#
##----------------------------------------------------------
## JAVA JDK version
##----------------------------------------------------------
local JAVA_JDK_VER="8"
#JAVA_JDK_VER="9"
#
##----------------------------------------------------------
## http://faculty.cse.tamu.edu/davis/SuiteSparse/
local SUITE_PARSE_VER="5.3.0"
local SUITE_PARSE_VER="5.4.0"
#
##----------------------------------------------------------
## https://ceres-solver.googlesource.com/ceres-solver/
local CERES_SOLVER_REL="-1.10.0"
local CERES_SOLVER_REL_TAG="1.10.0"
#---
local CERES_SOLVER_REL="-1.14.0"
local CERES_SOLVER_REL_TAG="1.14.0"
#
##----------------------------------------------------------
## GIS, Computer Graphics - 2D/3D, Computer Vision
##----------------------------------------------------------
#
## https://github.com/google/protobuf
local PROTOBUF_REL="v3.11.2"
##----------------------------------------------------------
## http://download.osgeo.org/proj
local PROJ_VER="4.9.3"
local PROJ_VER="6.2.1"
##----------------------------------------------------------
## http://download.osgeo.org/libtiff/
local TIFF_VER="4.0.8"
## local TIFF_VER="4.0.9"
local TIFF_VER="4.1.0"
##----------------------------------------------------------
local GEOTIFF_VER="1.4.2"
local GEOTIFF_VER="1.5.1"
##----------------------------------------------------------
local LASzip_REL="3.4.3"
##----------------------------------------------------------
# git clone is working now and that is used in script
local LIBKML_REL="1.2.0"
local LIBKML_REL="1.3.0"
##----------------------------------------------------------
## http://download.osgeo.org/geos
local GEOS_VER="3.6.1"
local GEOS_VER="3.6.3"
local GEOS_VER="3.8.0"
##----------------------------------------------------------
## https://dl.bintray.com/boostorg/release/
local BOOST_VER="1.64.0"
#local BOOST_VER="1.67.0"
local BOOST_VER="1.72.0"
##----------------------------------------------------------
# https://gitlab.com/libeigen/eigen
local EIGEN_REL="3.3.5"
## after migration
local EIGEN_REL="3.3"
##----------------------------------------------------------
local MPIR_REL_TAG="mpir-3.0.0"
##----------------------------------------------------------
local LAZ_PERF_REL="1.3.0"
##----------------------------------------------------------
local LIBLAS_REL="1.8.1"
##----------------------------------------------------------
# git clone is used, mentioned here as alternative
local LASZIP_VER="2.2.0"
local LASZIP_VER="3.2.2"
##----------------------------------------------------------
local GEOWAVE_REL_TAG="v0.9.7"
##----------------------------------------------------------
## http://download.osgeo.org/gdal
local GDAL_VER="2.2.4"
local GDAL_VER="3.0.2"
##----------------------------------------------------------
## https://github.com/PointCloudLibrary/pcl/releases
local PCL_REL="pcl-1.9.1"
##----------------------------------------------------------
## http://download.osgeo.org/pdal/
local PDAL_MARJOR_VER="1.7"
local PDAL_BUILD="1"
local PDAL_BUILD="2"
local PDAL_VER="${PDAL_MARJOR_VER}.${PDAL_BUILD}"

## https://github.com/PDAL/PDAL/releases
## for git-install
local PDAL_REL="1.9.1"
local PDAL_REL="2.0.1"
##----------------------------------------------------------
local ENTWINE_VER="2.1.0"
##----------------------------------------------------------
local SIMPLE_WEB_SERVER_VER="v3.0.2"
##----------------------------------------------------------
# https://vtk.org/download/
local VTK_VER="7.1"
local VTK_BUILD="1"
local VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

local VTK_VER="8.1"
local VTK_BUILD="0"
local VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

local VTK_VER="8.2"
local VTK_BUILD="0"
local VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

# https://github.com/Kitware/VTK

##----------------------------------------------------------
# https://github.com/opencv/opencv/releases
local OpenCV_REL="3.3.0"
local OpenCV_REL="3.4.1"
local OpenCV_REL="3.4.2"
local OpenCV_REL="4.2.0"
##----------------------------------------------------------
local OpenSfM_REL="v0.3.0"
##----------------------------------------------------------
local OpenDroneMap_REL="v0.9.1"
##----------------------------------------------------------
local OpenImageIO_REL="Release-2.1.9.0"
##----------------------------------------------------------
# https://github.com/AcademySoftwareFoundation/openexr/releases
local OPENEXR_REL="v2.4.0"
##----------------------------------------------------------
# https://github.com/alembic/alembic/releases
local ALEMBIC_REL="1.7.12"
##----------------------------------------------------------
local GEOGRAM_VER="1.7.3"
##----------------------------------------------------------
local MESHROOM_REL="v2019.2.0"
##----------------------------------------------------------
local CloudCompare_REL="v2.10.3"
##----------------------------------------------------------
## https://bitbucket.org/rhiokim/haroopad-download/downloads/
## development seems to be stopped, last release in 2016 
local HAROOPAD_VER="0.13.1"
local HAROOPAD_VER="0.13.2"
##----------------------------------------------------------
## https://github.com/jgm/pandoc/releases
local PANDOC_VER="2.11.2"
##----------------------------------------------------------
## https://freefilesync.org/download/FreeFileSync_10.19_Linux.tar.gz
local FREEFILESYNC_VER="10.19"
## https://freefilesync.org/download/FreeFileSync_11.0_Linux.tar.gz
local FREEFILESYNC_VER="11.0"
##----------------------------------------------------------
# http://icl.utk.edu/projectsfiles/magma/downloads/
local MAGMA_VER="2.5.1"
local MAGMA_VER="2.5.2"
##----------------------------------------------------------
local ASCIIDOC_REL="9.0.0"
##----------------------------------------------------------
local SHOTCUT_REL="v18.08"
local SHOTCUT_REL="v19.12.31"
##----------------------------------------------------------
local GRAFANA_VER="6.4.4"
##----------------------------------------------------------
local GITLFS_VER="v2.6.1"
##----------------------------------------------------------
local ZOOKEEPER_VER="3.5.8"
# local ZOOKEEPER_VER="3.6.1"
# local ZOOKEEPER_VER="3.6.2"
##----------------------------------------------------------
local KAFKA_REL="2.5.0"
local KAFKA_VER="2.13"
##----------------------------------------------------------
declare -a GCC_VERS=(9 8 7 6 5 4.8)
##----------------------------------------------------------
## enterprise edition
local GITLAB_INSTALLER_EE_URL=https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh
## community edition
local GITLAB_INSTALLER_CE_URL=https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
local GITLAB_INSTALLER_URL=${GITLAB_INSTALLER_CE_URL}
##----------------------------------------------------------
local VIRTUALBOX_REPO_URL="http://download.virtualbox.org/virtualbox/debian"
##----------------------------------------------------------
