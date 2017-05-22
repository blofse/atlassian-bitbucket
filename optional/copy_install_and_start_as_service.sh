#!/bin/sh

echo Stopping existing container
docker stop atlassian-bitbucket
docker stop atlassian-bitbucket-mysql

echo Copying and running service
yes | cp docker-atlassian-bitbucket-mysql.service /etc/systemd/system/.
yes | cp docker-atlassian-bitbucket.service /etc/systemd/system/.
systemctl daemon-reload

systemctl enable docker-atlassian-bitbucket-mysql
systemctl enable docker-atlassian-bitbucket

systemctl start docker-atlassian-bitbucket-mysql
systemctl start docker-atlassian-bitbucket
echo Done!
