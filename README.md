# Post Real

## Local Setup

- create `.env` file in root directory and populate all environment variables listed below. DO NOT commit this file

```toml
# environment type: local, dev, prod
ENVIRON = "local"

#django secret key
SECRET_KEY = <secret_key>

# database configuration
NAME = <db_name>
USER = <db_user>
PASSWORD = <db_password>
HOST = <db_host>
PORT = <port>

# AWS S3 bucket configuration
AWS_ACCESS_KEY_ID = <access_key_id>
AWS_SECRET_ACCESS_KEY = <secret_access_key>
AWS_STORAGE_BUCKET_NAME = <bucket_name>
AWS_S3_REGION_NAME = <region_name>

#smtp configuration
EMAIL_HOST_USERNAME = <sender_email>
EMAIL_HOST_PASSWORD = <app_password>
EMAIL_PORT = <email_port>

# papertrail logs configuration
PAPERTRAIL_HOST = <papertrail_host>
PAPERTRAIL_PORT = <papertrail_port>

# telegram bot configuration
BOT_TOKEN = <telegram_bot_token>
CHAT_ID = <list_of_chat_ids>
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

## DRF-APIs

- Go to `/apis/v1/` to check all available Rest APIs.
- Create account and use Bearer Token to try out APIs.

## API Documentation

https://documenter.getpostman.com/view/20327787/2s93Xx14Ts
