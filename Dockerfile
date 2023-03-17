# Inspired from:
# Source: https://github.com/Contrast-Security-OSS/maven-yarn-docker/
# Docker Hub: https://hub.docker.com/r/contrast/maven-yarn

ARG NODE_VERSION
ARG CORRETTO_DOCKER_IMAGE_VERSION

FROM node:${NODE_VERSION}-alpine AS node

FROM amazoncorretto:${CORRETTO_DOCKER_IMAGE_VERSION}

ARG MAVEN_VERSION
ARG NODE_VERSION
ARG YARN_VERSION

ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV NODE_VERSION=${NODE_VERSION}
ENV YARN_VERSION=${YARN_VERSION}

RUN set -ex \
  && apk add --no-cache curl zip gnupg git jq dpkg bash g++ make gcc

# Install Node
# Reference: https://github.com/thisismydesign/ruby-node-alpine/blob/e81bf76c7c348b2832480d112d40f13768461297/Dockerfile
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Install Maven
RUN mkdir -p /usr/share/maven \
    && curl -Lso  /tmp/maven.tar.gz https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzC /usr/share/maven --strip-components=1 -f /tmp/maven.tar.gz \
    && rm -v /tmp/maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "/root/.m2"

# Install Yarn
RUN set -ex \
  && for key in \
  6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key"; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz.asc" \
  && gpg --batch --verify yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v${YARN_VERSION}.tar.gz -C /opt/ \
  # Remove the version coming from the node image
  && rm -rf /usr/local/bin/yarn \     
  && rm -rf /usr/local/bin/yarnpkg \
  # Use the new version instead
  && ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz
