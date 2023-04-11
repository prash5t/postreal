from .serializers import UserSerializer

from rest_framework import generics
from rest_framework import status

from post_real.core.log_and_response import generic_response, info_logger, log_exception, log_field_error


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
            payload = request.data

            serializer = self.serializer_class(data=payload)
            if serializer.is_valid():
                serializer.save()

                info_logger.info(f'New user registered: {serializer.data.get("username")}')
                return generic_response(
                    success=True,
                    message='User Registered Successfully',
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
            
            info_logger.warn(f'Field error / Bad request while registering new user')
            return log_field_error(serializer.errors)

        except Exception as err:
            return log_exception(err)


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
            return log_exception(err)


    def patch(self, request, *args, **kwargs):
        """
        Update details of authenticated user.
        """
        try: 
            payload = request.data
            authenticated_user = request.user
            
            payload._mutable = True
            keys_to_remove = ["email", "password"]
            for each in keys_to_remove: 
                if payload.get(each): payload.pop(each)
            payload._mutable = False
            
            serializer = self.serializer_class(authenticated_user, data=payload, partial=True)
            if serializer.is_valid():
                serializer.save()

                info_logger.info(f'User info updated for user: {authenticated_user.username}')
                return generic_response(
                    success=True,
                    message='User Info Updated',
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
            
            info_logger.warn(f'Field error / Bad Request while updating user: {authenticated_user.username}')
            return log_field_error(serializer.errors)

        except Exception as err:
            return log_exception(err)
    

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
            return log_exception(err)
