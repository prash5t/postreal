import uuid
from PIL import Image

from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from django.core.validators import RegexValidator, MinLengthValidator, FileExtensionValidator

from post_real.core.image_size_validator import validate_image_size


class User(AbstractUser):
    """Extend abstract user to get more
        control over user model."""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, db_index=True)
    username = models.CharField(max_length = 50, unique = True, db_index=True)
    email = models.EmailField(_('email address'), unique = True, db_index=True)
    phone_no = models.CharField(_('phone no.'), max_length = 15, blank=True, null=True, validators=[RegexValidator(r'^[0-9-+]+$','Invalid Mobile Number'), MinLengthValidator(10)])
    bio = models.TextField(max_length=300)
    profilePicUrl = models.ImageField(upload_to='mediafiles/profilePics/', validators=[validate_image_size, FileExtensionValidator(allowed_extensions=['jpeg', 'jpg', 'png'])])
    is_verified = models.BooleanField(default=False, editable=False)
    updated_at = models.DateTimeField(auto_now=True, editable=False)

    # USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email']

    def __str__(self):
        return "{}".format(self.username)

    # include image compressor here
    # def save(self, *args, **kwargs):
    #     # img = compress(self.profilePicUrl)
    #     # print('=======')
    #     # print(image, "=================================")
    #     img = Image.open(self.profilePicUrl)
    #     print(img)
    #     width, height = img.size
    #     # target_width = 600
    #     # h_coefficient = width/600
    #     # target_height = height/h_coefficient
    #     # target_width=100
    #     # target_height=100
    #     print(width, height, '====')
    #     img = img.resize((int(width), int(height)), Image.ANTIALIAS)
    #     print("=========================================================")
    #     print(img.size, "========")
    #     print(self.profilePicUrl.path, '===========')
    #     img.save(self.profilePicUrl.path, quality=30)
    #     img.close()
    #     self.profilePicUrl.close()