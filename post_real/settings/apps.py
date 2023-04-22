
# Application definition

INSTALLED_APPS = [
    # django apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # third party apps
    'rest_framework',
    'corsheaders',
    'django_cleanup',
    'rest_framework_simplejwt',
    'django_filters',

    # user defined
    'post_real.apps.users',
    'post_real.apps.posts',
]
