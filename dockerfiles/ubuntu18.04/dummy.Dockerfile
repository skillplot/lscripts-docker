FROM ubuntu:18.04

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ARG _SKILL__MAINTAINER="${_SKILL__MAINTAINER}"
LABEL maintainer "${_SKILL__MAINTAINER}"

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

##ENV DEBIAN_FRONTEND=noninteractive

## add docker group and user as same as host group and user ids and names
## Set user files ownership to current user, such as .bashrc, .profile, etc.
RUN addgroup --gid "${_SKILL__DUSER_GRP_ID}" "${_SKILL__DUSER_GRP}" && \
    useradd -ms /bin/bash "${_SKILL__DUSER}" --uid "${_SKILL__DUSER_ID}" --gid "${_SKILL__DUSER_GRP_ID}" && \
    /bin/echo "${_SKILL__DUSER}:${_SKILL__DUSER}" | chpasswd && \
    /bin/cp -r /etc/skel/. /home/${_SKILL__DUSER} && \
    chown ${_SKILL__DUSER}:${_SKILL__DUSER_GRP} /home/${_SKILL__DUSER} && \
    /bin/ls -ad /home/${_SKILL__DUSER}/.??* | xargs chown -R ${_SKILL__DUSER}:${_SKILL__DUSER_GRP} && \
  mkdir -p "${_SKILL__PYVENV_PATH}" "/var/run/sshd" && \
  mkdir -p "${_SKILL__DOCKER_ROOT_BASEDIR}" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}/installer" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}/logs" \
    "${_SKILL__DOCKER_ROOT_BASEDIR}/config"

COPY ./installer ${_SKILL__DOCKER_ROOT_BASEDIR}/installer

RUN chown -R ${_SKILL__DUSER}:${_SKILL__DUSER} "${_SKILL__DOCKER_ROOT_BASEDIR}" && \
      chmod -R a+w "${_SKILL__DOCKER_ROOT_BASEDIR}" && \
      chmod -R a+x "${_SKILL__DOCKER_ROOT_BASEDIR}/installer"

## sudoer
# RUN adduser ${_SKILL__DUSER} sudo && \
#     /bin/echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
#     /bin/echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \

## Run processes as non-root user
USER ${_SKILL__DUSER}
RUN source ${_SKILL__DOCKER_ROOT_BASEDIR}/installer/lscripts/snippets/dummy.sh
