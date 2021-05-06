ARG _SKILL__BASE_IMAGE_NAME=${_SKILL__BASE_IMAGE_NAME}
FROM ${_SKILL__BASE_IMAGE_NAME}

ARG _SKILL__MAINTAINER="${_SKILL__MAINTAINER}"
LABEL maintainer "${_SKILL__MAINTAINER}"

ENV _SKILL__COPYRIGHT="${_SKILL__COPYRIGHT}"

## See http://bugs.python.org/issue19846
## format changes required for asammdf v3.4.0
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV _SKILL__UUID="${_SKILL__UUID}"

ARG _SKILL__LINUX_DISTRIBUTION="${_SKILL__LINUX_DISTRIBUTION}"

ARG _SKILL__CUDA_VERSION="${_SKILL__CUDA_VERSION}"
ENV _SKILL__BUILD_FOR_CUDA_VER="${_SKILL__CUDA_VERSION}"

ARG _SKILL__CUDNN_PKG="${_SKILL__CUDNN_PKG}"
ARG _SKILL__CUDNN_VER="${_SKILL__CUDNN_VER}"

ARG _SKILL__CUDNN_MAJOR_VERSION="${_SKILL__CUDNN_MAJOR_VERSION}"
ARG _SKILL__TENSORRT_VER="${_SKILL__TENSORRT_VER}"
ARG _SKILL__LIBNVINFER_PKG="${_SKILL__LIBNVINFER_PKG}"

## ARG LIB_DIR_PREFIX=x86_64
ARG _SKILL__pyVer="${_SKILL__pyVer}"
ARG PYTHON="python${_SKILL__pyVer}"
ARG PIP="pip${_SKILL__pyVer}"

ARG _SKILL__PY_VENV_PATH="${_SKILL__PY_VENV_PATH}"
ARG _SKILL__PY_VENV_NAME_ALIAS="${_SKILL__PY_VENV_NAME_ALIAS}"

ARG _SKILL__DUSER="${_SKILL__DUSER}"
ENV _SKILL__DUSER="${_SKILL__DUSER}"

ARG _SKILL__DUSER_ID="${_SKILL__DUSER_ID}"
ENV _SKILL__DUSER_ID="${_SKILL__DUSER_ID}"

ARG _SKILL__DUSER_GRP="${_SKILL__DUSER_GRP}"
ENV _SKILL__DUSER_GRP="${_SKILL__DUSER_GRP}"

ARG _SKILL__DUSER_GRP_ID="${_SKILL__DUSER_GRP_ID}"
ENV _SKILL__DUSER_GRP_ID="${_SKILL__DUSER_GRP_ID}"

ARG _SKILL__DOCKER_ROOT_BASEDIR="${_SKILL__DOCKER_ROOT_BASEDIR}"

## Needed for string substitution
SHELL ["/bin/bash", "-c"]

## https://github.com/phusion/baseimage-docker/issues/58#issuecomment-449220374

## To be tested, Ref: /codehub/external/tensorflow/tensorflow/tensorflow/tools/ci_build/Dockerfile.rbe.cuda10.1-cudnn7-ubuntu16.04-manylinux2010
ENV DEBIAN_FRONTEND=noninteractive

## add docker group and user as same as host group and user ids and names
## Set user files ownership to current user, such as .bashrc, .profile, etc.
RUN addgroup --gid "${_SKILL__DUSER_GRP_ID}" "${_SKILL__DUSER_GRP}" && \
    useradd -ms /bin/bash "${_SKILL__DUSER}" --uid "${_SKILL__DUSER_ID}" --gid "${_SKILL__DUSER_GRP_ID}" && \
    /bin/echo "${_SKILL__DUSER}:${_SKILL__DUSER}" | chpasswd

