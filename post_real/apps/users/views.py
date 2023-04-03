from .serializers import UserSerializer

from rest_framework import generics
from rest_framework import status
from rest_framework.response import Response


class UserRegisterView(generics.CreateAPIView):
    """
    View to create user.
    """
    serializer_class = UserSerializer
    permission_classes = []


class UserDetailApiView(generics.GenericAPIView):
    """
    View to list details of user.
    """
    serializer_class = UserSerializer

    def get (self, request, *args, **kwargs):
        authenticated_user = request.user
        serializer = self.serializer_class(authenticated_user)
        return Response({'success': True, 'data': serializer.data}, status=status.HTTP_200_OK)  
