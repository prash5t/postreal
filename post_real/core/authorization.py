from typing import Tuple, Dict, Any

from rest_framework import status

from post_real.apps.users.models import User
from post_real.apps.posts.models import Post
from post_real.core.log_and_response import info_logger


def check_user_access_on_post(user:User, post:Post) -> Tuple[Dict[str, Any], bool]:
    """
    Verify user if they are updating/deleting post of self.
    Restricts user from updating/deleting post of other users.
    """
    if post.userId != user:
        info_logger.warn(f'Unauthorized post update requested for user: {user.username}, post: {post.id}')
        return {'success': False, 'message': "User does not have permission to access the requested data", 'status': status.HTTP_401_UNAUTHORIZED}, False
    return {}, True