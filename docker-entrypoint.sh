#!/bin/bash
echo "Starting Migrations"
python ./todoApp/manage.py migrate

echo "Start the Server"
python ./todoApp/manage.py migrate