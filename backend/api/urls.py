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
    path('health-record/', views.create_or_update_health_record, name='create_or_update_health_record'),
    path('health-record/last/<int:user_id>/', views.get_last_health_record, name='get_last_health_record'),
    path('create_meal/', views.create_meal, name='create_meal'),
    path('total_daily_nutrition/<int:user_id>/', views.get_total_daily_nutrition, name='daily_nutrition/'),
]
    
    

    #path('',views.getRoutes),
    #path('users/', views.getUsers),
    #path('users/<str:pk>/getemail/', views.getUserEmail),
    #path('users/<str:pk>/update/', views.updateUser),
    #path('users/<str:pk>/delete-profile-picture/', views.deleteUserProfilePicture),
    #path('users/<str:pk>/', views.getUser),
    #path('users/<str:pk>/createUserData/', views.createUserData),