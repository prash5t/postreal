from rest_framework import serializers
from .models import  User


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
        ]
        extra_kwargs = {'password': {'write_only': True}}
        
    def create(self, validated_data):  
        user = User.objects.create_user(**validated_data)
        return user