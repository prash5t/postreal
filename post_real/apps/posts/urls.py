from . import views
from rest_framework import routers
from django.urls import include, path

router = routers.DefaultRouter()
router.register(r'operation', views.PostViewSet, basename="post_operation")


urlpatterns = [
    path('', include(router.urls)),
    path('like/', views.like, name="like_post")
]