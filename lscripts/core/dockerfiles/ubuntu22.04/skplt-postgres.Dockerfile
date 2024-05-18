# Set the base image from an argument for flexibility
ARG _SKILL__BASE_IMAGE_NAME="ubuntu:22.04"
FROM ${_SKILL__BASE_IMAGE_NAME}

# Prevent dpkg errors by setting noninteractive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    wget \
    gnupg2 \
    software-properties-common \
    sudo \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup environment variables for locale
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# ## Optional:: For development purpose packages
# RUN apt-get install -y --no-install-recommends \
#       build-essential \
#       apt-transport-https \
#       ca-certificates \
#       pkg-config \
#       curl \
#       rsync \
#       unzip \
#       zip \
#       git \
#       grep \
#       tree \
#       jq \
#       apt-utils \
#       uuid \
#       automake \
#       locate \
#       vim \
#       less \
#       vim-gtk \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*


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

# # Setup the PostgreSQL repository and install PostgreSQL
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg \
#     && echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
#     && apt-get update \
#     && apt-get install -y postgresql-common postgresql-$PG_MAJOR=$PG_VERSION \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

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

# Configure PostgreSQL not to create a default cluster immediately
RUN echo 'create_main_cluster = false' >> /etc/postgresql-common/createcluster.conf

# Create the postgres user and group with specified UID and GID
RUN groupadd -r $POSTGRES_GROUP --gid=$POSTGRES_GROUP_GID && \
    useradd -r -g $POSTGRES_GROUP --uid=$POSTGRES_USER_UID --home-dir=/var/lib/postgresql --shell=/bin/bash $POSTGRES_USER

# Set permissions for initial scripts and PostgreSQL directories
RUN mkdir -p $PGDATA /var/run/postgresql && \
    chown -R $POSTGRES_USER:$POSTGRES_GROUP /var/lib/postgresql /var/run/postgresql && \
    chmod 2777 /var/run/postgresql

# Adjust PostgreSQL configuration to listen to all addresses and allow selected host authentication method
RUN sed -ri "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/$PG_MAJOR/main/postgresql.conf && \
    echo "host all all all $POSTGRES_HOST_AUTH_METHOD" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf

# Setup volume for PostgreSQL data
VOLUME ["$PGDATA"]

# Expose the PostgreSQL port
EXPOSE $POSTGRES_PORT

# Switch to the postgres user
USER $POSTGRES_USER

# Initialize the database manually
CMD initdb -D $PGDATA --auth=$POSTGRES_HOST_AUTH_METHOD && \
    pg_ctl -D $PGDATA -l logfile start && \
    psql --command "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';" && \
    psql --command "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;" && \
    pg_ctl -D $PGDATA stop && \
    exec postgres
