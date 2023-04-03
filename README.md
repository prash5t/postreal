# Post Real

## Local Setup

- create `.env` file in root directory and populate all environment variables listed below. Do NOT commit this file

```toml
SECRET_KEY=<secret_key>
```

- Run web service

```commandline
sudo docker-compose up --build
```

- Create an admin user

```commandline
sudo docker-compose run web python manage.py createsuperuser --email admin@example.com --username admin
```

```commandline
sudo docker exec -it <container_id> python manage.py createsuperuser --email admin@example.com --username admin
```

## DRF

- Go to `/api/` to check all available rest APIs
- Login with admin or any other user to try out API
