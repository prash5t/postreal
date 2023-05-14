from rest_framework import serializers

from .models import  User, Connection
from post_real.core.image_validator import compress_image


class UserSerializer(serializers.ModelSerializer):
    followers = serializers.SerializerMethodField()
    following = serializers.SerializerMethodField()
    is_following = serializers.SerializerMethodField()
    urls = serializers.SerializerMethodField()

    class Meta:
        model=User
        fields = [
            'id',
            'username',
            'password',
            'email',
            'bio',
            'profilePicUrl',
            'phone_no',
            'followers',
            'following',
            'is_verified',
            'is_following',
            'urls'

        ]
        extra_kwargs = {'password': {'write_only': True}}
        
    def create(self, validated_data):  
        #compress profile image and create user 
        validated_data['profilePicUrl'] = compress_image(validated_data['profilePicUrl'])
        user = User.objects.create_user(**validated_data)
        return user

    def update(self, instance, validated_data):
        #compress profile image and update user 
        validated_data['profilePicUrl'] = compress_image(validated_data['profilePicUrl'])
        return super().update(instance, validated_data)

    def get_followers(self, user):
        """
        Get total no. of followers.
        """
        if not self.context: return 0
        return user.connection_following_user.count()
    
    def get_following(self, user):
        """
        Get total no. of following.
        """
        if not self.context: return 0
        return user.connection_user.count()
    
    def get_is_following(self, user):
        """
        Check if current user has liked the post or not.
        """
        if not self.context: return False
        following_users = self.context.get("following_users")
        return True if user.id in following_users else False
    
    def get_urls(self, user):
        """
        Get useful urls.
        """
        if not self.context: return None
        follower_info_url = "/apis/v1/users/follower-info/%s/" % user.id
        following_info_url = "/apis/v1/users/following-info/%s/" % user.id
        post_info_url = "/apis/v1/posts/operation/?userId=%s" % user.id
        urls = {
            "follower_info_url": follower_info_url,
            "following_info_url": following_info_url,
            "post_info_url": post_info_url,
        }
        return urls


class UserListSerializer(serializers.ModelSerializer):
    urls = serializers.SerializerMethodField()

    class Meta:
        model=User
        fields = [
            'id',
            'username',
            'profilePicUrl',
            'is_verified',
            'urls',
        ]
    
    def get_urls(self, user):
        """
        Get useful urls.
        """
        user_info_url = "/apis/v1/users/operation/?userId=%s" % user.id
        urls = {
            "user_info_url": user_info_url,
        }
        return urls


class ConnectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Connection
        fields = [
            'id',
            'userId',
            'username',
            'is_verified',
            'profilePicUrl',
            'is_following',
            'urls',
        ]
        abstract = True


class FollowerSerializer(ConnectionSerializer):
    userId = serializers.ReadOnlyField(source="user_id_id")
    username = serializers.ReadOnlyField(source="user_id.username")
    is_verified = serializers.ReadOnlyField(source="user_id.is_verified")
    profilePicUrl = serializers.ImageField(source="user_id.profilePicUrl", read_only=True)
    is_following = serializers.SerializerMethodField()
    urls = serializers.SerializerMethodField()

    def get_is_following(self, connection):
        """
        Check if current user has liked the post or not.
        """
        if not self.context: return False
        following_users = self.context.get("following_users")
        return True if connection.user_id_id in following_users else False

    def get_urls(self, connection):
        """
        Get useful urls
        """
        user_info_url = "/apis/v1/users/operation/?userId=%s" % connection.user_id_id
        urls = {
            "user_info_url": user_info_url,
        }
        return urls
    
    
class FollowingSerializer(ConnectionSerializer):
    userId = serializers.ReadOnlyField(source="following_user_id_id")
    username = serializers.ReadOnlyField(source="following_user_id.username")
    is_verified = serializers.ReadOnlyField(source="following_user_id.is_verified")
    profilePicUrl = serializers.ImageField(source="following_user_id.profilePicUrl", read_only=True)
    is_following = serializers.BooleanField(default=True, read_only=True)
    urls = serializers.SerializerMethodField()

    def get_urls(self, connection):
        """
        Get useful urls
        """
        user_info_url = "/apis/v1/users/operation/?userId=%s" % connection.following_user_id_id
        urls = {
            "user_info_url": user_info_url,
        }
        return urls
    