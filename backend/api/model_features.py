# features.py
from datetime import date, datetime, timedelta
from django.utils import timezone
from .models import *
from django.db.models import Avg
def calculate_bmi(weight, height):
    if weight is not None and height is not None:
        return weight / (height / 100) ** 2
    return None

def calculate_age(birthdate):
    today = timezone.now().date()
    return today.year - birthdate.year - ((today.month, today.day) < (birthdate.month, birthdate.day))

def is_high_bp(blood_pressure):
    """
    Determines if the blood pressure is high.
    
    Args:
    blood_pressure (float): The systolic blood pressure value.
    
    Returns:
    int: 1 if blood pressure is high (systolic > 135), 0 otherwise.
    """
    if blood_pressure is not None:
        return 1 if blood_pressure > 135 else 0
    return 0


def is_high_cholesterol(user):
    """
    Determines if the user's average cholesterol intake is high.
    
    Args:
    user (User): The user object.
    
    Returns:
    int: 1 if average cholesterol intake is high (average > 300 mg), 0 otherwise.
    """
    meals = Meal.objects.filter(user=user)
    if meals.exists():
        total_cholesterol = sum(meal.cholesterol for meal in meals)
        average_cholesterol = total_cholesterol / meals.count()
        return 1 if average_cholesterol > 300 else 0  # Assuming 300 mg as the threshold
    return 0


def calculate_mental_health(user, start_date):
    """
    Determines if the user's average stress level indicates poor mental health.

    Args:
    user (User): The user object.
    start_date (datetime.date): The start date for calculating stress levels.

    Returns:
    int: 1 if average stress level indicates poor mental health (average >= 3), 0 otherwise.
    """
    stress_records = PhysicalRecord.objects.filter(user=user, created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
    if stress_records.exists():
        total_stress_level = sum(record.stress_level for record in stress_records)
        average_stress_level = total_stress_level / stress_records.count()
        return 1 if average_stress_level >= 3 else 0  # Assuming average stress level >= 3 indicates poor mental health
    return 0






def calculate_physical_health(user, start_date):
    """
    Determines if the user's average physical activity indicates good physical health.

    Args:
    user (User): The user object.
    start_date (datetime.date): The start date for calculating physical activities.

    Returns:
    int: 1 if average physical activity indicates good physical health, 0 otherwise.
    """
    
    phys_activity_records = PhysicalRecord.objects.filter(user=user, created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
    if phys_activity_records.exists():
        total_duration = sum(record.duration for record in phys_activity_records)
        average_duration = total_duration / phys_activity_records.count()
        # Assuming an average duration of 30 minutes of physical activity indicates good physical health
        return 1 if average_duration >= 30 else 0
    return 0



def calculate_general_health(user, start_date):
    """
    Determines if the user's average physical activity indicates good general health.

    Args:
    user (User): The user object.
    start_date (datetime.date): The start date for calculating physical activities.

    Returns:
    int: 1 if average physical activity indicates good general health, 0 otherwise.
    """
    phys_activity_records = PhysicalRecord.objects.filter(user=user, created_at__gte=timezone.make_aware(datetime.combine(start_date, datetime.min.time())))
    if phys_activity_records.exists():
        total_duration = sum(record.duration for record in phys_activity_records)
        average_duration = total_duration / phys_activity_records.count()
        # Assuming an average duration of 30 minutes of physical activity indicates good general health
        return 1 if average_duration >= 30 else 0
    return 0




def calculate_average_blood_glucose(user):
    """
    Calculates the average blood glucose level for a user.
    
    Args:
    user (User): The user object.
    
    Returns:
    float: The average blood glucose level.
    """
    avg_blood_glucose = HealthRecord.objects.filter(user=user).aggregate(Avg('blood_glucose'))['blood_glucose__avg']
    return avg_blood_glucose if avg_blood_glucose is not None else 0.0



# Alphabetically sorted list of fruits popular in Malaysia
FRUITS = [
    'apple', 'banana', 'blueberry', 'dragonfruit', 'durian', 'grape',
    'guava', 'jackfruit', 'langsat', 'longan', 'lychee', 'mango',
    'mangosteen', 'melon', 'orange', 'papaya', 'pineapple', 'pomelo',
    'raspberry', 'rambutan', 'salak', 'starfruit', 'strawberry', 
    'watermelon'
]

# Alphabetically sorted list of vegetables popular in Malaysia
VEGGIES = [
    'bean sprouts', 'bitter gourd', 'bok choy', 'broccoli', 'cabbage', 
    'carrot', 'cauliflower', 'choy sum', 'cucumber', 'eggplant', 'ginger',
    'kale', 'kangkung', 'lettuce', 'long beans', 'mustard greens', 'okra', 
    'onion', 'pepper', 'pumpkin', 'spinach', 'tomato', 'water spinach', 
    'winged beans', 'yam bean', 'zucchini'
]

def is_fruit(meal_name):
    """
    Determines if the meal name corresponds to a fruit.

    Args:
    meal_name (str): The name of the meal.

    Returns:
    bool: True if the meal is a fruit, False otherwise.
    """
    return any(fruit in meal_name.lower() for fruit in FRUITS)

def is_veggie(meal_name):
    """
    Determines if the meal name corresponds to a vegetable.

    Args:
    meal_name (str): The name of the meal.

    Returns:
    bool: True if the meal is a vegetable, False otherwise.
    """
    return any(veggie in meal_name.lower() for veggie in VEGGIES)

def check_fruit_intake(user, today):
    """
    Checks if any meal name contains a fruit for today.

    Args:
    user (User): The user object.
    today (datetime.date): The date to check for fruit intake.

    Returns:
    int: 1 if any meal name contains a fruit, 0 otherwise.
    """
    meals_today = Meal.objects.filter(user=user, created_at__date=today)
    return 1 if any(is_fruit(meal.name) for meal in meals_today) else 0

def check_veggie_intake(user, today):
    """
    Checks if any meal name contains a vegetable for today.

    Args:
    user (User): The user object.
    today (datetime.date): The date to check for vegetable intake.

    Returns:
    int: 1 if any meal name contains a vegetable, 0 otherwise.
    """
    meals_today = Meal.objects.filter(user=user, created_at__date=today)
    return 1 if any(is_veggie(meal.name) for meal in meals_today) else 0




def calculate_diabetes_pedigree_function(user):
    # Placeholder logic for calculating DiabetesPedigreeFunction
    # Replace this with actual logic if available
    return 0.5 if user.family_history else 0.1  # Example values based on family history


# features.py
# ... (other imports and functions)

FEATURE_ORDER = [
    'HighBP', 'HighChol', 'BMI', 'PhysActivity', 'Fruits',
    'Veggies', 'GenHlth', 'MentHlth', 'PhysHlth', 'Sex',
    'Age', 'DiabetesPedigreeFunction', 'Glucose', 'FamilyHistory'
]

# ... (other functions)