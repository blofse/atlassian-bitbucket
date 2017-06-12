FROM openjdk:8-alpine

# Configuration variables.
ENV BITBUCKET_VERSION=5.0.1 \
    BITBUCKET_HOME=/var/atlassian/application-data/bitbucket \
    BITBUCKET_INSTALL=/opt/atlassian/bitbucket \
    MYSQL_VERSION=5.1.38

RUN set -x \
    && apk add --no-cache libressl wget tar git tomcat-native bash unzip perl \
    && mkdir -p "${BITBUCKET_HOME}" \
    && mkdir -p "${BITBUCKET_INSTALL}" \
    && wget -O "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" --no-verbose "http://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" \
    && wget -O "mysql-connector-java-${MYSQL_VERSION}.tar.gz" --no-verbose "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz" \
    && tar -xzvf "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" -C "${BITBUCKET_INSTALL}" --strip-components=1 \
    && tar -xzvf "mysql-connector-java-${MYSQL_VERSION}.tar.gz" -C "${BITBUCKET_INSTALL}/lib" --strip-components=1 \
    && ln "/usr/lib/libtcnative-1.so" "${BITBUCKET_INSTALL}/lib/native/libtcnative-1.so" \
    && sed -i 's~BITBUCKET_HOME=~BITBUCKET_HOME=${BITBUCKET_HOME}~g' "${BITBUCKET_INSTALL}/bin/set-bitbucket-home.sh" \
    && sed -i 's~/usr/bin/env\ bash~/bin/bash~g' "${BITBUCKET_INSTALL}/bin/start-bitbucket.sh" \
    && rm -rf "atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz" \
    && rm -rf "mysql-connector-java-${MYSQL_VERSION}.tar.gz" \
    && adduser -D -u 1000 bitbucket \
    && chown -R bitbucket "${BITBUCKET_HOME}" \
    && chown -R bitbucket "${BITBUCKET_INSTALL}" \
    && chmod -R 700 "${BITBUCKET_HOME}" \
    && chmod -R 700 "${BITBUCKET_INSTALL}"

# Expose default HTTP connector port.
EXPOSE 7990 7999

VOLUME ["${BITBUCKET_HOME}"]

WORKDIR ${BITBUCKET_HOME}

COPY run.sh /
RUN chown bitbucket /run.sh \
    && chmod +x /run.sh

USER bitbucket
ENTRYPOINT ["/run.sh"]

