from rest_framework import serializers
from .models import  Post, Like


class PostSerializer(serializers.ModelSerializer):
    username = serializers.ReadOnlyField(source="userId.username")
    profilePicUrl = serializers.ImageField(source="userId.profilePicUrl", read_only=True)
    total_likes = serializers.SerializerMethodField()
    has_liked = serializers.SerializerMethodField()

    class Meta:
        model=Post
        fields = [
            "id",
            "caption",
            "description",
            "postPicUrl",
            "created_at",
            "updated_at",
            "total_likes",
            "has_liked",
            "userId",
            "username",
            "profilePicUrl",

        ]
        extra_kwargs={"userId": {"write_only":True}}
    
    def get_total_likes(self, post):
        """
        Get total likes of the requested post
        """
        return Like.objects.filter(postId=post).count()

    def get_has_liked(self, post):
        """
        Check if current user has liked the requested post or not
        """
        current_user = self.context.get('current_user')
        if not current_user: return False
        try:
            Like.objects.get(postId=post, liked_by=current_user)
            return True
        except Like.DoesNotExist:
            return False
    