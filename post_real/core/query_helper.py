from post_real.apps.users.models import User

def get_liked_post_of_user(user:User):
    liked_post_of_user = list(user.like_user.values_list("postId", flat=True))
    context = {"liked_post_of_user": liked_post_of_user}
    return context