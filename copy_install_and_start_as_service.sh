#!/bin/sh

echo Stopping existing container
docker stop atlassian-bamboo
docker stop atlassian-bamboo-postgres

echo Copying and running service
yes | cp docker-atlassian-bamboo-postgres.service /etc/systemd/system/.
yes | cp docker-atlassian-bamboo.service /etc/systemd/system/.
systemctl daemon-reload

systemctl start docker-atlassian-bamboo-postgres
systemctl start docker-atlassian-bamboo
echo Done!
