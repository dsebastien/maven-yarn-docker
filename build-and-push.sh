#!/bin/sh
IMAGE_VERSION=1.0.4

CORRETTO_DOCKER_IMAGE_VERSION=17-alpine3.17

MAVEN_VERSION=3.9.4
NODE_VERSION=16.20.0
YARN_VERSION=1.22.19

docker build . \
  --build-arg MAVEN_VERSION=${MAVEN_VERSION} \
  --build-arg NODE_VERSION=${NODE_VERSION} \
  --build-arg YARN_VERSION=${YARN_VERSION} \
  --build-arg CORRETTO_DOCKER_IMAGE_VERSION=${CORRETTO_DOCKER_IMAGE_VERSION} \
  --tag dsebastien/maven-yarn:${IMAGE_VERSION}
docker tag dsebastien/maven-yarn:${IMAGE_VERSION} dsebastien/maven-yarn:latest
docker push dsebastien/maven-yarn:${IMAGE_VERSION}
docker push dsebastien/maven-yarn:latest
