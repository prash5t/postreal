import random
from uuid import UUID
from celery import shared_task 

from django.conf import settings
from django.core.mail import EmailMessage
from django.template.loader import render_to_string

from post_real.apps.users.models import User, Otp
from post_real.core.log_and_response import info_logger
from post_real.core.time_stamp_model import get_otp_expiry_date


@shared_task(name="sendVerificationEmail")
def email_verification(user_id:UUID) -> None:
    """
    Send email to user with otp for email verification.
    """
    otp = generate_otp_and_save(user_id)
    user = User.objects.get(id=user_id)
    username = user.username
    receiver = user.email
    
    subject = 'Request For Email Verification'
    sender = '{} <{}>'.format('PostReal', settings.EMAIL_HOST_USER)
    body = render_to_string("email_verification_template.html",{
                'username': username,
                'otp': otp,
            })
    
    info_logger.info('Send email event triggered. Sending account verification email to: %s' % receiver)
    email_receive = EmailMessage(subject, body, sender, [receiver])
    email_receive.content_subtype= 'html'
    email_receive.fail_silently=True
    email_receive.send()


def generate_otp_and_save(user_id:UUID) -> int:
    """
    Generate 4 digit otp and save. 
    """
    otp = random.randint(1000, 9999)
    result, is_created = Otp.objects.get_or_create(user_id_id=user_id)
    result.otp = otp
    result.expire_at=get_otp_expiry_date()
    result.save()
    return otp