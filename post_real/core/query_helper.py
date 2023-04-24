from post_real.apps.users.models import User


def get_liked_post_of_user(user:User):
    """
    Get list of post id that are like by authenticated user.
    """
    liked_post_of_user = list(user.like_user.values_list("postId", flat=True))
    context = {"liked_post_of_user": liked_post_of_user}
    return context


def get_following_user(user:User):
    """
    Get list of user ids whom are followed by authenticated user.
    """
    following_users = list(user.connection_user.values_list("following_user_id", flat=True))
    context = {"following_users": following_users}
    return context


def paginate_queryset(paginator, queryset, request):
    """
    Paginate queryset and get paginated response.
    """
    result = paginator.paginate_queryset(queryset, request)
    paginator_data = {
        'count': paginator.page.paginator.count,
        'next': paginator.get_next_link(),
        'previous': paginator.get_previous_link()
    }
    return result, paginator_data