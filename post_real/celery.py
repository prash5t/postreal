import os
from celery import Celery
from celery.schedules import crontab

# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'post_real.settings')

app = Celery('post_real')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# - namespace='CELERY' means all celery-related configuration keys
#   should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django app configs.
app.autodiscover_tasks()

app.conf.broker_transport_options = {
    'max_retries': 2,
    'interval_start': 0,
    'interval_step': 0.2,
    'interval_max': 0.2,
}

app.conf.timezone = 'Asia/Kathmandu'