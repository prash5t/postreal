from rest_framework import serializers
from .models import  User, Connection


class UserSerializer(serializers.ModelSerializer):
    followers = serializers.SerializerMethodField()
    followers_info_url = serializers.SerializerMethodField()

    class Meta:
        model=User
        fields = [
            'username',
            'password',
            'email',
            'bio',
            'profilePicUrl',
            'phone_no',
            'is_verified',
            'followers',
            'followers_info_url',
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
    
    def get_followers_info_url(self, user):
        """
        Get followers info.
        """
        if not self.context: return None
        comment_info_url = "/apis/v1/users/follower-info/%s/" % user.id
        return comment_info_url


class ConnectionSerializer(serializers.ModelSerializer):
    userId = serializers.ReadOnlyField(source="user_id_id")
    username = serializers.ReadOnlyField(source="user_id.username")
    profilePicUrl = serializers.ImageField(source="user_id.profilePicUrl", read_only=True)
    
    class Meta:
        model = Connection
        fields = [
            "id",
            "userId",
            "username",
            "profilePicUrl"
        ]