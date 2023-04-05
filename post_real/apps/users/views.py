from .serializers import UserSerializer

from rest_framework import generics
from rest_framework import status

from post_real.core.log_and_response import generic_response, info_logger, error_logger


class UserRegisterView(generics.CreateAPIView):
    """
    View to create user.
    """
    serializer_class = UserSerializer
    permission_classes = []

    def post(self, request, *args, **kwargs):
        """
        Register new user.
        """
        try: 
            serializer = self.serializer_class(data=request.data)
            if serializer.is_valid():
                serializer.save()

                info_logger.info(f'New user registered: {serializer.data.get("username")}')
                return generic_response(
                    success=True,
                    message='User Registered Successfully',
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
            
            info_logger.info(f'Field error / Bad request while registering new user')
            return generic_response(
                success=False,
                message='Invalid Input / Field Error',
                data=serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

        except Exception as err:
            error_logger.error(err)
            return generic_response(
                success=False,
                message="Something Went Wrong!",
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


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

            info_logger.info(f'User info requested for user: {serializer.data.get("username")}')
            return generic_response(
                success=True,
                message='User Info',
                data=serializer.data,
                status=status.HTTP_200_OK
            )
        
        except Exception as err:
            error_logger.error(err)
            return generic_response(
                success=False,
                message="Something Went Wrong!",
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


    def patch(self, request, *args, **kwargs):
        """
        Update details of authenticated user.
        """
        try: 
            authenticated_user = request.user
            
            keys_to_remove = ["email", "username", "password"]
            request.data._mutable = True
            for each in keys_to_remove: 
                if request.data.get(each): request.data.pop(each)
            request.data._mutable = False
            
            serializer = self.serializer_class(authenticated_user, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()

                info_logger.info(f'User info updated for user: {serializer.data.get("username")}')
                return generic_response(
                    success=True,
                    message='User Info Updated',
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
            
            info_logger.info(f'Field error while updating user: {authenticated_user.username}')
            return generic_response(
                success=False,
                message='Invalid Input/Field Error',
                data=serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

        except Exception as err:
            error_logger.error(err)
            return generic_response(
                success=False,
                message="Something Went Wrong!",
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    

    def delete(self, request, *args, **kwargs):
        """
        Delete authenticated user.
        """
        try: 
            authenticated_user = request.user
            authenticated_user.delete()

            info_logger.info(f'User deleted: {authenticated_user.username}')
            return generic_response(
                success=True,
                message='User Deleted Successfully',
                status=status.HTTP_200_OK
            )

        except Exception as err:
            error_logger.error(err)
            return generic_response(
                success=False,
                message="Something Went Wrong!",
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
