FROM openjdk:8-alpine

# Configuration variables.
ENV BITBUCKET_VERSION=5.0.1 \
    BITBUCKET_HOME=/var/atlassian/application-data/bitbucket \
    BITBUCKET_INSTALL=/opt/atlassian/bitbucket \
    MYSQL_VERSION=5.1.38

RUN set -x
RUN apk add --no-cache libressl
RUN apk add --no-cache wget
RUN apk add --no-cache tar
RUN apk add --no-cache git
RUN apk add --no-cache tomcat-native
RUN apk add --no-cache bash
RUN apk add --no-cache unzip

RUN mkdir -p "${BITBUCKET_HOME}"
RUN mkdir -p "${BITBUCKET_INSTALL}"

RUN wget -O "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" --no-verbose "http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz"
RUN wget -O "mysql-connector-java-${MYSQL_VERSION}.tar.gz" --no-verbose "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz"

RUN tar -xzvf "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" -C "${BITBUCKET_INSTALL}" --strip-components=1
RUN tar -xzvf "mysql-connector-java-${MYSQL_VERSION}.tar.gz" -C "${BITBUCKET_INSTALL}/lib" --strip-components=1

RUN ln "/usr/lib/libtcnative-1.so" "${BITBUCKET_INSTALL}/lib/native/libtcnative-1.so"
RUN sed -i 's~BITBUCKET_HOME=~BITBUCKET_HOME=${BITBUCKET_HOME}~g' "${BITBUCKET_INSTALL}/bin/set-bitbucket-home.sh"
RUN sed -i 's~/usr/bin/env\ bash~/bin/bash~g' "${BITBUCKET_INSTALL}/bin/start-bitbucket.sh"

# Add user and setup permissions
RUN adduser -D -u 1000 bitbucket
RUN chown -R bitbucket "${BITBUCKET_HOME}"
RUN chown -R bitbucket "${BITBUCKET_INSTALL}"
RUN chmod -R 700 "${BITBUCKET_HOME}"
RUN chmod -R 700 "${BITBUCKET_INSTALL}"

# Expose default HTTP connector port.
EXPOSE 7990 7999

VOLUME ["${BITBUCKET_HOME}"]

WORKDIR ${BITBUCKET_HOME}

COPY run.sh /
RUN chown bitbucket /run.sh
RUN chmod +x /run.sh

USER bitbucket

ENTRYPOINT ["/run.sh"]

