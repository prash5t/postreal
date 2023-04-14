# Generated by Django 4.2 on 2023-04-10 14:58

from django.conf import settings
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ("posts", "0002_initial"),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name="like",
            unique_together={("postId", "liked_by")},
        ),
    ]