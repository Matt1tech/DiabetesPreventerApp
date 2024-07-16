from django.db import models
from django.utils import timezone

class Preferences(models.Model):
    preferences = models.JSONField()

class HealthRecords(models.Model):
    blood_glucose = models.FloatField()
    blood_pressure = models.CharField(max_length=20)  # Format: '120/80'
    bmi = models.FloatField()
    weight = models.FloatField()
    diabetes_risk = models.FloatField(default=0.0)  # Assuming risk is a percentage
    created_at = models.DateTimeField(default=timezone.now)  # Ensure this field is timezone-aware

class PhysicalActivity(models.Model):
    duration = models.CharField(max_length=50)  # Format: '30 minutes'
    type = models.CharField(max_length=50)  # Format: 'Gym'

class PhysicalRecords(models.Model):
    physical_activity = models.ForeignKey(PhysicalActivity, on_delete=models.CASCADE)  # Link to PhysicalActivity
    stress_level = models.IntegerField()  # Assuming a scale of 1-10
    time = models.DateTimeField(default=timezone.now)  # Time of the physical activity record
    created_at = models.DateTimeField(default=timezone.now)  # Ensure this field is timezone-aware

class Meal(models.Model):
    number = models.IntegerField()
    name = models.CharField(max_length=100)
    quantity = models.FloatField()  # Assuming grams or other unit
    nutrients = models.JSONField()  # Store detailed nutrients info in Dict format

class MealRecommendation(models.Model):
    recommendations = models.JSONField()  # Store recommendations in Dict format

class User(models.Model):
    userId = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    gender = models.CharField(max_length=10)
    marital_status = models.CharField(max_length=20)
    height = models.FloatField()
    birthdate = models.DateField()
    family_history = models.BooleanField()
    profile_picture = models.CharField(max_length=255)  # Store the path to the profile picture
    preferences = models.ForeignKey(Preferences, on_delete=models.CASCADE, null=True, blank=True)
    health_records = models.ManyToManyField(HealthRecords, blank=True)
    physical_records = models.ManyToManyField(PhysicalRecords, blank=True)
    created_at = models.DateTimeField(default=timezone.now)  # Ensure this field is timezone-aware

    def __str__(self):
        return f"{self.name} ({self.email})"  # String representation of the User object
