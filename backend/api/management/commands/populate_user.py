# backend/api/management/commands/populate_user.py

from django.core.management.base import BaseCommand
from api.models import User,Customizations, HealthRecords, PhysicalActivity, PhysicalRecords, Meal, DailyRecord, MonthlyRecord, MealRecommendation
import datetime
from django.contrib.auth.hashers import make_password

class Command(BaseCommand):
    help = 'Populate the User model with full data'

    def handle(self, *args, **kwargs):
       Customizations =Customizations(preferences={"theme": "dark", "notifications": True})

        health_record = HealthRecords(
            blood_glucose=5.5,
            blood_pressure="120/80",
            bmi=23.0,
            weight=70.0
        )

        physical_activity = PhysicalActivity(
            duration="30 minutes",
            type="Gym"
        )

        physical_record = PhysicalRecords(
            physical_activity=physical_activity,
            stress_level=5
        )

        meal_1 = Meal(
            number=1,
            name="Breakfast",
            quantity=300.0,
            nutrients={"calories": 500, "protein": 20, "carbs": 70, "fat": 10}
        )

        daily_record = DailyRecord(
            health_record=health_record,
            physical_record=physical_record,
            meals=[meal_1],
            diabetes_risk=15.0
        )

        monthly_record = MonthlyRecord(
            month=datetime.datetime.now(),
            avg_blood_glucose=5.6,
            avg_blood_pressure="120/80",
            avg_calories=2200.0,
            avg_bmi=23.5,
            weight_increase=0.5,
            monthly_risk=12.0,
            overall_health_status="Good"
        )

        meal_recommendation = MealRecommendation(
            recommendations={"breakfast": "Oatmeal", "lunch": "Salad", "dinner": "Grilled chicken"}
        )

        user = User(
            name="John Doe",
            email="john.doe@example.com",
            password=make_password("password123"),
            gender="Male",
            marital_status="Single",
            height=1.75,
            birthdate="1990-01-01",
            family_history=True,
            profile_picture="/path/to/profile.jpg",
           Customizations=preferences,
            health_records=[health_record],
            physical_records=[physical_record],
            meal_recommendation=meal_recommendation,
            daily_records=[daily_record],
            monthly_records=[monthly_record],
            user_notification="You have a new message"
        )

        user.save()
        self.stdout.write(self.style.SUCCESS(f"User created successfully: {user}"))
