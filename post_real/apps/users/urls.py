from . import views
from django.urls import path


urlpatterns = [
    path('register/', views.UserRegisterView.as_view(), name='register_user'),
    path('operation/', views.UserListUpdateDeleteView.as_view(), name='user_operation'),
    path('follow-unfollow/', views.follow_unfollow_user, name='follow_unfollow_user'),
]