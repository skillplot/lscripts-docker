# Set the base image from an argument for flexibility
ARG _SKILL__BASE_IMAGE_NAME="ubuntu:22.04"
FROM ${_SKILL__BASE_IMAGE_NAME}

SHELL ["/bin/bash", "-c"]

# Prevent dpkg errors by setting noninteractive frontend
ENV DEBIAN_FRONTEND=noninteractive


# Define arguments for PostgreSQL installation and port configuration
ARG _SKILL__POSTGRES_HOST_AUTH_METHOD="md5"
ARG _SKILL__POSTGRES_PASSWORD="postgres"
ARG _SKILL__POSTGRES_USER="postgres"
ARG _SKILL__POSTGRES_GROUP="postgres"
ARG _SKILL__POSTGRES_USER_UID=999
ARG _SKILL__POSTGRES_GROUP_GID=999
ARG _SKILL__PG_MAJOR="14"
ARG _SKILL__PG_VERSION="14.12-1.pgdg110+1"
ARG _SKILL__POSTGRES_PORT="5432"

# Set environment variables from arguments
ENV POSTGRES_HOST_AUTH_METHOD=${_SKILL__POSTGRES_HOST_AUTH_METHOD} \
    POSTGRES_PASSWORD=${_SKILL__POSTGRES_PASSWORD} \
    POSTGRES_USER=${_SKILL__POSTGRES_USER} \
    POSTGRES_GROUP=${_SKILL__POSTGRES_GROUP} \
    POSTGRES_USER_UID=${_SKILL__POSTGRES_USER_UID} \
    POSTGRES_GROUP_GID=${_SKILL__POSTGRES_GROUP_GID} \
    PG_MAJOR=${_SKILL__PG_MAJOR} \
    PG_VERSION=${_SKILL__PG_VERSION} \
    PGDATA=/var/lib/postgresql/data \
    POSTGRES_PORT=${_SKILL__POSTGRES_PORT}


# ## Needed for string substitution
# SHELL ["/bin/bash", "-c"]
# Update system and install necessary packages
RUN apt-get update && apt-get install -y \
      locales \
      wget \
      gnupg2 \
      software-properties-common \
      sudo

## See http://bugs.python.org/issue19846
## format changes required for asammdf v3.4.0
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Setup the locale
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'


## For development purpose packages
RUN apt-get -qq install --no-install-recommends \
      build-essential \
      apt-transport-https \
      ca-certificates \
      pkg-config \
      curl \
      rsync \
      unzip \
      zip \
      git \
      grep \
      tree \
      jq \
      apt-utils \
      uuid \
      automake \
      locate \
      vim \
      vim-gtk 2> /dev/null


## explicitly set user/group IDs
RUN set -eux; \
  groupadd -r $POSTGRES_GROUP --gid=${POSTGRES_GROUP_GID}; \
# https://salsa.debian.org/postgresql/postgresql-common/blob/997d842ee744687d99a2b2d95c1083a2615c79e8/debian/postgresql-common.postinst#L32-35
  useradd -r -g $POSTGRES_GROUP --uid=${POSTGRES_USER_UID} --home-dir=/var/lib/postgresql --shell=/bin/bash $POSTGRES_USER; \
# also create the postgres user's home directory with appropriate permissions
# see https://github.com/docker-library/postgres/issues/274
  mkdir -p /var/lib/postgresql; \
  chown -R $POSTGRES_USER:$POSTGRES_GROUP /var/lib/postgresql


RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    gnupg \
# https://www.postgresql.org/docs/16/app-psql.html#APP-PSQL-META-COMMAND-PSET-PAGER
# https://github.com/postgres/postgres/blob/REL_16_1/src/include/fe_utils/print.h#L25
# (if "less" is available, it gets used as the default pager for psql, and it only adds ~1.5MiB to our image size)
    less \
  ; \
  rm -rf /var/lib/apt/lists/*


# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN set -eux; \
  if [ -f /etc/dpkg/dpkg.cfg.d/docker ]; then \
# if this file exists, we're likely in "debian:xxx-slim", and locales are thus being excluded so we need to remove that exclusion (since we need locales)
    grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
    sed -ri '/\/usr\/share\/locale/d' /etc/dpkg/dpkg.cfg.d/docker; \
    ! grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
  fi; \
  apt-get update; apt-get install -y --no-install-recommends locales; rm -rf /var/lib/apt/lists/*; \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen; \
  locale-gen; \
  locale -a | grep 'en_US.utf8'

# RUN set -eux; \
#   apt-get update; \
#   apt-get install -y --no-install-recommends \
#     libnss-wrapper \
#     xz-utils \
#     zstd \
#   ; \
#   rm -rf /var/lib/apt/lists/*

RUN set -ex; \
# pub   4096R/ACCC4CF8 2011-10-13 [expires: 2019-07-02]
#       Key fingerprint = B97B 0AFC AA1A 47F0 44F2  44A0 7FCC 7D46 ACCC 4CF8
# uid                  PostgreSQL Debian Repository
  key='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8'; \
  export GNUPGHOME="$(mktemp -d)"; \
  mkdir -p /usr/local/share/keyrings/; \
  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
  gpg --batch --export --armor "$key" > /usr/local/share/keyrings/postgres.gpg.asc; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME"

RUN set -ex; \
    # Avoid creating .pyc files
    export PYTHONDONTWRITEBYTECODE=1; \
    # Determine the architecture for correct package installation
    dpkgArch="$(dpkg --print-architecture)"; \
    aptRepo="deb [ signed-by=/usr/local/share/keyrings/postgres.gpg.asc ] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main $PG_MAJOR"; \
    echo "$aptRepo" > /etc/apt/sources.list.d/pgdg.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends postgresql-common; \
    # Prevent the automatic creation of a default cluster
    sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf; \
    # Install the specific PostgreSQL version
    # apt-get install -y --no-install-recommends "postgresql-$PG_MAJOR=$PG_VERSION"; \
    apt-get install -y --no-install-recommends "postgresql"; \
    # Cleanup steps to remove unnecessary files and reduce image size
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    # Remove any unnecessary .pyc files that aren't owned by a package
    find /usr -type f -name '*.pyc' -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -f "$pyc"; done' -- '{}' +;

# Display installed PostgreSQL version for verification
# RUN postgres --version

## make the sample config easier to munge (and "correct by default")
RUN set -eux; \
  dpkg-divert --add --rename --divert "/usr/share/postgresql/postgresql.conf.sample.dpkg" "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample"; \
  cp -v /usr/share/postgresql/postgresql.conf.sample.dpkg /usr/share/postgresql/postgresql.conf.sample; \
  ln -sv ../postgresql.conf.sample "/usr/share/postgresql/$PG_MAJOR/"; \
  sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample; \
  grep -F "listen_addresses = '*'" /usr/share/postgresql/postgresql.conf.sample


RUN mkdir -p /var/run/postgresql && \
  chown -R $POSTGRES_USER:$POSTGRES_GROUP /var/run/postgresql && \
  chmod 3777 /var/run/postgresql

## this 1777 will be replaced by 0700 at runtime (allows semi-arbitrary "--user" values)
RUN set -eux; \
    mkdir -p "$PGDATA" && \
    { \
        printf '\n'; \
        if [ 'trust' = "$POSTGRES_HOST_AUTH_METHOD" ]; then \
            printf '# warning trust is enabled for all connections\n'; \
            printf '# see https://www.postgresql.org/docs/12/auth-trust.html\n'; \
        fi; \
        printf 'host all all all %s\n' "$POSTGRES_HOST_AUTH_METHOD"; \
    } >> "$PGDATA/pg_hba.conf" && \
  cp -v /usr/share/postgresql/postgresql.conf.sample $PGDATA/postgresql.conf && \
  ## Copy the modified sample configuration to the actual configuration file used by PostgreSQL
  chown -R $POSTGRES_USER:$POSTGRES_GROUP "$PGDATA" && \
  chmod 1777 "$PGDATA" && \
  chmod 600 $PGDATA/pg_hba.conf && \
  chmod 600 $PGDATA/postgresql.conf

VOLUME $PGDATA

EXPOSE $POSTGRES_PORT 


USER $POSTGRES_USER

# RUN /etc/init.d/postgresql start && \
#     psql --command "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';" && \
#     /etc/init.d/postgresql stop
# Initialize the database manually
CMD initdb -D $PGDATA --auth=$POSTGRES_HOST_AUTH_METHOD && \
    pg_ctl -D $PGDATA -l logfile start && \
    psql --command "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';" && \
    psql --command "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;" && \
    pg_ctl -D $PGDATA stop && \
    exec postgres
