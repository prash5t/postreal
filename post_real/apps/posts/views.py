from django.http import Http404
from django.db import IntegrityError

from rest_framework import viewsets, status
from rest_framework.decorators import api_view

from .models import Post, Like, Comment
from .serializers import PostSerializer, LikeSerializer, CommentSerializer
from post_real.core.validation_form import CommentForm
from post_real.core.query_helper import get_liked_post_of_user
from post_real.core.authorization import check_user_access_on_post
from post_real.core.log_and_response import info_logger, generic_response, log_exception, log_field_error, post_not_found_error


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
                serialized_data = serializer.data
                keys_to_remove = ["total_likes", "total_comments", "has_liked", "like_info_url", "comment_info_url"]
                for key in keys_to_remove: serialized_data.pop(key)
                return generic_response(
                    success=True,
                    message='Post Created Successfully',
                    data=serialized_data,
                    status=status.HTTP_201_CREATED
                )
            
            info_logger.warn(f'Field error / Bad request from user: {authenticated_user.username} while creating post')
            return log_field_error(serializer.errors)
        
        except Exception as err:
            return log_exception(err)
        
    
    def list(self, request, *args, **kwargs):
        """
        List all the posts of authenticated user.
        """
        try:
            authenticated_user = request.user

            queryset = authenticated_user.post_user.prefetch_related('like_post', 'comment_post').order_by('-created_at') 
            liked_post_of_user = get_liked_post_of_user(authenticated_user)

            serializer = self.serializer_class(queryset, many=True, context=liked_post_of_user)

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

            liked_post_of_user = get_liked_post_of_user(authenticated_user)

            serializer = self.serializer_class(post_obj, context=liked_post_of_user)

            info_logger.info(f'Retrieve post info requested for user: {authenticated_user.username}, post:{post_obj.id}')
            return generic_response(
                success=True,
                message='Post Info',
                data=serializer.data,
                status=status.HTTP_200_OK
            )
        
        except Http404:
            info_logger.warn(f'Not existing post info requested for user: {authenticated_user.username}')
            return post_not_found_error()
        
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
                serialized_data = serializer.data
                keys_to_remove = ["total_likes", "total_comments", "has_liked", "like_info_url", "comment_info_url"]
                for key in keys_to_remove: serialized_data.pop(key)
                return generic_response(
                    success=True,
                    message='Post Updated',
                    data=serialized_data,
                    status=status.HTTP_200_OK
                )

            info_logger.warn(f'Field error / Bad Request from user: {authenticated_user.username} while updating post: {post_obj.id}')
            return log_field_error(serializer.errors)
        
        except Http404:
            info_logger.warn(f'Not existing post update requested for user: {authenticated_user.username}')
            return post_not_found_error()
        
        except Exception as err:
            return log_exception(err)
    

    def destroy(self, request, *args, **kwargs):
        """
        Delete post of authenticated user.
        """
        try:
            authenticated_user = request.user
            post_obj = self.get_object()

            result, has_access = check_user_access_on_post(authenticated_user, post_obj)
            if not has_access: return generic_response(**result)

            post_obj.delete()

            info_logger.info(f'Delete post requested for user: {authenticated_user.username}, post:{post_obj.id}')
            return generic_response(
                success=True,
                message='Post Deleted Successfully',
                status=status.HTTP_200_OK
            )
        
        except Http404:
            info_logger.warn(f'Not existing post delete requested for user: {authenticated_user.username}')
            return post_not_found_error()
        
        except Exception as err:
            return log_exception(err)
    

@api_view(["GET"])
def like_unlike_post(request, postId):
    """
    Like/Unlike post with post id.
    """
    try:
        authenticated_user = request.user
        
        Like.objects.create(postId_id=postId, liked_by=authenticated_user)
        info_logger.info(f'User: {authenticated_user.username} liked post: {postId}')
        return generic_response(
                    success=True,
                    message='Post Liked',
                    status=status.HTTP_200_OK
                )

    except IntegrityError:
        try: 
            Like.objects.get(postId_id=postId, liked_by=authenticated_user).delete()
            info_logger.info(f'User: {authenticated_user.username} unliked post: {postId}')
            return generic_response(
                    success=True,
                    message='Post Unliked',
                    status=status.HTTP_200_OK
                )
    
        except Like.DoesNotExist:
            info_logger.warn(f'User: {authenticated_user.username} tried to like non existing post: {postId}')
            return post_not_found_error()
    
    except Exception as err:
        return log_exception(err)


@api_view(["GET"])
def like_info(request, postId):
    """
    Get total likes and users who liked the post.
    """
    try:
        qs = Like.objects.filter(postId_id=postId).select_related('liked_by').order_by("-created_at")
        serializer = LikeSerializer(qs, many=True)
        info_logger.info(f'Like info requested by user: {request.user.username} for post: {postId}')
        return generic_response(
                    success=True,
                    message='Users Info Who Liked The Post',
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
    
    except Exception as err:
        return log_exception(err)


@api_view(["POST"])
def comment_on_post(request):
    """
    Comment on post.
    """
    try:
        authenticated_user = request.user

        form = CommentForm(request.data)
        if not form.is_valid():
            info_logger.warn(f'Field error / Bad Request from user: {authenticated_user.username} while commenting on post')
            return log_field_error(
                {
                "postId": ["This field is required.", "Field type must be int."],
                "comment": ["This field is required.", "Field type must be str.", "Max-lenght: 150"]
                }
            )
        
        post_id = form.cleaned_data["postId"]
        comment = form.cleaned_data["comment"]

        Comment.objects.create(comment=comment, postId_id=post_id, commented_by=authenticated_user)
        info_logger.info(f'User: {authenticated_user.username} commented on post: {post_id}')
        return generic_response(
                success=True,
                message='Comment Posted',
                status=status.HTTP_201_CREATED
            )
    
    except IntegrityError:
        info_logger.warn(f'User: {authenticated_user.username} tried to comment on non existing post: {post_id}')
        return post_not_found_error()
    
    except Exception as err:
        return log_exception(err)


@api_view(["GET"])
def comment_info(request, postId):
    """
    Get total likes and users who liked the post.
    """
    try:
        qs = Comment.objects.filter(postId_id=postId).select_related('commented_by').order_by("-created_at")
        serializer = CommentSerializer(qs, many=True)
        info_logger.info(f'Comment info requested by user: {request.user.username} for post: {postId}')
        return generic_response(
                    success=True,
                    message="Comments With User Info",
                    data=serializer.data,
                    status=status.HTTP_200_OK
                )
    
    except Exception as err:
        return log_exception(err)