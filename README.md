# Deploying Django with Gunicorn, Postgres, Pgadmin and Nginx

In [development mode](https://github.com/hatef-hosseinpour/django_on_docker/blob/main/docker-compose.yml), it uses port 8000 and its image is created with the following command:

    $ docker compose up -d --build

In [production mode](https://github.com/hatef-hosseinpour/django_on_docker/blob/main/docker-compose.prod.yml) it uses port 80 (nginx) and its image is created with the following command:

    $ docker compose -f docker-compose.prod.yml --env-file ./.env.prod.db --env-file ./.env.prod up -d --build
