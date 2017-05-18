#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker run --name atlassian-bitbucket-postgres -e POSTGRES_USER=bitbucket -e POSTGRES_PASSWORD="$1" -v BitbucketPostgresData:/var/lib/postgresql/data -d postgres:9.5.6-alpine
docker run -d --name atlassian-bitbucket --link atlassian-bitbucket-postgres:pgbitbucket -p 7990:7990 -p 7999:7999 -v BitbucketHomeVolume:/var/atlassian/application-data/bitbucket atlassian-bitbucket
