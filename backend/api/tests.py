# tests.py

from django.test import TestCase
from api.models import User, HealthRecords
from api.utils import calculate_bmi
from bson import ObjectId
import uuid

class BMICalculationTest(TestCase):

    def setUp(self):
        unique_email = f"testuser_{uuid.uuid4()}@example.com"
        self.user = User.objects.create(
            name="Test User",
            email=unique_email,
            password="password",
            gender="Male",
            marital_status="Single",
            height=1.75,  # height in meters
            birthdate="1990-01-01",
            family_history=False,
            profile_picture="",
           Customizations={},
            health_records=[
                HealthRecords(
                    blood_glucose=5.5,
                    blood_pressure="120/80",
                    bmi=0,  # This will be calculated
                    weight=70.0  # weight in kilograms
                )
            ],
            physical_records=[],
            meal_recommendation={},
            daily_records=[],
            monthly_records=[],
            user_notification=""
        )

    def test_calculate_bmi(self):
        weight = self.user.health_records[0].weight
        height = self.user.height
        expected_bmi = calculate_bmi(weight, height)
        self.assertEqual(expected_bmi, weight / (height ** 2))

    def test_bmi_value_error(self):
        with self.assertRaises(ValueError):
            calculate_bmi(70, 0)  # height is zero, should raise ValueError
