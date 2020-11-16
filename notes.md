# Notes from creating a simple django todo application

This project will require a few packages including Python, and pip. Here are the requirements:

1. Python - I used verion 3.8.6 - python --version
2. PIP - I used version 20.2.3 - pip --version
3. Pip django module - pip install django
4. pip psycopg2 module - pip install psycopg2

## Getting Started

Here's what was needed to get started. I used docker for the dev environment vs. installing Python on my local machine. The ./Dockerfile can be used to create a new image that has everything you need in the requirements.

```bash
# Docker commands
docker build -t tpeterson66/django-todo-app:latest .
docker run --rm --name django-todo -it -p 8000:8000 -v C:/tomscode/django-demo:/project tpeterson66/django-todo-app:latest bash
# This will create a new container and drop you in the root using bash
```

You may also want to download pgAdmin, this can be used to browse the postgres database, similar to SSMS for MsSQL.
[download here](https://www.pgadmin.org/)

We will need a postgres server for this project. You can either install the software on your machine or use a docker container for the db.
[docker hub](https://hub.docker.com/_/postgres)

Start the progress server
```bash
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
# once started, you can use pgadmin to connect using localhost:5432 and the password from above.
```

Once the database is started, check out the models.py. This will be the class used to update the database and create a new table in the DB. Once in pgadmin, right click database and click create, add a new database and store the information in settings.py under the database object.

When you trigger the migration, it will create or update the tables needed not only for the models we defined in our app, but also tha models in the default applications that ship with django.

### Run the django migration
```bash
# First, migrate the default apps. You must comment out the class section in models.py, lines 4-5
python manage.py migrate
# check pgadmin under databases -> TodoDB -> Schemas -> Tables
# if done correctly, you should see 10 ish tables in there.

# Now, migrate the single model we created.
python manage.py makemigrations todos # This will create a new folder, migrations, with a single file
python manage.py sqlmigrate todos # must include the file as a result of the previous command, this will create the sql commands. 
python manage.py migrate
# when done, you should see 11 schemas in total, including the todos_todos schema
```

### Using Django-admin to create a new project

```bash
# if using docker, cd to the project folder and execute the following command
django-admin startproject todoApp
# This will create a new folder structure in the project directory
# Test it by running run server
python manage.py runserver 0.0.0.0:8000
# if you do not specify the ip and port, it doesnt work...

# create a new app inside the project using
python manage.py startapp todos
```

Need to update the settings.py file to include the newly created application

## Setting up routing for the app

Routes are handled in the urls.py file in the parent directory. From there, you will need to link the other urls files. At the final destination, the path needs to be connected to a function, which returns a view.
