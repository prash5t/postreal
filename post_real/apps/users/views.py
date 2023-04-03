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


class UserListUpdateDeleteView(generics.GenericAPIView):
    """
    View to list details of user, update and delete user.
    """
    serializer_class = UserSerializer


    def get(self, request, *args, **kwargs):
        """
        List details of authenticated user.
        """
        try:
            authenticated_user = request.user
            serializer = self.serializer_class(authenticated_user)
            return Response({'success': True, 'data': serializer.data}, status=status.HTTP_200_OK)  
        
        except Exception as err:
            print(err)
            return Response({'success': False, 'data': err}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


    def patch(self, request, *args, **kwargs):
        """
        Update details of authenticated user.
        """
        try: 
            authenticated_user = request.user
            
            keys_to_remove = ["email", "username", "password"]
            for each in keys_to_remove: 
                if request.data.get(each): request.data.pop(each)
            
            serializer = self.serializer_class(authenticated_user, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'success': True, 'data': serializer.data}, status=status.HTTP_200_OK)

            return Response({'success': False, 'data': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            print(err)
            return Response({'success': False, 'data': err}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    

    def delete(self, request, *args, **kwargs):
        """
        Delete authenticated user.
        """
        try: 
            authenticated_user = request.user
            authenticated_user.delete()
            return Response({'success': True, 'data': "Successfully deleted user"}, status=status.HTTP_200_OK)

        except Exception as err:
            print(err)
            return Response({'success': False, 'data': err}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
