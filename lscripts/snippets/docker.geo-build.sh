function main() {

  local POSTGRES_USER="postgres"
  # local POSTGRES_USER_ID="postgres"


  local POSTGRES_GROUP="postgres"
  # local POSTGRES_GROUP_ID="postgres"


  # _SKILL__POSTGRES_USER_ID=$POSTGRES_USER_ID
  # _SKILL__POSTGRES_GROUP_ID=$POSTGRES_GROUP_ID
  # _SKILL__POSTGRES_GROUP=$POSTGRES_GROUP


  local BASE_IMAGE_NAME="skillplot/boozo:skplt-x86_64-100524_003302"
  local POSTGRES_PASSWORD="postgres"

  local GEOSERVER_VERSION="2.19.2"
  local GEOSERVER_HOME="/opt/geoserver"
  local GEOSERVER_USER="admin"
  local GEOSERVER_PASSWORD="geoserverpassword"
  local GEOSERVER_URL="https://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-bin.zip"

  local DOCKER_BLD_CONTAINER_IMG="skplt-geo-$(date +"%d%m%y_%H%M%S")-${1:-v1}" 
  local DOCKERFILE="$__CODEHUB_ROOT__/external/lscripts-docker/lscripts/core/dockerfiles/ubuntu22.04/skplt-dev.geo.Dockerfile"
  local DOCKER_CONTEXT="$PWD"
  local DOCKER_CMD=docker

  ${DOCKER_CMD} build --progress=plain \
        --build-arg "_SKILL__BASE_IMAGE_NAME=${BASE_IMAGE_NAME}" \
        --build-arg "_SKILL__GEOSERVER_VERSION=${GEOSERVER_VERSION}" \
        --build-arg "_SKILL__GEOSERVER_HOME=${GEOSERVER_HOME}" \
        --build-arg "_SKILL__POSTGRES_USER=${POSTGRES_USER}" \
        --build-arg "_SKILL__POSTGRES_GROUP=${POSTGRES_GROUP}" \
        --build-arg "_SKILL__POSTGRES_PASSWORD=${POSTGRES_PASSWORD}" \
        --build-arg "_SKILL__GEOSERVER_USER=${GEOSERVER_USER}" \
        --build-arg "_SKILL__GEOSERVER_URL=${GEOSERVER_URL}" \
        --build-arg "_SKILL__GEOSERVER_PASSWORD=${GEOSERVER_PASSWORD}" \
        -t ${DOCKER_BLD_CONTAINER_IMG} \
        -f ${DOCKERFILE} ${DOCKER_CONTEXT}

}

main "$@"


# wget -q -O geoserver.zip https://sourceforge.net/projects/geoserver/files/GeoServer/2.19.2/geoserver-2.19.2-bin.zip
