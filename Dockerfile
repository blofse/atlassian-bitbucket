FROM openjdk:8-alpine

# Configuration variables.
ENV BITBUCKET_VERSION=5.0.0 \
    BITBUCKET_HOME=/var/atlassian/bitbucket \
    BITBUCKET_INSTALL=/opt/atlassian/bitbucket

# Install Atlassian JIRA and helper tools and setup initial home
# directory structure.
RUN set -x
RUN apk add --no-cache libressl
RUN apk add --no-cache wget
RUN apk add --no-cache tar
RUN apk add --no-cache git
RUN apk add --no-cache tomcat-native
RUN apk add --no-cache bash
RUN mkdir -p "${BITBUCKET_HOME}"
RUN mkdir -p "${BITBUCKET_INSTALL}"
RUN wget -O "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" --no-verbose "http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz"
RUN tar -xzvf "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" -C "${BITBUCKET_INSTALL}" --strip-components=1

RUN ln "/usr/lib/libtcnative-1.so" "${BITBUCKET_INSTALL}/lib/native/libtcnative-1.so"

RUN sed -i 's~BITBUCKET_HOME=~BITBUCKET_HOME=${BITBUCKET_HOME}~g' "${BITBUCKET_INSTALL}/bin/set-bitbucket-home.sh"
RUN sed -i 's~/usr/bin/env\ bash~/bin/bash~g' "${BITBUCKET_INSTALL}/bin/start-bitbucket.sh"

# Add jira user and setup permissions
RUN adduser -D -u 1000 bitbucket
RUN chown -R bitbucket "${BITBUCKET_HOME}"
RUN chown -R bitbucket "${BITBUCKET_INSTALL}"

RUN chmod -R 700 "${BITBUCKET_HOME}"
RUN chmod -R 700 "${BITBUCKET_INSTALL}"

# Expose default HTTP connector port.
EXPOSE 7990 7999

# Create the volumes and mount
VOLUME ["${BITBUCKET_HOME}", "${BITBUCKET_INSTALL}/logs"]

# Set the default working directory as the installation directory.
WORKDIR ${BITBUCKET_HOME}

# Run Atlassian Bamboo as a foreground process by default.
USER bitbucket

CMD ["/opt/atlassian/bitbucket/bin/start-bitbucket.sh", "run"]
