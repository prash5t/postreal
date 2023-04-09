from . import views
from rest_framework import routers
from django.urls import include, path

router = routers.DefaultRouter()
# router.register(r'users', views.UserViewSet, basename="users")


urlpatterns = [
    # path('', include(router.urls)),
    path('register/', views.UserRegisterView.as_view(), name='register_user'),
    path('detail/', views.UserListUpdateDeleteView.as_view(), name='user_details'),
]