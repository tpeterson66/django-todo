# Django Python Web App

This is a simple Python app using the Django framework used to demonstrate Django running in a Docker container and possible Kubernetes. The application is a simple to-do application allowing a user to track their to-dos and remove the to-do when its complete. This application requires a Postgres Database and is not intended to demonstrate Postgres, however, the app does require it and the Postgres database is also running in a container.

There are a few moving pieces to this application, I'll do my best to document how to get the app up and running and the intresting pieces within the project. This is not meant to be a full blown production app, with that said, do not consider anything done within the application or this project as best practice or a guide to configuring your application. Read up on the the various items and use this as a building block.

## Docker Requirements

In order to run this project, you will need both Docker and Docker Compose installed. You can either install them on your local machine or use something like DigitalOceans Docker server. If you're going to follow this guide completely, you will also need a [Docker Hub](hub.docker.com) account. They're free and you will get a free private repository, however, if you don't sotre sensitve information in your application, you wont need the private repo.

## Getting Started

When using Docker, it is not required to install the applications and dependencies on your local machine. Docker allows you to package up the application, code, dependencies, configurations, etc. into a single image allowing you to run the image virtually anywhere. This removes the required steps to configure a new machine, patch the machine, install required dependencies and ensure it is consist between environments.

## Dockerfile

The Dockerfile in the root of the project is used to build the application image. Docker files can be very simple and will grow overtime. The Dockerfile is the instruction set used to build your application into an image. [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) can be used to learn more about constructing your docker file.

## Using the Dockerfile

As I mentioned, the Dockerfile is used to build an image. If you plan on storing the Docker image in your repository, you can tag it using your account information. The act of building the image does not automatically save the image to your repo, that will be covered later. The following steps can be used to build the image using Docker and the configuration file.

```
# docker build -t <username>/<repo_name>:tag .
docker build -t tpeterson66/django-todo:v1.0 .
```

Once executed, this will use the Dockerfile to build your image and store it in your local image repository with the tag provided with the -t switch. Now that you have the image locally, you can use that to start a container.

## Pushing your Image to Docker Hub

Now that you have the image on your local machine, you can start a new container using the image. Before we do that, lets upload the image to a new repository so we can use the same image on other machines. To do this, you will need a hub.docker.com login. Once you login, create a new repository and provide a name for the image. This is a single image repository, meaning there will be multiple versions of the same application, but a single image.

```
# login via the command line
docker login
# This will popup a login window allowing you to authenticate to docker hub
docker push <username>/<repo_name>:tag
# use the same info when you built the image. This will push the image and its contents to Docker Hub.
```

## Starting the Container

A Docker container is a running instance of an image. You need an image to run a container. You do not always have to build an image in order to run a container, there are plenty of free, open-source images available. Since they're open-source, make sure you verify their origin or understand what has gone into an image. [Docker Hub](https://hub.docker.com/) is the most popular location for images. Typically, look for public images that are verified with plenty of stars and downloads. Look at the container for [Nginx](https://hub.docker.com/_/nginx) for example.

To start a container, you need the image and the following command.

```bash
docker run <image>
```

Most public images an application that will start with the container. You may need to provide configuration files or some arguments, but that simple command will start a container from the image provided.

Docker is slightly more complicated than that. Here's the documentation on the [docker run](https://docs.docker.com/engine/reference/run/) command. For this example and guide, here's what is needed to run our container.

```bash
docker run --name django-todo -p 8000:8000 -d tpeterson66/django-todo
# --name to apply a name to the container, by default, Docker will create a name from two random words - sometimes pretty funny
# -p is used to map ports from the Docker host to the container. By default, containers are isolated from the rest of the network
# -d is used to run the container as a deamon or in the background, -it can be used to interact with the container as it runs
# Check out the docker run notes for more details and additional flags.
```

Once that command is executed, you can see your running container by running "docker ps -a". This will show you details pertaining to all of the containers on your system. Notice the STATUS column for your new container.

What now? So, right now, you have a running container, which includes the django-todo Python application, all of its dependencies. Since this application requires a database, the application failed to start. One important thing to note regarding containers... They're meant to run a single process; thats it. They're not meant to run your database, application, and web server all in the same container. Each container serves a single purpose.

Since this application requires a database, we can start one using a seperate container.

```bash
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=thisSuperSECUREPassword2020! -e POSTGRES_DB=TodoDB postgres:latest
# notice the -e flag, which is used to pass environment variables to the container. This is a way to pass secrets, however, is not a best practice.
# the second -e flag is used to set the default database to TodoDB, this can be different for each app.
```

This will start a new container running postgres and configure the container with a password for the postgres user. You can use something like pgAdmin or psql to connect to the database if you'd like.

## Connecting the App to the DB

Now we have a stopped application container and a running Postgres database container. The application requires a few settings in order to point the application to the correct database server and database. Additionally, Django and Python need to configure the new database with schemas tables. In order to do that, we need to run the "python manage.py migrate" command, however, we want to run that within the container. In order to complete this task, we will need to build a new container with the correct environement variables pointing to the correct database server. This can be done using the docker run command, however, the run command can get very long and difficult to manage.

Docker Compose is the solution. Docker compose can be used to organize all of the docker run commands required to get containers up and running. We will start using docker compose from now on.

```bash
# clean up your docker environment
docker ps -a
# This will show all running and stopped containers. Gather the name for the running containers and run the following command to stop them
docker stop <container name>
# then remove them from your system to free up ports and names
docker container prune
# yes
docker image prune
# yes
```

## Docker Compose

Check out the docker-compose.yml file which includes all the settings to start and connect the two containers so the application can communicate with the database. You may need to update the image to match your username and repository to match your image. Now, run the following command which will read that configuration file and start two new containers.

```bash
# from the root of the project, run the following command
docker-compose up -d
```

## Intro to Troubleshooting

Verify this created two containers by running "docker ps -a". You'll notice two containers, however, the application container is still stopped. Lets debug that a little.

```bash
docker logs django-todo
```

This will show the logs for the server. When looking at the logs, it appears to be missing the schema and tables. Lets execute the migrate command from within the container.

```bash
docker exec -it django-todo bash
# This will start a bash terminal within the container
# now execute the python migrate command
python ./todoApp/manage.py migrate
# When finished, exit out of the container.
```

Restart the django-todo container to restart the python process and test:

```bash
docker restart django-todo
```

Open a web browser to the ip address of your docker host on port 8000

```bash
http://localhost:8000/todos/list
```

You should see a simple to-do application that you can add and remove items from the application. Notice the data persists when you exit the application since the values are stored in the database.