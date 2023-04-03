from rest_framework import viewsets, status
from rest_framework import generics
from .serializers import UserSerializer

class UserRegisterView(generics.CreateAPIView):
    """
    View that allows users to be created.
    """
    serializer_class = UserSerializer

