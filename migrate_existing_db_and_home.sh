#!/bin/bash

if [[ $# -eq 0 ]] ; then
  echo 'Expecting one argument'
  exit 0
fi

if [ ! -f imports/bitbucket-home.zip ]; then
  echo File imports/bitbucket-home.zip not found, please export your existing BB home into this file for import
  exit 0
fi

if [ ! -f imports/bitbucket.sql ]; then
  echo File imports/bitbucket.sql not found, please mysqldump your BB db into this file for import
  exit 0
fi

echo Stopping BB
docker exec -i -u bitbucket atlassian-bitbucket /opt/atlassian/bitbucket/bin/stop-bitbucket.sh

echo Importing existing data
docker exec -i atlassian-bitbucket-mysql mysql -u bitbucket --password="$1" bitbucket < imports/bitbucket.sql

echo Copying home zip over to docker image
docker cp imports/bitbucket-home.zip atlassian-bitbucket:/bitbucket-home.zip

echo Extracting zip inside docker container
docker exec -u bitbucket -i atlassian-bitbucket /bin/bash -c 'unzip /bitbucket-home.zip -d /tmp'

echo Removing old and copying new
docker exec -u bitbucket -i atlassian-bitbucket /bin/bash -c 'rm -fr /var/atlassian/bitbucket/*'
docker exec -u bitbucket -i atlassian-bitbucket /bin/bash -c 'cp -R /tmp/bitbucket/* /var/atlassian/bitbucket/'
echo Cleaning copies
docker exec -u bitbucket -i atlassian-bitbucket /bin/bash -c 'rm -fr /tmp/bitbucket/'
docker exec -u root -i atlassian-bitbucket /bin/bash -c 'rm -f /bitbucket-home.zip'

echo Copying over new properties
cp imports/bitbucket.properties bitbucket.properties
sed -i 's~jdbc.password=.*~jdbc.password='$1'~g' bitbucket.properties
docker cp bitbucket.properties atlassian-bitbucket:/var/atlassian/bitbucket/shared/bitbucket.properties
rm bitbucket.properties

echo Starting up BB service
docker stop atlassian-bitbucket
docker start atlassian-bitbucket

