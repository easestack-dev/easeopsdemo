#!/usr/bin/env bash
# Created by g7tianyi on 03/09/2017

set -e

pushd $(dirname $0) > /dev/null
SCRIPTPATH=$(pwd -P)
popd > /dev/null
SCRIPTFILE=$(basename $0)

function info() {
  NOW=$(date '+%Y/%m/%d %H:%M:%S')
  echo -e "${NOW} - $1"
}

function log() {
  echo "================================================================================"
  info "$1"
  echo ""
}

################################################################################

IMAGE_NAME="nightwatch-demo"
DOCKER_IMAGE="dockerhub.megaease.com/megaease/${IMAGE_NAME}"
DOCKER_CONTAINER_NAME="demo-app"

IMAGE_VERSION=""

function showUsage() {
    echo -e ""
    echo -e "${SCRIPTFILE} [-h] -v <ImageVersion>"
    echo -e ""
    echo -e "  -h : Show this message"
    echo -e "  -v : Specify the image version"
    echo -e ""
}

function stopInstance() {
    log "Stop Instance"
    docker rm -f $(docker ps -a | grep ${DOCKER_CONTAINER_NAME} | awk '{print $1}') || /bin/true
}

function startInstance() {
    log "Pull Docker Image"
    IMAGE=""
    if [ -z "${IMAGE_VERSION}" ]; then
        docker rmi $(docker images | grep 'nightwatch-demo') || /bin/true
        IMAGE="${DOCKER_IMAGE}"
    else
        IMAGE="${DOCKER_IMAGE}:${IMAGE_VERSION}"
    fi
    docker pull ${IMAGE}

    log "Start Instance"
    docker run --name ${DOCKER_CONTAINER_NAME} -d -p 80:80 ${IMAGE}
}

while getopts  'hv:' flag; do
    case "${flag}" in
        h) showUsage; exit ;;
        v) IMAGE_VERSION="${OPTARG}";;
    esac
done

stopInstance
startInstance
