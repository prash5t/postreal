from rest_framework import serializers
from .models import Post


class PostSerializer(serializers.ModelSerializer):
    author = serializers.ReadOnlyField(source="userId.username")
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
            "author",
            "profilePicUrl",

        ]
        extra_kwargs={"userId": {"write_only":True}}
    
    def get_total_likes(self, post):
        """
        Get total likes of the requested post
        """
        if not self.context: return 0
        return post.like_post.count()

    def get_has_liked(self, post):
        """
        Check if current user has liked the requested post or not
        """
        if not self.context: return False
        liked_post_of_user = self.context.get("liked_post_of_user")
        return True if post.id in liked_post_of_user else False