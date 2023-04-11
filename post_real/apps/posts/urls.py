from . import views
from rest_framework import routers
from django.urls import include, path

router = routers.DefaultRouter()
router.register(r'operation', views.PostViewSet, basename="post_operation")


urlpatterns = [
    path('', include(router.urls)),
    path('like/', views.like_post, name="like_post"),
    path('comment/', views.comment_on_post, name="comment_on_post")
]