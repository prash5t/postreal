from rest_framework import status
from rest_framework import serializers
from rest_framework_simplejwt.views import TokenViewBase
from post_real.core.log_and_response import generic_response
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class TokenObtainSerializer(TokenObtainPairSerializer):
    """
    Overriding TokenObtainPairSerializer for email verification before obtaining JWT tokens (access and refresh).
    """

    def validate(self, attrs):
        data = super().validate(attrs)
        user = self.user
        if not user.is_email_verified:
            raise serializers.ValidationError({
                "detail": "This account is not verified. Please verify your email first."
            })
        return data


class TokenObtainPairView(TokenViewBase):
    """
    Return JWT tokens (access and refresh).
    """
    serializer_class = TokenObtainSerializer

    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)
        token = response.data.get('access', None)
        if not token: return response
        return generic_response( 
            success=True,
            message='Token Obtained Successfully',
            data=response.data,
            status=status.HTTP_200_OK
        )