RUN /bin/cp -r /etc/skel/. /home/${_SKILL__DUSER} && \
    chown ${_SKILL__DUSER}:${_SKILL__DUSER_GRP} /home/${_SKILL__DUSER} && \
    /bin/ls -ad /home/${_SKILL__DUSER}/.??* | xargs chown -R ${_SKILL__DUSER}:${_SKILL__DUSER_GRP}

RUN mkdir -p "/var/run/sshd"

RUN mkdir -p "${_SKILL__PY_VENV_PATH}" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}/installer" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}/logs" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}/config"

COPY ./installer ${_SKILL__DOCKER_ROOT_BASEDIR}/installer
COPY ./logs ${_SKILL__DOCKER_ROOT_BASEDIR}/logs

RUN chown -R ${_SKILL__DUSER}:${_SKILL__DUSER} "${_SKILL__PY_VENV_PATH}" && \
      chown -R ${_SKILL__DUSER}:${_SKILL__DUSER} "${_SKILL__DOCKER_ROOT_BASEDIR}" && \
        chmod -R a+w "${_SKILL__DOCKER_ROOT_BASEDIR}" && \
        chmod -R a+x "${_SKILL__DOCKER_ROOT_BASEDIR}/installer"

# RUN apt-get update && apt-get install -y --no-install-recommends \
#       build-essential \
#       apt-transport-https \
#       ca-certificates \
#       gnupg \
#       gnupg2 \
#       wget \
#       curl \
#       software-properties-common \
#       libcurl3-dev \
#       libfreetype6-dev \
#       libhdf5-serial-dev \
#       libzmq3-dev \
#       pkg-config \
#       graphviz \
#       openmpi-bin \
#       rsync \
#       unzip \
#       zip \
#       zlib1g-dev \
#       git \
#       openjdk-8-jdk \
#       ${PYTHON} \
#       ${PYTHON}-dev \
#       ${PYTHON}-pip \
#       ${PYTHON}-tk \
#       swig \
#       grep \
#       feh \
#       tree \
#       sudo \
#       libpng-dev \
#       libjpeg-dev \
#       libtool \
#       bc \
#       jq \
#       locales \
#       openssh-server \
#       apt-utils 2>/dev/null

# RUN locale-gen en_US.UTF-8
# ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# RUN apt-get -qq install --no-install-recommends \
#       uuid \
#       automake \
#       locate \
#       vim \
#       vim-gtk > /dev/null


RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      apt-transport-https \
      ca-certificates \
      gnupg \
      gnupg2 \
      wget \
      curl \
      software-properties-common \
      sudo \
      ${PYTHON} \
      ${PYTHON}-pip \
      ${PYTHON}-tk 2>/dev/null

## Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
## dynamic linker run-time bindings
## Some TF tools expect a "python" binary
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    /bin/echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python && \
    ln -s $(which ${PIP}) /usr/bin/pip && \
    ldconfig

# RUN apt-get install -y --no-install-recommends \
#       libcudnn${_SKILL__CUDNN_VER}=${_SKILL__CUDNN_PKG} \
#       libcudnn${_SKILL__CUDNN_VER}-dev=${_SKILL__CUDNN_PKG} \
#       libnvinfer${_SKILL__TENSORRT_VER}=${_SKILL__LIBNVINFER_PKG} \
#       libnvinfer-dev=${_SKILL__LIBNVINFER_PKG} \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    wheel \
    setuptools

RUN $(which ${PIP}) --no-cache-dir install virtualenv virtualenvwrapper

## add user to sudoer
RUN adduser ${_SKILL__DUSER} sudo && \
    /bin/echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    /bin/echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

## set main entry point as working directory
WORKDIR "${_SKILL__DOCKER_ROOT_BASEDIR}"

## ARG _SKILL__BASHRC_FILE=/etc/bash.bashrc
ARG _SKILL__BASHRC_FILE="/home/${_SKILL__DUSER}/.bashrc"

# ## disable root login over ssh
# RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
# ## SSH login fix. Otherwise user is kicked off after login
# RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN /bin/echo "export VISIBLE=now" >> /etc/profile

