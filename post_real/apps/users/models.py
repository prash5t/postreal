import uuid

from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from django.core.validators import RegexValidator, MinLengthValidator


class User(AbstractUser):
    """Extend abstract user to get more
        control over user model."""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, db_index=True)
    username = models.CharField(max_length = 50, unique = True, db_index=True)
    email = models.EmailField(_('email address'), unique = True, db_index=True)
    phone_no = models.CharField(_('phone no.'), max_length = 15, blank = True, validators=[RegexValidator(r'^[0-9-+]+$','Invalid Mobile Number'), MinLengthValidator(10)])
    bio = models.TextField(max_length=300)
    profilePicUrl = models.ImageField(upload_to='profilePics/')

    # USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email']

    def __str__(self):
        return "{}".format(self.username)