from datetime import date, timezone
from django.http import JsonResponse
from django.contrib.auth.hashers import check_password, make_password
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .serializers import UserSerializer
from .models import User
from rest_framework.permissions import AllowAny
from .models import *
from .serializers import *
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.decorators import parser_classes
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from django.db.models import Sum
from .model_utils import model  # Import the loaded model
import pandas as pd
from .model_features import *
import logging


@api_view(['POST'])
@parser_classes([MultiPartParser, FormParser])
def create_user(request):
    if request.method == 'POST':
        data = request.data.dict()
        image = request.FILES.get('profile_picture')
        if image:
            image_path = default_storage.save('profile_pictures/' + image.name, ContentFile(image.read()))
            data['profile_picture'] = image_path

        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.validated_data['password'] = make_password(serializer.validated_data['password'])
            user = serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def login(request):
    email = request.data.get("email")
    password = request.data.get("password")
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "Invalid Credentials"}, status=status.HTTP_401_UNAUTHORIZED)
    
    if check_password(password, user.password):
        refresh = RefreshToken.for_user(user)
        user_data = {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'gender': user.gender,
            'marital_status': user.marital_status,
            'height': user.height,
            'birthdate': str(user.birthdate),
            'family_history': user.family_history,
            'profile_picture': user.profile_picture,
            'created_at': str(user.created_at),
        }
        print("User data sent after login:", user_data)  # Print statement for debugging

        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': user_data,
            


        })
    else:
        return Response({"error": "Invalid Credentials"}, status=status.HTTP_401_UNAUTHORIZED)
    
@api_view(['GET'])
def user_details(request):
    user = request.user
    serializer = UserSerializer(user)
    return Response(serializer.data)
    
@api_view(['POST'])
def logout(request):
    return Response(status=status.HTTP_205_RESET_CONTENT)
    




@api_view(['PUT'])
@parser_classes([MultiPartParser, FormParser])
def update_user(request):
    user_id = request.data.get('user_id')
    user = get_object_or_404(User, id=user_id)
    
    if 'password' in request.data:
        user.password = make_password(request.data['password'])
    
    if 'height' in request.data:
        user.height = request.data['height']
    
    if 'marital_status' in request.data:
        user.marital_status = request.data['marital_status']
    
    if 'profile_picture' in request.FILES:
        image = request.FILES['profile_picture']
        image_path = default_storage.save('profile_pictures/' + image.name, ContentFile(image.read()))
        user.profile_picture = image_path

    user.save()
    
    user_data = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'gender': user.gender,
        'marital_status': user.marital_status,
        'height': user.height,
        'birthdate': str(user.birthdate),
        'family_history': user.family_history,
        'profile_picture': user.profile_picture,
        'created_at': str(user.created_at),
    }
    
    return Response({'user': user_data}, status=status.HTTP_200_OK)








@api_view(['POST'])
def test_model(request):
    # Extract features from the request data
    feature_data = request.data
    
    # Check if all required features are provided
    required_features = [
        'HighBP', 'HighChol', 'BMI', 'PhysActivity', 'Fruits', 
        'Veggies', 'GenHlth', 'MentHlth', 'PhysHlth', 'Sex', 
        'Age', 'DiabetesPedigreeFunction', 'FamilyHistory', 'Glucose'
    ]
    
    for feature in required_features:
        if feature not in feature_data:
            return Response({'error': f'Missing feature: {feature}'}, status=status.HTTP_400_BAD_REQUEST)
    
    # Convert the input data to a DataFrame
    input_df = pd.DataFrame([feature_data])

    # Ensure the input features match the training feature order
    model_features = model.feature_names_in_
    input_df = input_df[model_features]

    # Make a prediction
    prediction = model.predict(input_df)
    prediction_prob = model.predict_proba(input_df)

    return Response({
        'prediction': prediction[0],
        'prediction_probabilities': prediction_prob[0].tolist()
    }, status=status.HTTP_200_OK)





















