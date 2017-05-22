#!/bin/sh

echo Stopping existing container
docker stop atlassian-bitbucket
docker stop atlassian-bitbucket-database

echo Copying and running service
yes | cp optional/docker-atlassian-bitbucket-database.service /etc/systemd/system/.
yes | cp optional/docker-atlassian-bitbucket.service /etc/systemd/system/.
systemctl daemon-reload

systemctl enable docker-atlassian-bitbucket-database
systemctl enable docker-atlassian-bitbucket

systemctl start docker-atlassian-bitbucket-database
systemctl start docker-atlassian-bitbucket
echo Done!
