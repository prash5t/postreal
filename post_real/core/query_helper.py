from post_real.apps.users.models import User

def get_liked_post_of_user(user:User):
    liked_post_of_user = list(user.like_user.values_list("postId", flat=True))
    context = {"liked_post_of_user": liked_post_of_user}
    return context


def get_following_user(user:User):
    following_users = list(user.connection_user.values_list("following_user_id", flat=True))
    context = {"following_users": following_users}
    return context