## Install bazel needs permission of root to update the /usr/local/bin directory
# RUN source ${_SKILL__DOCKER_ROOT_BASEDIR}/installer/lscripts/bazel-install.sh

## Run processes as non-root user
USER ${_SKILL__DUSER}

## Tensorflow specific configuration
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile
# Configure the build for our CUDA configuration.
ENV LD_LIBRARY_PATH="/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
ENV CI_BUILD_PYTHON="${PYTHON}"
ENV TF_NEED_CUDA=1
ENV TF_NEED_TENSORRT=1
ENV TF_CUDA_COMPUTE_CAPABILITIES="3.5,5.2,6.0,6.1,7.0"
ENV TF_CUDA_VERSION="${_SKILL__CUDA_VERSION}"
ENV TF_CUDNN_VERSION="${_SKILL__CUDNN_MAJOR_VERSION}"

ENV FORCE_CUDA="1"
## This will build detectron2 for all common cuda architectures and take a lot more time,
## because inside `docker build`, there is no way to tell which architecture will be used.
ENV TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
## Set a fixed model cache directory.
ENV FVCORE_CACHE="/tmp"

ARG _SKILL__PY_VENV_NAME="${_SKILL__PY_VENV_NAME}"
RUN chmod a+rwx "${_SKILL__BASHRC_FILE}" && \
    venvline="export WORKON_HOME=${_SKILL__PY_VENV_PATH}" && \
    grep -qF "${venvline}" "${_SKILL__BASHRC_FILE}" || echo "${venvline}" >> "${_SKILL__BASHRC_FILE}" && \
    venvline="export PY_VENV_NAME=${_SKILL__PY_VENV_NAME}" && \
    grep -qF "${venvline}" "${_SKILL__BASHRC_FILE}" || echo "${venvline}" >> "${_SKILL__BASHRC_FILE}" && \
    venvline="export _SKILL__PY_VENV_NAME_ALIAS=${_SKILL__PY_VENV_NAME_ALIAS}" && \
    grep -qF "${venvline}" "${_SKILL__BASHRC_FILE}" || echo "${venvline}" >> "${_SKILL__BASHRC_FILE}" && \
    venvline="source /usr/local/bin/virtualenvwrapper.sh" && \
    grep -qF "${venvline}" "${_SKILL__BASHRC_FILE}" || echo "${venvline}" >> "${_SKILL__BASHRC_FILE}" && \
    venvline="alias l='ls -lrth'" && \
    grep -qF "${venvline}" "${_SKILL__BASHRC_FILE}" || echo "${venvline}" >> "${_SKILL__BASHRC_FILE}"

## Install python packages inside virtual environment
RUN export WORKON_HOME="${_SKILL__PY_VENV_PATH}" && \
    /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh && \
                  mkvirtualenv -p $(which ${PYTHON}) ${_SKILL__PY_VENV_NAME}" && \
    ln -s "${_SKILL__PY_VENV_PATH}/${_SKILL__PY_VENV_NAME}" "${_SKILL__PY_VENV_PATH}/${_SKILL__PY_VENV_NAME_ALIAS}"

# RUN export WORKON_HOME="${_SKILL__PY_VENV_PATH}" && \
#     /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh && \
#                   workon ${_SKILL__PY_VENV_NAME} && \
#                   $(which python) -m pip install --upgrade pip && \
#                   ${PIP} --no-cache-dir install -U -r ${_SKILL__DOCKER_ROOT_BASEDIR}/installer/lscripts/config/python/python.requirements-extras.txt && \
#                   ${PIP} --no-cache-dir install -U -r ${_SKILL__DOCKER_ROOT_BASEDIR}/installer/lscripts/config/${_SKILL__LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${_SKILL__CUDA_VERSION}.txt"

RUN rm -rf ./installer ${_SKILL__DOCKER_ROOT_BASEDIR}/installer

## raise to root user so developer can execute userid fixes
# USER root
