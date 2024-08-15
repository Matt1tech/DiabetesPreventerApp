from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('create_user/', views.create_user, name='create_user'),
    path('login/', views.login, name='login'),
    path('logout/', views.logout, name='logout'),
    path('update_user/', views.update_user_profile, name='update_user'),
    path('health-record/', views.create_or_update_health_record, name='create_or_update_health_record'),
    path('health-record/last/<int:user_id>/', views.get_last_health_record, name='get_last_health_record'),
    path('create_meal/', views.create_meal, name='create_meal'),
    path('total_daily_nutrition/<int:user_id>/', views.get_total_daily_nutrition, name='daily_nutrition'),
    path('physical_record/', views.physical_record, name='physical_record'),
    path('update-customization/', views.update_customizations, name='update-customization'),
    path('get-user-customization/<int:user_id>/', views.get_user_customization, name='get-user-customization'),
    path('test_model/', views.test_model, name='test_model'),
    path('request_otp/', views.request_otp, name='request_otp'),
    path('verify_otp/', views.verify_otp, name='verify_otp'),
    #path('recommendations/', views.recommendation_list, name='recommendation-list'),
    path('user_recommendations/<int:user_id>/', views.user_recommendation, name='user_recommendation'),
    path('monthly_risk/<int:user_id>/', views.monthly_risk, name='monthly_risk'),
    path('activity_report/<int:user_id>/', views.get_physical_activity_report, name='get_physical_activity_report'),
    path('risk_summary_report/<int:user_id>/', views.get_risk_summary_report, name='get_risk_summary_report'),
    path('health_summary_report/<int:user_id>/', views.get_health_summary_report, name='get_risk_summary_report'),


    
]
