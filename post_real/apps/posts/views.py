from django.http import Http404

from rest_framework import viewsets, status

from .models import Post
from .serializers import PostSerializer
from post_real.core.authorization import check_user_access_on_post
from post_real.core.log_and_response import generic_response, info_logger, log_exception, log_field_error


class PostViewSet(viewsets.ModelViewSet):
    """
    View for post related operations.
    """
    queryset = Post.objects.all()
    serializer_class = PostSerializer


    def create(self, request, *args, **kwargs):
        """
        Create Post
        """
        try: 
            payload = request.data
            authenticated_user = request.user

            payload._mutable = True
            payload["userId"] = authenticated_user.id
            payload._mutable = False

            serializer = self.serializer_class(data=payload)
            if serializer.is_valid():
                serializer.save()

                info_logger.info(f'Post created: {serializer.data.get("id")}')
                return generic_response(
                    success=True,
                    message='Post Created Successfully',
                    data=serializer.data,
                    status=status.HTTP_201_CREATED
                )
            
            info_logger.warn(f'Field error / Bad request while creating post for user: {authenticated_user.username}')
            return log_field_error(serializer.errors)
        
        except Exception as err:
            return log_exception(err)
        
    
    def list(self, request, *args, **kwargs):
        """
        List all the posts of authenticated user.
        """
        try:
            authenticated_user = request.user
            queryset = authenticated_user.post_set.order_by("-created_at")

            serializer = self.serializer_class(queryset, many=True)

            info_logger.info(f'Posts info requested for user: {authenticated_user.username}')
            return generic_response(
                success=True,
                message='Posts Info',
                data=serializer.data,
                status=status.HTTP_200_OK
            )
        
        except Exception as err:
            return log_exception(err)
    

    def retrieve(self, request, *args, **kwargs):
        """
        Retrieve specific post of authenticated user.
        """
        try:
            authenticated_user = request.user
            post_obj = self.get_object()

            result, has_access = check_user_access_on_post(authenticated_user, post_obj)
            if not has_access: return generic_response(**result)

            serializer = self.serializer_class(post_obj)

            info_logger.info(f'Retrieve post info requested for user: {authenticated_user.username}, post:{post_obj.id}')
            return generic_response(
                success=True,
                message='Post Info',
                data=serializer.data,
                status=status.HTTP_200_OK
            )
        
        except Http404:
            info_logger.warn(f'Not existing post info requested for user: {authenticated_user.username}')
            return generic_response(
                success=False,
                message="Post Doesn't Exists!",
                status=status.HTTP_404_NOT_FOUND
            )
        
        except Exception as err:
            return log_exception(err)
    

    def update(self, request, *args, **kwargs):
        """
        Update post of authenticated user.
        """
        try:
            authenticated_user = request.user
            post_obj = self.get_object()
            payload = request.data

            result, has_access = check_user_access_on_post(authenticated_user, post_obj)
            if not has_access: return generic_response(**result)

            payload._mutable = True
            if payload.get("postPicUrl"): payload.pop("postPicUrl")
            payload._mutable = False

            serializer = self.serializer_class(post_obj, data=payload, partial=True)
            if serializer.is_valid():
                self.perform_update(serializer)

                info_logger.info(f'Post info updated for user: {authenticated_user.username}, post: {post_obj.id}')
                return generic_response(
                    success=True,
                    message='Post Updated',
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )

            info_logger.warn(f'Field error / Bad Request while updating post: {post_obj.id} for user: {authenticated_user.username}')
            return log_field_error(serializer.errors)
        
        except Http404:
            info_logger.warn(f'Not existing post update requested for user: {authenticated_user.username}')
            return generic_response(
                success=False,
                message="Post Doesn't Exists!",
                status=status.HTTP_404_NOT_FOUND
            )
        
        except Exception as err:
            return log_exception(err)