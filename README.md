# atlassian-bitbucket
A docker container for running bitbucket - running on openjdk alpine linux.
Included in the git repo are a couple of tools to migrate data from an existing BB service into the docker container and also run as a service.

Any feedback let me know - its all welcome!

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/atlassian-bitbucket), inlcuding the script files.

# How to use this image
## Initialise
Run the following command, replacing *** with your desired db password:
```
initial_start_with_mysql.sh "***"
```
This will setup two containers: 
* atlassian-bitbucket-mysql - a container to store your bb db data
* atlassian-bitbucket - the container containing the bb server

Once setup, you have the option to import existing bb data, as below.

## (optional) Migrating existing BB servers

Shutdown the existing BB server instance and backup the following:
* <bitbucket home> - create the entire BB home directory into "bitbucket-home.zip"
* Mysqldump the existing bb db into bitbucket.sql. An example is below:
 * mysqldump --databases bitbucket > bitbucket.sql

Copy the files into the following locations, respective to the script file locations:
* imports/bitbucket-home.zip
* imports/bitbucket.sql

The file "imports/bitbucket.properties" should not need updating and should be left alone.

Once ready, run the following script, replacing *** with your db password entered above:
```
migrate_existing_db_and_home.sh "***"
```

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
copy_install_and_start_as_service.sh
```
