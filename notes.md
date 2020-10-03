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