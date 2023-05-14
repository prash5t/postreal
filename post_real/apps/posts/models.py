from django.db import models
from django.core.validators import FileExtensionValidator

from post_real.apps.users.models import User
from post_real.core.time_stamp_model import TimeStamp
from post_real.core.image_validator import validate_image_size


class Post(TimeStamp):
    caption = models.CharField(max_length=100)
    description = models.TextField(max_length=500, null=True, blank=True)
    postPicUrl = models.ImageField(upload_to='mediafiles/postPics/', validators=[validate_image_size, FileExtensionValidator(allowed_extensions=['jpeg', 'jpg', 'png'])])
    userId = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True, related_name="post_user")

    def __str__(self):
        return str(self.pk)


class Like(TimeStamp):
    postId = models.ForeignKey(Post, on_delete=models.CASCADE, db_index=True, related_name='like_post')
    liked_by = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True, related_name='like_user') 

    class Meta:
        unique_together = ('postId', 'liked_by')


class Comment(TimeStamp):
    comment = models.CharField(max_length=150)
    postId = models.ForeignKey(Post, on_delete=models.CASCADE, db_index=True, related_name='comment_post')
    commented_by = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True, related_name='comment_user') 