#!/bin/sh
VERSION=1.0.1
docker build . --tag dsebastien/maven-yarn:${VERSION}
docker tag dsebastien/maven-yarn:${VERSION} dsebastien/maven-yarn:latest
docker push dsebastien/maven-yarn:${VERSION}
docker push dsebastien/maven-yarn:latest
