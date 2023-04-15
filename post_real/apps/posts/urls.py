from . import views
from rest_framework import routers
from django.urls import include, path

router = routers.DefaultRouter()
router.register(r'operation', views.PostViewSet, basename="post_operation")


urlpatterns = [
    path('', include(router.urls)),
    path('feed/', views.feed, name="timeline_feed"),
    path('like-unlike/<int:postId>/', views.like_unlike_post, name="like_unlike_post"),
    path('like-info/<int:postId>/', views.like_info, name="like_info_of_post"),
    path('comment/', views.comment_on_post, name="comment_on_post"),
    path('comment-info/<int:postId>/', views.comment_info, name="comment_info_of_post"),
]