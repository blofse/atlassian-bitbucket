#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker network create \
  --driver bridge \
  atlassian-bitbucket-network

echo About to start bitbucket mysql container
docker run \
  --name atlassian-bitbucket-database \
  -e MYSQL_ROOT_PASSWORD="$1" \
  -e MYSQL_DATABASE="bitbucket" \
  -e MYSQL_USER="bitbucket" \
  -e MYSQL_PASSWORD="$1" \
  -v atlassian-bitbucket-database-data:/var/lib/mysql \
  --net atlassian-bitbucket-network \
  -d \
  mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

echo About to sleep to give the server time to start up
sleep 15

echo About to start bitbucket container
docker run \
  --name atlassian-bitbucket \
  -p 7990:7990 \
  -p 7999:7999 \
  -v atlassian-bitbucket-home:/var/atlassian/application-data/bitbucket \
  --net atlassian-bitbucket-network \
  -d \
  atlassian-bitbucket
