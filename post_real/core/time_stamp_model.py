from datetime import datetime

from django.db import models
from django.utils import timezone


def get_otp_expiry_date() -> datetime:
    return timezone.now() + timezone.timedelta(minutes=15)


class TimeStamp(models.Model):
	"""
    Base Abstract TimestampModel
    """
	created_at = models.DateTimeField(auto_now_add=True, editable=False)
	updated_at = models.DateTimeField(auto_now=True, editable=False)
	is_active = models.BooleanField(default=True, editable=False)

	class Meta:
		abstract = True