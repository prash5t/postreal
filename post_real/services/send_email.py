import random
from uuid import UUID

from django.conf import settings
from django.core.mail import EmailMessage
from django.template.loader import render_to_string

from post_real.apps.users.models import User, Otp


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
    
    email_receive = EmailMessage(subject, body, sender, [receiver])
    email_receive.content_subtype= 'html'
    email_receive.fail_silently=True
    email_receive.send()


def generate_otp_and_save(user_id:UUID) -> int:
    """
    Generate 4 digit otp and save. 
    """
    otp = random.randint(1000, 9999)
    Otp.objects.update_or_create(user_id_id=user_id, otp=otp)
    return otp