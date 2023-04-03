from django.db.models import Q
from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend


class EmailAndUsernameBackend(ModelBackend):
    '''
    Login with email or username
    '''
    def authenticate(self, request, username=None, password=None, **kwargs):
        UserModel = get_user_model()

        if username is None:
            username = kwargs.get(UserModel.USERNAME_FIELD)
        try:
            user = UserModel.objects.get(Q(email=username) | Q(username=username))
        except UserModel.DoesNotExist:
            UserModel().set_password(password)
        else:
            if user.check_password(password) and self.user_can_authenticate(user):
                return user
