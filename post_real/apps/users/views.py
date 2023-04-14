from django.db import IntegrityError

from rest_framework import status
from rest_framework import generics
from rest_framework.decorators import api_view


from .models import Connection
from .serializers import UserSerializer
from post_real.core.validation_form import FollowUnfollowForm
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
            
            info_logger.warn(f'Field error / Bad Request from user: {authenticated_user.username} while updating user info')
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


@api_view(["GET"])
def follow_unfollow_user(request, userId):
    """
    Follow/Unfollow user with user id.
    """
    try:
        authenticated_user = request.user

        form = FollowUnfollowForm({"userId":userId})
        if not form.is_valid():
            info_logger.warn(f'Field error / Bad Request from user: {authenticated_user.username} while following user')
            return log_field_error(
                {"userId": ["Invalid uuid!"]}
            )

        following_user_id = form.cleaned_data['userId']
            
        connection_obj = Connection.objects.create(user_id=authenticated_user, following_user_id_id=following_user_id)
        info_logger.info(f'User: {authenticated_user.username} started following user: {connection_obj.following_user_id.username}')
        return generic_response(
                success=True,
                message='Started Following User @%s' % connection_obj.following_user_id.username,
                status=status.HTTP_200_OK
            )
    
    except IntegrityError:
        try: 
            Connection.objects.get(user_id=authenticated_user, following_user_id_id=following_user_id).delete()
            info_logger.info(f'User: {authenticated_user.username} unfollowed user: {following_user_id}')
            return generic_response(
                    success=True,
                    message='Unfollowed Given User',
                    status=status.HTTP_200_OK
                )

        except Connection.DoesNotExist:
            info_logger.warn(f'User: {authenticated_user.username} tried to follow non existing user: {following_user_id}')
            return generic_response(
                success=False,
                message="User Doesn't Exists!",
                status=status.HTTP_404_NOT_FOUND
            )

    except Exception as err:
        return log_exception(err)