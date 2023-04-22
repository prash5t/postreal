from django.db import models


class TimeStamp(models.Model):
	"""
    Base Abstract TimestampModel
    """
	created_at = models.DateTimeField(auto_now_add=True, editable=False)
	updated_at = models.DateTimeField(auto_now=True, editable=False)
	is_active = models.BooleanField(default=True, editable=False)

	class Meta:
		abstract = True