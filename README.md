# atlassian-bitbucket - A docker image containing version 5.0.1 based on alpine linux, with mysql / postgres support
A docker container for running bitbucket - running on openjdk alpine linux.
Included in the git repo are a couple of tools to migrate data from an existing BB service into the docker container and also run as a service.

Any feedback let me know - its all welcome!

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/atlassian-bitbucket), inlcuding the script files.

# How to use this image
## (optional) build docker image

To build the local docker image, run the following command:

```
./optional/build_local.sh
```

## Initialise

Run the following command, replacing *** with your desired db password and !!!! with your db type:

```
./initial_start_with_!!!!.sh '***'
```

This will setup:
* Two containers: 
	* atlassian-bitbucket-database - a container to store your bitbucket db data
	* atlassian-bitbucket - the container containing the bb server
* Two Volumes:
	* atlassian-bitbucket-database-data - a volume for database directory
	* atlassian-bitbucket-home - a volume for bitbucket application data
* A network:
	* atlassian-bitbucket-network - a bridge network for bitbucket

Please check the services have come completely up before proceeding with the optional steps below!

Once setup, you have the option to import existing bb data, as below.

## (optional) Migrating existing BB servers

Shutdown the existing BB server instance and backup the following:
* bitbucket home - create the entire BB home directory into "bitbucket-home.zip"
* Mysqldump the existing bb db into bitbucket.sql. An example is below:
	* mysqldump --databases bitbucket > bitbucket.sql

Copy the files into the following locations, respective to the script file locations:
* imports/bitbucket-home.zip
* imports/bitbucket.sql

The file "imports/bitbucket-!!!!.properties" should not need updating and should be left alone.

Once ready, run the following script, replacing *** with your db password entered above and !!!! with your db type:

```
./optional/migrate_existing_!!!!_db_and_home.sh '***'
```

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
./optional/copy_install_and_start_as_service.sh
```

## (optional) remove all (for this image)

Running the command below will remove all trace of this docker image, services, containers, volumes and networks:

```
./optional/remove_all.sh
```

