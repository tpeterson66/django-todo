FROM python
WORKDIR /usr/src/app
RUN pip install django
RUN pip install psycopg2
COPY . .
CMD [ "python", ".todoApp/manage.py", "runserver", "0.0.0.0:8000" ]