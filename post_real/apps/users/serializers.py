from rest_framework import serializers
from .models import  User, Connection


class UserSerializer(serializers.ModelSerializer):
    followers = serializers.SerializerMethodField()
    following = serializers.SerializerMethodField()
    followers_info_url = serializers.SerializerMethodField()
    following_info_url = serializers.SerializerMethodField()

    class Meta:
        model=User
        fields = [
            "id",
            'username',
            'password',
            'email',
            'bio',
            'profilePicUrl',
            'phone_no',
            'is_verified',
            'followers',
            'following',
            'followers_info_url',
            'following_info_url',
        ]
        extra_kwargs = {'password': {'write_only': True}}
        
    def create(self, validated_data):  
        """
        Validate data and create user.
        """
        user = User.objects.create_user(**validated_data)
        return user

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
    
    def get_followers_info_url(self, user):
        """
        Get followers info.
        """
        if not self.context: return None
        follower_info_url = "/apis/v1/users/follower-info/%s/" % user.id
        return follower_info_url

    def get_following_info_url(self, user):
        """
        Get following info.
        """
        if not self.context: return None
        following_info_url = "/apis/v1/users/following-info/%s/" % user.id
        return following_info_url


class ConnectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Connection
        fields = [
            "id",
            "userId",
            "username",
            "profilePicUrl"
        ]
        abstract = True


class FollowerSerializer(ConnectionSerializer):
    userId = serializers.ReadOnlyField(source="user_id_id")
    username = serializers.ReadOnlyField(source="user_id.username")
    profilePicUrl = serializers.ImageField(source="user_id.profilePicUrl", read_only=True)
    

class FollowingSerializer(ConnectionSerializer):
    userId = serializers.ReadOnlyField(source="following_user_id_id")
    username = serializers.ReadOnlyField(source="following_user_id.username")
    profilePicUrl = serializers.ImageField(source="following_user_id.profilePicUrl", read_only=True)
    