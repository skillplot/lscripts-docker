# ARG _SKILL__BASE_IMAGE_NAME="ubuntu:22.04"
ARG _SKILL__BASE_IMAGE_NAME
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

RUN mkdir -p "${_SKILL__DOCKER_ROOT_BASEDIR}"

RUN chown -R ${_SKILL__DUSER}:${_SKILL__DUSER} "${_SKILL__DOCKER_ROOT_BASEDIR}" && \
        chmod -R a+w "${_SKILL__DOCKER_ROOT_BASEDIR}"

## Install essential utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      apt-transport-https \
      ca-certificates \
      gnupg \
      gnupg2 \
      wget \
      curl \
      software-properties-common \
      pkg-config \
      rsync \
      unzip \
      zip \
      git \
      openjdk-8-jdk \
      grep \
      tree \
      sudo \
      jq \
      locales \
      apt-utils 2>/dev/null

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get -qq install --no-install-recommends \
      automake \
      locate \
      vim \
      vim-gtk > /dev/null

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN adduser ${_SKILL__DUSER} sudo && \
    echo "${_SKILL__DUSER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${_SKILL__DUSER} && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${_SKILL__DUSER} && \
    chmod 0440 /etc/sudoers.d/${_SKILL__DUSER}

## set main entry point as working directory
WORKDIR "${_SKILL__DOCKER_ROOT_BASEDIR}"

## ARG _SKILL__BASHRC_FILE=/etc/bash.bashrc
ARG _SKILL__BASHRC_FILE="/home/${_SKILL__DUSER}/.bashrc"

## Run processes as non-root user
USER ${_SKILL__DUSER}

## raise to root user so developer can execute userid fixes
# USER root
