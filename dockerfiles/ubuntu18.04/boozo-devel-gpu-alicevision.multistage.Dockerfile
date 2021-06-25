# ARG _SKILL__BASE_IMAGE_NAME=${_SKILL__BASE_IMAGE_NAME}
# FROM ${_SKILL__BASE_IMAGE_NAME} AS skillplot-base

ARG _SKILL__LINUX_DISTRIBUTION="${_SKILL__LINUX_DISTRIBUTION}"
ARG _SKILL__CUDA_VERSION="${_SKILL__CUDA_VERSION}"
# ARG AV_VERSION="2.2.8.develop"
ARG AV_VERSION

# FROM nvidia/cuda:${_SKILL__CUDA_VERSION}-devel-${_SKILL__LINUX_DISTRIBUTION} AS nvidia-cuda
FROM skillplot/boozo:${_SKILL__CUDA_VERSION}-devel-${_SKILL__LINUX_DISTRIBUTION} AS skillplot-cuda


ARG _SKILL__MAINTAINER="${_SKILL__MAINTAINER}"
LABEL maintainer "${_SKILL__MAINTAINER}"

ENV _SKILL__COPYRIGHT="${_SKILL__COPYRIGHT}"

## See http://bugs.python.org/issue19846
## format changes required for asammdf v3.4.0
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV _SKILL__UUID="${_SKILL__UUID}"
ENV _SKILL__BUILD_FOR_CUDA_VER="${_SKILL__CUDA_VERSION}"

## https://github.com/alicevision/AliceVision/blob/develop/docker/Dockerfile_ubuntu_deps
# use CUDA_VERSION to select the image version to use
# see https://hub.docker.com/r/nvidia/cuda/
#
# AV_VERSION=2.2.8.develop
# CUDA_VERSION=11.0
# UBUNTU_VERSION=20.04
# docker build \
#    --build-arg CUDA_VERSION=${_SKILL__CUDA_VERSION} \
#    --build-arg UBUNTU_VERSION${UBUNTU_VERSION} \
#    --tag alicevision/alicevision-deps:${AV_VERSION}-${_SKILL__LINUX_DISTRIBUTION}-cuda${CUDA_TAG} \
#     -f Dockerfile_ubuntu_deps .

# OS/Version (FILE): cat /etc/issue.net
# Cuda version (ENV): $CUDA_VERSION

## Install all compilation tools
## The Kitware repo provides a recent cmake
## https://apt.kitware.com/
RUN . ./etc/os-release && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget \
    software-properties-common && \
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor - > /etc/apt/trusted.gpg.d/kitware.gpg && \
  apt-add-repository "deb https://apt.kitware.com/ubuntu/ $UBUNTU_CODENAME main" && \
  apt-get clean && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    git \
    unzip \
    yasm \
    pkg-config \
    libtool \
    libssl-dev \
    nasm \
    automake \
    cmake \
    gfortran

ENV AV_DEV=/opt/AliceVision_git \
    AV_BUILD=/tmp/AliceVision_build \
    AV_INSTALL=/opt/AliceVision_install \
    PATH="${PATH}:${AV_BUNDLE}"

COPY dl/vlfeat_K80L3.SIFT.tree ${AV_INSTALL}/share/aliceVision/
RUN echo "export ALICEVISION_VOCTREE=${AV_INSTALL}/share/aliceVision/vlfeat_K80L3.SIFT.tree" > /etc/profile.d/alicevision.sh

COPY CMakeLists.txt ${AV_DEV}/

COPY dl/deps ${AV_BUILD}/external/download/

WORKDIR "${AV_BUILD}"
RUN cmake "${AV_DEV}" \
     -DCMAKE_BUILD_TYPE=Release \
     -DALICEVISION_BUILD_DEPENDENCIES:BOOL=ON \
     -DAV_BUILD_ALICEVISION:BOOL=OFF \
     -DCMAKE_INSTALL_PREFIX="${AV_INSTALL}"

# Symlink lib64 to lib as qtOIIO expects to find OIIO in lib64
RUN mkdir -p "${AV_INSTALL}/lib" && \
        ln -s lib "${AV_INSTALL}/lib64"

WORKDIR "${AV_BUILD}"
#RUN make -j"$(nproc)" zlib
#RUN make -j"$(nproc)" geogram
#RUN make -j"$(nproc)" tbb
#RUN make -j"$(nproc)" eigen
#RUN make -j"$(nproc)" opengv
#RUN make -j"$(nproc)" lapack

