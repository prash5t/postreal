from typing import Tuple, Dict, Any

from django.http import HttpRequest
from django.core.paginator import Paginator
from django.db.models.query import QuerySet

from post_real.apps.users.models import User


def get_liked_post_of_user(user:User) -> Dict[str, Any]:
    """
    Get list of post id that are like by authenticated user.
    """
    liked_post_of_user = list(user.like_user.values_list("postId", flat=True))
    context = {"liked_post_of_user": liked_post_of_user}
    return context


def get_following_user(user:User) -> Dict[str, Any]:
    """
    Get list of user ids whom are followed by authenticated user.
    """
    following_users = list(user.connection_user.values_list("following_user_id", flat=True))
    context = {"following_users": following_users}
    return context


def paginate_queryset(paginator: Paginator, queryset: QuerySet, request: HttpRequest) -> Tuple[QuerySet, Dict[str, Any]]:
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