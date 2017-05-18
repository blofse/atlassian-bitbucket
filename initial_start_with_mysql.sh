#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

echo About to start bitbucket mysql container
docker run --name atlassian-bitbucket-mysql -e MYSQL_ROOT_PASSWORD="$1" -e MYSQL_DATABASE="bitbucket" -e MYSQL_USER="bitbucket" -e MYSQL_PASSWORD="$1" -v BitbucketMysqlData:/var/lib/mysql -d mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

echo About to sleep to give the server time to start up
sleep 15

echo About to start bitbucket container
docker run -d --name atlassian-bitbucket --link atlassian-bitbucket-mysql:mysqlbitbucket -p 7990:7990 -p 7999:7999 -v BitbucketHomeVolume:/var/atlassian/application-data/bitbucket atlassian-bitbucket
