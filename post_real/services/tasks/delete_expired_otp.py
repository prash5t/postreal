from celery import shared_task
from django.utils import timezone

from post_real.apps.users.models import Otp
from post_real.core.log_and_response import info_logger


@shared_task(name="deleteExpiredOtp")
def delete_otp() -> None:
    """
    Scheduled task for deleting expired otp everyday at 24. 
    """
    info_logger.info('Delete expired otp event triggered.')
    Otp.objects.filter(expire_at__lt=timezone.now()).delete()
