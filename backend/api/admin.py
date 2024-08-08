# users/admin.py
from django.contrib import admin
from .models import *


# Register your models here.

@admin.register(Customizations)
class CustomizationsAdmin(admin.ModelAdmin):
    list_display = ('user', 'daily_calories_max', 'created_at')
    search_fields = ('user__name', 'user__email')
    list_filter = ('meals_per_day', 'allergies', 'diets_followed', 'created_at')
    ordering = ('-created_at',)

@admin.register(HealthRecord)
class HealthRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'blood_glucose', 'blood_pressure', 'bmi', 'weight', 'diabetes_risk', 'created_at')
    search_fields = ('user__name', 'user__email')
    list_filter = ('blood_glucose', 'blood_pressure', 'bmi', 'weight', 'diabetes_risk', 'created_at')
    ordering = ('-created_at',)

@admin.register(PhysicalRecord)
class PhysicalRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'type', 'duration', 'stress_level', 'created_at')
    search_fields = ('user__name', 'user__email', 'type', 'stress_level')
    list_filter = ('type', 'stress_level', 'created_at')
    ordering = ('-created_at',)

@admin.register(Meal)
class MealAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'quantity', 'calories', 'protein', 'fats', 'carbs', 'fiber', 'created_at')
    search_fields = ('user__name', 'user__email', 'name')
    list_filter = ('calories', 'protein', 'fats', 'carbs', 'fiber', 'created_at')
    ordering = ('-created_at',)
@admin.register(Recommendation)
class RecommendationAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'type')
    search_fields = ('name', 'category')
    list_filter = ('category', 'type')
    fieldsets = (
        (None, {
            'fields': ('name', 'category', 'type', 'image', 'recipe')
        }),
        ('Nutritional Information', {
            'fields': ('protein', 'fat', 'fiber', 'cholesterol', 'carbs')
        }),
        ('Dietary Flags', {
            'fields': ('low_fat', 'low_carb', 'high_protein', 'no_sugar', 'wheat_free', 'egg_free', 'soy_free')
        }),
    )

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'gender', 'marital_status', 'height', 'birthdate', 'family_history','profile_picture', 'created_at')
    search_fields = ('name', 'email', 'gender', 'marital_status')
    list_filter = ('gender', 'marital_status', 'family_history', 'created_at')
    ordering = ('-created_at',)