from rest_framework import serializers
from .models import  User, Connection


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model=User
        fields = [
            'username',
            'password',
            'email',
            'bio',
            'profilePicUrl',
            'phone_no',
            'is_verified'
        ]
        extra_kwargs = {'password': {'write_only': True}}
        
    def create(self, validated_data):  
        user = User.objects.create_user(**validated_data)
        return user


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