#!/bin/sh
docker build . --tag dsebastien/maven-yarn:1.0
docker tag dsebastien/maven-yarn:1.0 dsebastien/maven-yarn:latest
docker push dsebastien/maven-yarn:1.0
docker push dsebastien/maven-yarn:latest
