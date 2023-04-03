from rest_framework import viewsets, status
from rest_framework import generics
from .serializers import UserSerializer


class UserRegisterView(generics.CreateAPIView):
    """
    View to create user.
    """
    serializer_class = UserSerializer
    permission_classes = []
