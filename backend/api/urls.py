# In your urls.py
from django.urls import path
#from .views import register, MyTokenObtainPairView
from . import views

from django.urls import path
#from .views import register, login

urlpatterns = [

    path('create_user/', views.create_user, name='create_user'),
    path('create_preferences/', views.create_preferences, name='create_preferences'),
    path('list_users/', views.list_users, name='list_users'),
    path('list_user_preferences/<int:pk>/', views.list_user_preferences, name='list_user_preferences'),
    path('login/', views.login, name='login'),
    path('user_details/', views.user_details, name='user_details'),
]
    #path('latest-record/', views.latest_record, name='latest_record'),
    

    #path('',views.getRoutes),
    #path('users/', views.getUsers),
    #path('users/<str:pk>/getemail/', views.getUserEmail),
    #path('users/<str:pk>/update/', views.updateUser),
    #path('users/<str:pk>/delete-profile-picture/', views.deleteUserProfilePicture),
    #path('users/<str:pk>/', views.getUser),
    #path('users/<str:pk>/createUserData/', views.createUserData),