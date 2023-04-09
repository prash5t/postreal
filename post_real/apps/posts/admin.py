from django.contrib import admin
from .models import Post


@admin.register(Post)
class UserAdmin(admin.ModelAdmin):
    list_display = ('id', 'caption', 'created_at', 'updated_at', 'userId')