# In your urls.py
from django.urls import path
from .views import register, MyTokenObtainPairView

from django.urls import path
from .views import register, login

urlpatterns = [
    path('register/', register, name='register'),
    path('login/', login, name='login'),
    path('api/token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
]
