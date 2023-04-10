from rest_framework import serializers
from .models import  Post


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model=Post
        fields = [
            "id",
            "caption",
            "description",
            "postPicUrl",
            "created_at",
            "updated_at",
            "userId",
        ]
        extra_kwargs={"userId": {"write_only":True}}