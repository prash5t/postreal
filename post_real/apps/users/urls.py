from . import views
from django.urls import path


urlpatterns = [
    path('register/', views.UserRegisterView.as_view(), name='register_user'),
    path('operation/', views.UserOperationView.as_view(), name='user_operation'),
    path('follow-unfollow/<str:userId>/', views.follow_unfollow_user, name='follow_unfollow_user'),
    path('follower-info/<str:userId>/', views.follower_info, name='followers_info_of_user'),
    path('following-info/<str:userId>/', views.following_info, name='following_info_of_user'),
]