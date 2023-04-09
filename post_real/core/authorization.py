from rest_framework import status

def check_user_access_on_post(user:object, post:object):
    if post.userId != user:
        return {'success': False, 'message': "User does not have permission to access the requested data", 'status': status.HTTP_401_UNAUTHORIZED}, False
    return {}, True