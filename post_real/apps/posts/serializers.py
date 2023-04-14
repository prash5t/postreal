from rest_framework import serializers
from .models import Post, Like


class PostSerializer(serializers.ModelSerializer):
    author = serializers.ReadOnlyField(source="userId.username")
    profilePicUrl = serializers.ImageField(source="userId.profilePicUrl", read_only=True)
    total_likes = serializers.SerializerMethodField()
    has_liked = serializers.SerializerMethodField()
    like_info_url = serializers.SerializerMethodField()

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
            "like_info_url", 

        ]
        extra_kwargs={"userId": {"write_only":True}}
    
    def get_total_likes(self, post):
        """
        Get total likes of post
        """
        if not self.context: return 0
        return post.like_post.count()

    def get_has_liked(self, post):
        """
        Check if current user has liked the post or not
        """
        if not self.context: return False
        liked_post_of_user = self.context.get("liked_post_of_user")
        return True if post.id in liked_post_of_user else False

    def get_like_info_url(self, post):
        """
        Get like info of the post. User details who liked post 
        """
        like_info_url = "/apis/v1/posts/like-info/%s/" % post
        print(like_info_url)
        return like_info_url


class LikeSerializer(serializers.ModelSerializer):
    userId = serializers.ReadOnlyField(source="liked_by.id")
    username = serializers.ReadOnlyField(source="liked_by.username")
    profilePicUrl = serializers.ImageField(source="liked_by.profilePicUrl", read_only=True)
    class Meta:
        model = Like
        fields = [
            "userId",
            "username",
            "profilePicUrl"
        ]