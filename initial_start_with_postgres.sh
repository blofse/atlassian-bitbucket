#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker network create \
  --driver bridge \
  atlassian-bitbucket-network

docker run \
  --name atlassian-bitbucket-database \
  -e POSTGRES_USER=bitbucket \
  -e POSTGRES_PASSWORD="$1" \
  -v atlassian-bitbucket-database-data:/var/lib/postgresql/data \
  --net atlassian-bitbucket-network \
  -d \
  postgres:9.5.6-alpine

docker run \
  --name atlassian-bitbucket \
  -p 7990:7990 \
  -p 7999:7999 \
  -v atlassian-bitbucket-home:/var/atlassian/application-data/bitbucket \
  --net atlassian-bitbucket-network \
  -d \
  atlassian-bitbucket
