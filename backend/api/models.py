from django.db import models
import datetime

class Preferences(models.Model):
    preferences = models.JSONField()

class HealthRecords(models.Model):
    blood_glucose = models.FloatField()
    blood_pressure = models.CharField(max_length=20)  # Format: '120/80'
    bmi = models.FloatField()
    weight = models.FloatField()

class PhysicalActivity(models.Model):
    duration = models.CharField(max_length=50)  # Format: '30 minutes'
    type = models.CharField(max_length=50)  # Format: 'Gym'

class PhysicalRecords(models.Model):
    physical_activity = models.ForeignKey(PhysicalActivity, on_delete=models.CASCADE)  # Link to PhysicalActivity
    stress_level = models.IntegerField()  # Assuming a scale of 1-10

class Meal(models.Model):
    number = models.IntegerField()
    name = models.CharField(max_length=100)
    quantity = models.FloatField()  # Assuming grams or other unit
    nutrients = models.JSONField()  # Store detailed nutrients info in Dict format

class DailyRecord(models.Model):
    date = models.DateTimeField(default=datetime.datetime.now)
    health_record = models.ForeignKey(HealthRecords, on_delete=models.CASCADE)
    physical_record = models.ForeignKey(PhysicalRecords, on_delete=models.CASCADE)
    meals = models.ManyToManyField(Meal)
    diabetes_risk = models.FloatField()  # Assuming risk is a percentage

class MonthlyRecord(models.Model):
    month = models.DateTimeField()
    avg_blood_glucose = models.FloatField()
    avg_blood_pressure = models.CharField(max_length=20)  # Format: '120/80'
    avg_calories = models.FloatField()
    avg_bmi = models.FloatField()
    weight_increase = models.FloatField()
    monthly_risk = models.FloatField()
    overall_health_status = models.CharField(max_length=100)

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
    created_at = models.DateTimeField(default=datetime.datetime.now)

    def __str__(self):
        return f"{self.name} ({self.email})"  # String representation of the User object
