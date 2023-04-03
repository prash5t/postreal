from .base import *

# Database
# https://docs.djangoproject.com/en/4.1/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# DATABASES = {
#     "default": {
#         "ENGINE": "django.db.backends.postgresql",
#         "NAME": os.environ.get("NAME"),
#         "USER": os.environ.get("USER"),
#         "PASSWORD": os.environ.get("PASSWORD"),
#         "HOST": os.environ.get("HOST"),
#         "PORT": os.environ.get("PORT"),
#     }
# }