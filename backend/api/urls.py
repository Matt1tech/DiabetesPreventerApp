# In your urls.py
from django.urls import path
#from .views import register, MyTokenObtainPairView
from . import views

from django.urls import path
#from .views import register, login

urlpatterns = [

    path('create_user/', views.create_user, name='create_user'),
    path('login/', views.login, name='login'),
    path('user_details/', views.user_details, name='user_details'),
    path('logout/', views.logout, name='logout'),
    path('user/<int:user_id>/last_health_record/', views.get_last_health_record, name='last_health_record'),
    path('api/user/<int:user_id>/last_health_record/', views.get_last_health_record, name='last_health_record'),
]
    #path('latest-record/', views.latest_record, name='latest_record'),
    

    #path('',views.getRoutes),
    #path('users/', views.getUsers),
    #path('users/<str:pk>/getemail/', views.getUserEmail),
    #path('users/<str:pk>/update/', views.updateUser),
    #path('users/<str:pk>/delete-profile-picture/', views.deleteUserProfilePicture),
    #path('users/<str:pk>/', views.getUser),
    #path('users/<str:pk>/createUserData/', views.createUserData),