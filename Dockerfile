FROM python
WORKDIR /usr/src/app
RUN pip install django
RUN pip install psycopg2
COPY . .
ENV POSTGRES_NAME=todo
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_HOST=localhost
ENV POSTGRES_PORT=5432
CMD [ "python", "./todoApp/manage.py", "migrate"]
CMD [ "python", "./todoApp/manage.py", "runserver", "0.0.0.0:8000" ]