from django.db import IntegrityError

from rest_framework import status
from rest_framework import generics
from rest_framework.decorators import api_view

from .models import Connection, User
from post_real.core.custom_pagination import UserListPagination
from post_real.core.validation_form import UserIdValidationForm
from post_real.core.query_helper import get_following_user, paginate_queryset
from .serializers import UserSerializer, UserListSerializer, FollowerSerializer, FollowingSerializer
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

                serialized_data = serializer.data
                keys_to_remove = ["followers", "following", "is_following", "urls"]
                for key in keys_to_remove: serialized_data.pop(key)

                info_logger.info(f'New user registered: {serialized_data.get("username")}')
                return generic_response(
                    success=True,
                    message='User Registered Successfully',
                    data=serialized_data,
                    status=status.HTTP_200_OK
                )
            
            info_logger.warn(f'Field error / Bad request while registering new user')
            return log_field_error(serializer.errors)

        except Exception as err:
            return log_exception(err)


class UserListView(generics.ListAPIView):
    """
    View to search user.
    """
    queryset = User.objects.all()
    serializer_class = UserListSerializer
    pagination_class = UserListPagination

    search_fields = ['username']
    filterset_fields = {'username': ['in'], 'email':['in']} 

    def list(self, request, *args, **kwargs):
        """
        Search user.
        """
        try:
            result= None
            additional_data = None
            if any(value.strip() for value in request.query_params.values()):
                queryset = self.get_queryset()
                filtered_queryset = self.filter_queryset(queryset)

                paginator = self.pagination_class()
                result, additional_data = paginate_queryset(paginator, filtered_queryset, request)
            
            serializer = self.serializer_class(result, many=True)
            info_logger.info(f'User: {request.user.username} searched users')
            return generic_response(
                success=True,
                message='User Info',
                data=serializer.data,
                additional_data=additional_data,
                status=status.HTTP_200_OK
            )
        
        except Exception as err:
            return log_exception(err)


class UserOperationView(generics.GenericAPIView):
    """
    View to list details of user, update and delete user.
    """
    serializer_class = UserSerializer


    def get(self, request, *args, **kwargs):
        """
        List details of authenticated user.
        """
        try:
            user = request.user

            if userId:=request.query_params.get("userId"):
                form = UserIdValidationForm({"userId":userId})
                if not form.is_valid():
                    info_logger.warn(f'Field error / Bad Request from user: {user.username} while requesting user info.')
                    return log_field_error(
                        {"userId": ["Invalid uuid!"]}
                    )
                user_id = form.cleaned_data['userId']
                user = User.objects.get(id=user_id)

            following_users = get_following_user(request.user)
            serializer = self.serializer_class(user, context=following_users)

            info_logger.info(f'User: {request.user.username} requested details of user: {user.username}')
            return generic_response(
                success=True,
                message='User Info',
                data=serializer.data,
                status=status.HTTP_200_OK
            )

        except User.DoesNotExist:
            info_logger.warn(f'User: {user.username} tried to list details of non existing user')
            return generic_response(
                success=False,
                message="User Doesn't Exists!",
                status=status.HTTP_404_NOT_FOUND
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

                serialized_data = serializer.data
                keys_to_remove = ["followers", "following", "is_following", "urls"]
                for key in keys_to_remove: serialized_data.pop(key)

                info_logger.info(f'User info updated for user: {authenticated_user.username}')
                return generic_response(
                    success=True,
                    message='User Info Updated',
                    data=serialized_data,
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

        form = UserIdValidationForm({"userId":userId})
        if not form.is_valid():
            info_logger.warn(f'Field error / Bad Request from user: {authenticated_user.username} while following user')
            return log_field_error(
                {"userId": ["Invalid uuid!"]}
            )

        following_user_id = form.cleaned_data['userId']
        if following_user_id == authenticated_user.id:
            info_logger.info(f'User: {authenticated_user.username} tried to follow themselves.')
            return generic_response(
                success=False,
                message="User cannot follow themselves!",
                status=status.HTTP_400_BAD_REQUEST
            )
            
        result = Connection.objects.create(user_id=authenticated_user, following_user_id_id=following_user_id)
        info_logger.info(f'User: {authenticated_user.username} started following user: {result.following_user_id.username}')
        return generic_response(
                success=True,
                message='Started Following User @%s' % result.following_user_id.username,
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


@api_view(["GET"])
def follower_info(request, userId):
    """
    Get followers info of user.
    """
    try:
        form = UserIdValidationForm({"userId":userId})
        if not form.is_valid():
            info_logger.warn(f'Field error / Bad Request from user: {request.user.username} while requesting followers info.')
            return log_field_error(
                {"userId": ["Invalid uuid!"]}
            )
        
        userId = form.cleaned_data['userId']
        result = Connection.objects.filter(following_user_id=userId).select_related("user_id").order_by("-created_at")
        following_users = get_following_user(request.user)

        serializer = FollowerSerializer(result, many=True, context=following_users)
        info_logger.info(f'Follower info requested by user: {request.user.username} of user: {userId}')
        return generic_response(
                    success=True,
                    message="Followers Info",
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
    
    except Exception as err:
        return log_exception(err)
    

@api_view(["GET"])
def following_info(request, userId):
    """
    Get following info of user.
    """
    try:
        form = UserIdValidationForm({"userId":userId})
        if not form.is_valid():
            info_logger.warn(f'Field error / Bad Request from user: {request.user.username} while requesting following info.')
            return log_field_error(
                {"userId": ["Invalid uuid!"]}
            )
        
        userId = form.cleaned_data['userId']
        result = Connection.objects.filter(user_id=userId).select_related("following_user_id").order_by("-created_at")

        serializer = FollowingSerializer(result, many=True)
        info_logger.info(f'Following users info requested by user: {request.user.username} of user: {userId}')
        return generic_response(
                    success=True,
                    message="Following Users Info",
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
    
    except Exception as err:
        return log_exception(err)