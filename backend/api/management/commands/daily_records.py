# backend/api/management/commands/add_daily_records.py

from django.core.management.base import BaseCommand
from api.models import User, HealthRecords, PhysicalActivity, PhysicalRecords, Meal, DailyRecord
import datetime

class Command(BaseCommand):
    help = 'Add new daily records to an existing user'

    def handle(self, *args, **kwargs):
        try:
            user = User.objects.get(email="john.doe@le.com")

            new_health_record = HealthRecords(
                blood_glucose=6.0,
                blood_pressure="125/85",
                bmi=24.0,
                weight=72.0
            )

            new_physical_activity = PhysicalActivity(
                duration="45 minutes",
                type="Running"
            )

            new_physical_record = PhysicalRecords(
                physical_activity=new_physical_activity,
                stress_level=4
            )

            new_meal_1 = Meal(
                number=1,
                name="Lunch",
                quantity=350.0,
                nutrients={"calories": 600, "protein": 25, "carbs": 80, "fat": 15}
            )

            new_daily_record = DailyRecord(
                date=datetime.datetime.now(),
                health_record=new_health_record,
                physical_record=new_physical_record,
                meals=[new_meal_1],
                diabetes_risk=16.0
            )

            user.daily_records.append(new_daily_record)
            user.save()

            self.stdout.write(self.style.SUCCESS(f"New daily record added successfully for user: {user.name}"))

        except User.DoesNotExist:
            self.stdout.write(self.style.ERROR("User with email 'john.doe@le.com' does not exist"))
