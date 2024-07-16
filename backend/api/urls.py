# In your urls.py
from django.urls import path
#from .views import register, MyTokenObtainPairView
from . import views

from django.urls import path
#from .views import register, login

urlpatterns = [
    path('',views.getRoutes),
    path('users/', views.getUsers),
    path('users/create/', views.createUser),
    path('users/<str:pk>/update/', views.updateUser),
    path('users/<str:pk>/delete-profile-picture/', views.deleteUserProfilePicture),
    path('users/<str:pk>/', views.getUser),
    
]