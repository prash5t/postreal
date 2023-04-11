from django.contrib import admin
from .models import Post, Like, Comment


@admin.register(Post)
class UserAdmin(admin.ModelAdmin):
    list_display = ('id', 'caption', 'created_at', 'updated_at', 'userId')


@admin.register(Like)
class LikeAdmin(admin.ModelAdmin):
    list_display = ('id', 'postId', 'liked_by')


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('id', 'postId', 'comment', 'commented_by')