# Setup logging
logger = logging.getLogger(__name__)
@api_view(['POST'])
def create_or_update_health_record(request):
    today = timezone.now().date()
    data = request.data

    user_id = data.get('user')
    if not user_id:
        return Response({'user': 'This field is required.'}, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'user': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

    weight = data.get('weight')
    blood_glucose = data.get('blood_glucose')
    blood_pressure = data.get('blood_pressure')

    # Ensure at least one of the optional fields is provided
    if not any([weight, blood_glucose, blood_pressure]):
        return Response({'error': 'At least one of weight, blood_glucose, or blood_pressure must be provided.'}, status=status.HTTP_400_BAD_REQUEST)

    bmi = calculate_bmi(weight, user.height)
    age = calculate_age(user.birthdate)
    high_bp = is_high_bp(blood_pressure)
    high_chol = is_high_cholesterol(user)
    start_date = today - timedelta(days=30)
    ment_hlth = calculate_mental_health(user, start_date)
    phys_hlth = calculate_physical_health(user, start_date)
    gen_hlth = calculate_general_health(user, start_date)
    fruits = check_fruit_intake(user, today)
    veggies = check_veggie_intake(user, today)
    glucose = calculate_average_blood_glucose(user)

    # Dynamically calculate DiabetesPedigreeFunction
    diabetes_pedigree_function = calculate_diabetes_pedigree_function(user)

    # Calculate average blood glucose if not provided
    if blood_glucose is None:
        blood_glucose = glucose

    # Ensure FamilyHistory is either 0 or 1
    family_history = 1 if user.family_history else 0

    # Prepare the features in the correct order
    features_dict = {
        'HighBP': high_bp,
        'HighChol': high_chol,
        'BMI': bmi,
        'PhysActivity': phys_hlth,
        'Fruits': fruits,
        'Veggies': veggies,
        'GenHlth': gen_hlth,
        'MentHlth': ment_hlth,
        'PhysHlth': phys_hlth,
        'Sex': 1 if user.gender.lower() == 'male' else 0,
        'Age': age,
        'DiabetesPedigreeFunction': diabetes_pedigree_function,
        'Glucose': glucose,
        'FamilyHistory': family_history
    }

    # Ensure the features are in the correct order
    features_df = pd.DataFrame([features_dict])[FEATURE_ORDER]

    # Log the ordered features for debugging
    print("Model expects features:", model.feature_names_in_)
    print("Ordered features:", features_df.columns.tolist())
    print("Feature values:", features_df.iloc[0].to_dict())

    # Ensure the input features match the training feature order
    if list(features_df.columns) != list(model.feature_names_in_):
        return Response({'error': 'Feature names do not match the model.'}, status=status.HTTP_400_BAD_REQUEST)

    # Predict diabetes risk using the machine learning model
    try:
        diabetes_risk = model.predict(features_df)[0]
    except ValueError as e:
        print("Error during model prediction:", str(e))
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    # Check if a record exists for the user for today
    existing_record = HealthRecord.objects.filter(user=user, created_at__date=today).first()
    if existing_record:
        # Update the existing record with new values if provided
        if blood_glucose is not None:
            existing_record.blood_glucose = blood_glucose
        if blood_pressure is not None:
            existing_record.blood_pressure = blood_pressure
        if bmi is not None:
            existing_record.bmi = bmi
        if weight is not None:
            existing_record.weight = weight
        if diabetes_risk is not None:
            existing_record.diabetes_risk = diabetes_risk
        existing_record.save()
        return Response(HealthRecordsSerializer(existing_record).data, status=status.HTTP_200_OK)
    else:
        # Create a new record
        data['user'] = user.id
        if bmi is not None:
            data['bmi'] = bmi
        if diabetes_risk is not None:
            data['diabetes_risk'] = diabetes_risk
        serializer = HealthRecordsSerializer(data=data)
        if serializer.is_valid():
            serializer.save(user=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)




@api_view(['POST'])
def create_meal(request):
    user_id = request.data.get('user')
    if not user_id:
        return Response({'error': 'User ID is required.'}, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
    
    current_date = timezone.now().date()
    meals_today = Meal.objects.filter(user=user, created_at__date=current_date)
    meal_number = meals_today.count() + 1

    data = request.data.copy()
    data['number'] = meal_number
    data['user'] = user.id  # Ensure user is set as an ID

    serializer = MealSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    else:
        print('Error details:', serializer.errors)  # Add this line to print errors to console/logs
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)




@api_view(['GET'])
def get_total_daily_nutrition(request, user_id):
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
    
    current_date = timezone.now().date()
    meals_today = Meal.objects.filter(user=user, created_at__date=current_date)
    
    nutrition_summary = meals_today.aggregate(
        total_calories=Sum('calories'),
        total_protein=Sum('protein'),
        total_fats=Sum('fats'),
        total_carbs=Sum('carbs'),
        total_cholesterol=Sum('cholesterol')  # Include cholesterol in the summary
    )
    
    return Response(nutrition_summary, status=status.HTTP_200_OK)





@api_view(['POST'])
def physical_record(request):
    user_id = request.data.get('user_id')
    duration = request.data.get('duration', 0)
    record_type = request.data.get('type')
    stress_level = request.data.get('stress_level', None)

    if not user_id:
        return Response({'error': 'User ID is required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

    today = timezone.now().date()
    physical_record, created = PhysicalRecord.objects.get_or_create(
        user=user,
        created_at__date=today,
        defaults={
            'duration': duration,
            'type': record_type,
            'stress_level': stress_level
        }
    )

    if not created:
        physical_record.duration = duration if duration else physical_record.duration
        physical_record.type = record_type if record_type else physical_record.type
        physical_record.stress_level = stress_level if stress_level is not None else physical_record.stress_level
        physical_record.save()

    return Response({'status': 'success', 'record_id': physical_record.id})





@api_view(['GET'])
def get_last_health_record(request, user_id):
    # Retrieve the user
    try:
        user = get_object_or_404(User, pk=user_id)
        print(f"User found: {user}")
    except Exception as e:
        print(f"Error retrieving user: {e}")
        return Response({'error': 'User not found.'}, status=404)

    # Retrieve the last health record for the user
    try:
        last_health_record = HealthRecord.objects.filter(user=user).order_by('-created_at').first()
        print(f"Last Health Record: {last_health_record}")

        if last_health_record:
            data = {
                'blood_glucose': last_health_record.blood_glucose,
                'blood_pressure': last_health_record.blood_pressure,
                'weight': last_health_record.weight,
                'bmi': last_health_record.weight,
            }
            print(f"Retrieved data: {data}")
            return Response(data)
        else:
            print("No health records found for this user.")
            return Response({'error': 'No health records found for this user.'}, status=404)
    except Exception as e:
        print(f"Error retrieving health records: {e}")
        return Response({'error': 'Error retrieving health records.'}, status=500)
   
   
   
   
   

@api_view(['POST'])
def update_customizations(request):
    today = date.today()
    data = request.data

    user_id = data.get('user')
    if not user_id:
        return Response({'user': 'This field is required.'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'user': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

    # Extract fields from data
    daily_calories_max = data.get('daily_calories_max')
    max_protein = data.get('max_protein')
    max_fat = data.get('max_fat')
    max_fiber = data.get('max_fiber')
    max_cholesterol = data.get('max_cholesterol')
    max_carbs = data.get('max_carbs')  # New field for max carbs
    meals_per_day = data.get('meals_per_day')
    allergies = data.get('allergies')
    diets_followed = data.get('diets_followed')

    # Check if at least one field is provided
    if not any([daily_calories_max, max_protein, max_fat, max_fiber, max_cholesterol, max_carbs, meals_per_day, allergies, diets_followed]):
        return Response({'error': 'At least one field must be provided.'}, status=status.HTTP_400_BAD_REQUEST)

    # Check if Customizations for today already exist
    existing_customizations = Customizations.objects.filter(user=user, created_at__date=today).first()
    if existing_customizations:
        # Update the existing Customizations
        if daily_calories_max is not None:
            existing_customizations.daily_calories_max = daily_calories_max
        if max_protein is not None:
            existing_customizations.max_protein = max_protein
        if max_fat is not None:
            existing_customizations.max_fat = max_fat
        if max_fiber is not None:
            existing_customizations.max_fiber = max_fiber
        if max_cholesterol is not None:
            existing_customizations.max_cholesterol = max_cholesterol
        if max_carbs is not None:
            existing_customizations.max_carbs = max_carbs
        if meals_per_day:
            existing_customizations.meals_per_day = list(set(existing_customizations.meals_per_day + meals_per_day))
        if allergies:
            existing_customizations.allergies = list(set(existing_customizations.allergies + allergies))
        if diets_followed:
            existing_customizations.diets_followed = list(set(existing_customizations.diets_followed + diets_followed))
        existing_customizations.save()
        return Response(CustomizationsSerializer(existing_customizations).data, status=status.HTTP_200_OK)
    else:
        # Create new Customizations
        new_data = {
            'user': user.id,
            'daily_calories_max': daily_calories_max or 0,
            'max_protein': max_protein or 0,
            'max_fat': max_fat or 0,
            'max_fiber': max_fiber or 0,
            'max_cholesterol': max_cholesterol or 0,
            'max_carbs': max_carbs or 0,
            'meals_per_day': meals_per_day or [],
            'allergies': allergies or [],
            'diets_followed': diets_followed or [],
        }
        serializer = CustomizationsSerializer(data=new_data)
        if serializer.is_valid():
            serializer.save(user=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

   
   
   
   
@api_view(['GET'])
def get_user_customization(request, user_id):
    # Retrieve the user
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

    # Retrieve the customizations for the user
    customizations = Customizations.objects.filter(user=user).order_by('-created_at')
    if customizations.exists():
        serializer = CustomizationsSerializer(customizations, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    else:
        return Response({'message': 'No customizations found for this user.'}, status=status.HTTP_404_NOT_FOUND)
   
   
   
   
   
    
@api_view(['GET'])
def monthely_risk(request):
    pass 

    
    
    
    
    
    """
    
 
    
    
    
    
    @api_view(['PUT'])
def updateUser(request, pk):
    try:
        user_data = User.objects.get(userId=pk)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

    data = request.data

    # Handle password separately if it's in the request
    if 'password' in data:
        data['password'] = make_password(data['password'])

    serializer = UserSerializer(user_data, data=data, partial=True)
    
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    else:
        return Response(serializer.errors, status=400)
        
        
    
    
    
    
    
    
    
    


    """

