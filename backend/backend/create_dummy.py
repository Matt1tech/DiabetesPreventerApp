import random
from django.utils import timezone
from api.models import User,Customizations, HealthRecord, PhysicalActivity, PhysicalRecord, Meal, MealRecommendation

# Create a user
user = User.objects.create(
    name="John Doe",
    email="johndoe@example.com",
    password="password123",
    gender="Male",
    marital_status="Single",
    height=175.3,
    birthdate="1990-01-01",
    family_history=True,
    profile_picture="path/to/profile_picture.jpg",
    created_at=timezone.now()
)

# CreateCustomizations for the user
preferences =Customizations.objects.create(
    meals_per_day=["breakfast", "lunch", "dinner"],
    allergies=["soy_free", "gluten_free"],
    diets_followed=["low_fat", "no_sugar"],
    daily_calories_min=1800,
    daily_calories_max=2200,
    user=user,
    created_at=timezone.now()
)

# Create 10 health records for the user
for _ in range(10):
    HealthRecord.objects.create(
        blood_glucose=random.uniform(4.0, 6.0),
        blood_pressure=f"{random.randint(110, 130)}/{random.randint(70, 90)}",
        bmi=random.uniform(18.5, 24.9),
        weight=random.uniform(60.0, 80.0),
        diabetes_risk=random.uniform(5.0, 15.0),
        created_at=timezone.now(),
        user=user
    )

# Create physical activity and records for the user
physical_activity = PhysicalActivity.objects.create(
    duration="30 minutes",
    type="Gym"
)

physical_record = PhysicalRecord.objects.create(
    physical_activity=physical_activity,
    stress_level=5,
    time=timezone.now(),
    created_at=timezone.now(),
    user=user
)

# Create meals for the user
meal = Meal.objects.create(
    number=1,
    name="Chicken Salad",
    quantity=150.0,
    calories=300.0,
    protein=25.0,
    fats=10.0,
    carbs=30.0,
    fiber=5.0,
    nutrients={"vitamin_c": "30mg", "iron": "2mg"},
    user=user,
    created_at=timezone.now()
)

# Create meal recommendations for the user
meal_recommendation = MealRecommendation.objects.create(
    recommendations={"breakfast": "Oatmeal", "lunch": "Grilled Chicken", "dinner": "Salmon with Vegetables"},
    user=user,
    created_at=timezone.now()
)

print("Dummy data created successfully.")
