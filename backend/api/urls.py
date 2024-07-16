# In your urls.py
from django.urls import path
#from .views import register, MyTokenObtainPairView
from . import views

from django.urls import path
#from .views import register, login

urlpatterns = [
    path('',views.getRoutes),
    path('user_data/', views.getUsers),
    path('user_data/<str:pk>/', views.getUser),
   # path('register/', register, name='register'),
    #path('login/', login, name='login'),
    #path('api/token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),  
]
