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

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  openssh-server 2>/dev/null

## add docker group and user as same as host group and user ids and names
RUN addgroup --gid "${_SKILL__DUSER_GRP_ID}" "${_SKILL__DUSER_GRP}" && \
    useradd -ms /bin/bash "${_SKILL__DUSER}" --uid "${_SKILL__DUSER_ID}" --gid "${_SKILL__DUSER_GRP_ID}" && \
    /bin/echo "${_SKILL__DUSER}:${_SKILL__DUSER}" | chpasswd && \
    adduser ${_SKILL__DUSER} sudo && \
    /bin/echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    /bin/echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

RUN mkdir -p "${_SKILL__DOCKER_ROOT_BASEDIR}" \
      "${_SKILL__DOCKER_ROOT_BASEDIR}/installer" \
      "${_SKILL__DOCKER_ROOT_BASEDIR}/logs" \
      "${_SKILL__DOCKER_ROOT_BASEDIR}/config" \
      "/var/run/sshd"

RUN chown -R ${_SKILL__DUSER}:${_SKILL__DUSER} "${_SKILL__DOCKER_ROOT_BASEDIR}" "${_SKILL__PYVENV_PATH}" && \
    chmod -R a+w "${_SKILL__DOCKER_ROOT_BASEDIR}"

## set main entry point as working directory
WORKDIR "${_SKILL__DOCKER_ROOT_BASEDIR}"

## disable root login over ssh
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
## SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

## Run processes as non-root user
USER ${_SKILL__DUSER}

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
