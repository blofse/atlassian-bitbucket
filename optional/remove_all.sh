#!/bin/bash

echo Stopping/removing services
systemctl stop docker-atlassian-bitbucket-database
systemctl stop docker-atlassian-bitbucket

systemctl disable docker-atlassian-bitbucket-database
systemctl disable docker-atlassian-bitbucket

if [ -f /etc/systemd/system/docker-atlassian-bitbucket.service ]; then
  rm -fr /etc/systemd/system/docker-atlassian-bitbucket.service
fi
if [ -f /etc/systemd/system/docker-atlassian-bitbucket-database.service ]; then
  rm -fr /etc/systemd/system/docker-atlassian-bitbucket-database.service
fi

systemctl daemon-reload

echo Kill/remove docker images
docker stop atlassian-bitbucket-database || true && docker rm atlassian-bitbucket-database || true
docker stop atlassian-bitbucket || true && docker rm atlassian-bitbucket || true

echo Removing volumes
docker volume rm atlassian-bitbucket-database-data || true
docker volume rm atlassian-bitbucket-home || true

echo Removing networks
docker network rm atlassian-bitbucket-network || true

echo Removing docker image - bitbucket only
docker rmi atlassian-bitbucket

echo Done!