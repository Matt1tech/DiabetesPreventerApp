# api/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('users/', views.UserListView.as_view(), name='user-list'),
    path('users/create/', views.CreateUserView.as_view(), name='user-create'),
    path('users/<pk>/', views.UserDetailView.as_view(), name='user-detail'),
]
