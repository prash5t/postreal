from rest_framework import status
from post_real.core.log_and_response import info_logger


def check_user_access_on_post(user:object, post:object):
    if post.userId != user:
        info_logger.warn(f'Unauthorized post update requested for user: {user.username}, post: {post.id}')
        return {'success': False, 'message': "User does not have permission to access the requested data", 'status': status.HTTP_401_UNAUTHORIZED}, False
    return {}, True