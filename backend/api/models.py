from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.utils import timezone

class Preferences(models.Model):
    MEAL_CHOICES = [
        ('breakfast', 'Breakfast'),
        ('lunch', 'Lunch'),
        ('dinner', 'Dinner'),
    ]
    
    ALLERGY_CHOICES = [
        ('soy_free', 'Soy-free'),
        ('gluten_free', 'Gluten-free'),
        ('sesame_free', 'Sesame-free'),
        ('wheat_free', 'Wheat-free'),
        ('fish_free', 'Fish-free'),
        ('egg_free', 'Egg-free'),
    ]
    
    DIET_CHOICES = [
        ('low_fat', 'Low-Fat'),
        ('no_sugar', 'No-sugar'),
        ('high_protein', 'High-Protein'),
        ('low_carb', 'Low-Carb'),
        ('high_fiber', 'High-Fiber'),
    ]
    
    meals_per_day = models.JSONField(default=list)  # e.g., ['breakfast', 'lunch']
    allergies = models.JSONField(default=list)  # e.g., ['soy_free', 'gluten_free']
    diets_followed = models.JSONField(default=list)  # e.g., ['low_fat', 'no_sugar']
    daily_calories_min = models.IntegerField(default=0)
    daily_calories_max = models.IntegerField(default=0)
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='preferences')  # One-to-Many relationship with User
    created_at = models.DateTimeField(default=timezone.now)

class HealthRecord(models.Model):
    blood_glucose = models.FloatField(null=True, blank=True)
    blood_pressure = models.CharField(max_length=20, null=True, blank=True)
    bmi = models.FloatField(null=True, blank=True)
    weight = models.FloatField(null=True, blank=True)
    diabetes_risk = models.FloatField(default=0.0)
    created_at = models.DateTimeField(default=timezone.now)
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='health_records')

class PhysicalActivity(models.Model):
    duration = models.CharField(max_length=50)  # Format: '30 minutes'
    type = models.CharField(max_length=50)  # Format: 'Gym'

class PhysicalRecord(models.Model):
    physical_activity = models.ForeignKey(PhysicalActivity, on_delete=models.CASCADE)  # Link to PhysicalActivity
    stress_level = models.IntegerField()  # Assuming a scale of 1-10
    time = models.DateTimeField(default=timezone.now)  # Time of the physical activity record
    created_at = models.DateTimeField(default=timezone.now)  # Ensure this field is timezone-aware
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='physical_records')  # One-to-Many relationship with User

class Meal(models.Model):
    number = models.IntegerField()
    name = models.CharField(max_length=100)
    quantity = models.FloatField()  # Assuming grams or other unit
    calories = models.FloatField(default=0.0)
    protein = models.FloatField(default=0.0)
    fats = models.FloatField(default=0.0)
    carbs = models.FloatField(default=0.0)
    fiber = models.FloatField(default=0.0)
    nutrients = models.JSONField()  # Store detailed nutrients info in Dict format//TODO this should be removed if not necessary after testing 
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='meals')  # One-to-Many relationship with User
    created_at = models.DateTimeField(default=timezone.now)

class MealRecommendation(models.Model):
    recommendations = models.JSONField()  # Store recommendations in Dict format
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='meal_recommendations')  # One-to-Many relationship with User
    created_at = models.DateTimeField(default=timezone.now)


class User(AbstractBaseUser):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    gender = models.CharField(max_length=10)
    marital_status = models.CharField(max_length=20)
    height = models.FloatField()
    birthdate = models.DateField()
    family_history = models.BooleanField()
    profile_picture = models.CharField(max_length=255, null=True, blank=True)  # Allow null and blank
    created_at = models.DateTimeField(default=timezone.now)  # Ensure this field is timezone-aware


    def __str__(self):
        return f"{self.name} ({self.email})"
    