RUN test -e /usr/local/cuda/lib64/libcublas.so || ln -s /usr/lib/x86_64-linux-gnu/libcublas.so /usr/local/cuda/lib64/libcublas.so
#RUN make -j"$(nproc)" suitesparse
#RUN make -j"$(nproc)" ceres
#RUN make -j"$(nproc)" openexr
#RUN make -j"$(nproc)" tiff
#RUN make -j"$(nproc)" png
#RUN make -j"$(nproc)" turbojpeg
#RUN make -j"$(nproc)" libraw
#RUN make -j"$(nproc)" boost
#RUN make -j"$(nproc)" openimageio
#RUN make -j"$(nproc)" alembic
#RUN make -j"$(nproc)" popsift
#RUN make -j"$(nproc)" opencv
#RUN make -j"$(nproc)" cctag

RUN cmake --build . -j "$(nproc)" && \
    mv "${AV_INSTALL}/bin" "${AV_INSTALL}/bin-deps" && \
    rm -rf "${AV_BUILD}"



# https://github.com/alicevision/AliceVision/blob/develop/docker/Dockerfile_ubuntu

FROM alicevision/alicevision-deps:${AV_VERSION}-${_SKILL__LINUX_DISTRIBUTION}-cuda${_SKILL__CUDA_VERSION}

# use CUDA_VERSION to select the image version to use
# see https://hub.docker.com/r/nvidia/cuda/
#
# AV_VERSION=2.2.8.develop
# CUDA_VERSION=11.0
# UBUNTU_VERSION=20.04
# docker build \
#    --build-arg CUDA_VERSION=${_SKILL__CUDA_VERSION} \
#    --build-arg UBUNTU_VERSION${UBUNTU_VERSION} \
#    --build-arg AV_VERSION=2.2.8.develop \
#    --tag alicevision/alicevision:${AV_VERSION}-${_SKILL__LINUX_DISTRIBUTION}-cuda${_SKILL__CUDA_VERSION} \
#     -f Dockerfile_ubuntu .
#
# then execute with nvidia docker (https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0))
# docker run -it --runtime=nvidia alicevision/alicevision:{AV_VERSION}-${_SKILL__LINUX_DISTRIBUTION}-cuda${_SKILL__CUDA_VERSION}


# OS/Version (FILE): cat /etc/issue.net
# Cuda version (ENV): $CUDA_VERSION

ENV AV_DEV=/opt/AliceVision_git \
    AV_BUILD=/tmp/AliceVision_build \
    AV_INSTALL=/opt/AliceVision_install \
    PATH="${PATH}:${AV_BUNDLE}" \
    VERBOSE=1

COPY CMakeLists.txt *.md ${AV_DEV}/
COPY src ${AV_DEV}/src

WORKDIR "${AV_BUILD}"

RUN cmake -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DTARGET_ARCHITECTURE=core \
        -DALICEVISION_BUILD_DEPENDENCIES:BOOL=OFF \
        -DCMAKE_PREFIX_PATH:PATH="${AV_INSTALL}" \
        -DCMAKE_INSTALL_PREFIX:PATH="${AV_INSTALL}" \
        -DALICEVISION_BUNDLE_PREFIX="${AV_BUNDLE}" \
        -DALICEVISION_USE_ALEMBIC:BOOL=ON \
        -DMINIGLOG:BOOL=ON \
        -DALICEVISION_USE_CCTAG:BOOL=ON \
        -DALICEVISION_USE_OPENCV:BOOL=ON \
        -DALICEVISION_USE_OPENGV:BOOL=ON \
        -DALICEVISION_USE_POPSIFT:BOOL=ON \
        -DALICEVISION_USE_CUDA:BOOL=ON \
        -DALICEVISION_BUILD_DOC:BOOL=OFF \
        -DALICEVISION_BUILD_EXAMPLES:BOOL=OFF \
        "${AV_DEV}" && \
   make install -j"$(nproc)" && \
   rm -rf "${AV_BUILD}" "${AV_DEV}" && \
   echo "export ALICEVISION_SENSOR_DB=${AV_INSTALL}/share/aliceVision/cameraSensors.db" >> /etc/profile.d/alicevision.sh

