# Mura Docker Project
This repository is designed to be used as a starting point for your next Mura development project.

## First Run Setup
1. Install [Docker for Mac or Windows](https://www.docker.com/products/docker)

2. Install Git (GUI or Command Line Tools, or [GitHub Desktop](https://desktop.github.com))

3. Clone this repository into: `/Users/{username}/projects/mura-docker-project`

4. CD into the project directory
  ```
  cd /Users/{username}/projects/mura-docker-project
  ```

5. Start the project
  ```
  docker-compose up
  ```

6. At this point you should be able to see default pages on http://localhost

7. Congrats, You're up and running!

## To Stop Running Services
Once the services are up and running you can kill them by simply doing `ctrl + c`.  You can also stop the service from a separate terminal window from the one it was started in by running `docker-compose kill` from the project root directory

## Starting Services
Now that you've successfully stopped the services, to get them back up and running again you can simply do `docker-compose up`.

In addition, you can choose to just start a single service by running a command such as `docker-compose up mysql`.  This command will only launch the cf11 service and any of it's dependents such as mysql.

For a full list of services available you can open the `docker-compose.yml` file which is located in the root of this repo.

## Accessing Service Containers
This repo runs on docker and each of the services in the `./services` directory run in a separate container.  A container is simply a self contained execution environment.  It provides a full OS designed just to run 1 particular service at a time.  You can learn more about containers here: http://www.infoworld.com/article/3072929/linux/containers-101-linux-containers-and-docker-explained.html

Sometimes you may want to log into these execution environments to debug issues.  Lets say for example you'd like to access the mura container, you can run the following command: ```docker-compose exec mura bash```

This command expanded says:

`exec` (execute) - on the `mura` (mura container) - the `bash` command.

This gives us access to that containers filesystem and a local terminal experience for running additional commands.  We can call this process "Bashing into a container" and it's very similar to logging into a VM with ssh.

However you can run any command that exists on a container with ease by replacing `bash` with the name of the command, for example:

```
docker-compose exec mura tail -f '/opt/coldfusion/cfusion/logs/exception.log'
```

As you can see here I'm running the tail command with a `-f` follow option and the path and filename of the exception log in the cf11 container

## Fully Removing Container Volumes & Persistence
By default when you `kill` containers of perform `ctrl+c` the filesystem inside the container stays intact for the next start of the container.  However, docker runs on a host VM and if the entire docker application stops then any data on the container filesystems will be lost.

In addition, you can explicitly remove the existing containers and their filesystems by doing `docker-compose down`.

**IMPORTANT** Be careful with restarting your machine, or running a `docker-compose down` because any temporary data you added to your local database will be lost.

## Directory Structure & Documentation
Please reference the README.MD inside each of the top level directories in this repository for an overview of how that directory is used.

- `/services` Contains various services we use for development.  Each one of these services run in their own docker container, and the file structure mimics the file structure of the container that is created.
- `/deploy` Maintains docker cloud stack files that can be used for deployment

# Taking Data Snapshots
After the application is up and running you may want to share the setup work that you've done creating data.

To do this there are mysql commands you can run against your mysql container

#### Copy current local DB into the .git repo
You can create a snapshot of your local database by running the following command
```
docker-compose exec mysql sh -c 'mysqldump --add-drop-database --add-drop-table --skip-comments --disable-keys --user=root --password=$MYSQL_ROOT_PASSWORD --databases mura' > ./services/mysql/docker-entrypoint-initdb.d/mura.sql
```

This will create a new MySQL dump file located in `./services/mysql/docker-entrypoint-initdb.d/`

#### Copy current production DB into the .git repo
You can create a snapshot of your local database by running the following command
```
docker-compose exec mysql sh -c 'mysqldump --add-drop-database --add-drop-table --skip-comments --disable-keys  --host=mysql.myproject.com --user=root --password=$MYSQL_ROOT_PASSWORD --databases mura' > ./services/mysql/docker-entrypoint-initdb.d/mura.sql
```

This will create a new MySQL dump file located in `./services/mysql/docker-entrypoint-initdb.d/`

#### Loading Data Snapshot
By default anything in the `./services/mysql/docker-entrypoint-initdb.d/` directory will be run when the mysql container is started with `docker-compose up`.
