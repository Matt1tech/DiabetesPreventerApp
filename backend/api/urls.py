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
    path('physical_record/', views.physical_record, name='physical_record'),
    path('update-customization/', views.update_preferences, name='update_preferences'),
]
    
    