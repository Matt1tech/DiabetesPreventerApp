from datetime import date, timezone
from django.contrib.auth.hashers import check_password, make_password
from django.core.files.storage import default_storage
from django.db.models import Q
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
from rest_framework_simplejwt.tokens import RefreshToken
from django.db.models import Sum
from .model_utils import model  # Import the loaded model
import pandas as pd
from .model_features import *
import logging
from django.contrib.auth.views import PasswordResetView
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from django.conf import settings
import random
logger = logging.getLogger(__name__)



#------------------------------------------------------------------
#   User  Management Authentication Module
#------------------------------------------------------------------

'''
    Creates a new user in the system.

    Expected Input:
    - `POST` request with the following form data:
        - `name`: (string) The name of the user.
        - `email`: (string) The email address of the user.
        - `password`: (string) The password for the user.
        - `gender`: (string) The gender of the user (e.g., 'male', 'female').
        - `marital_status`: (string) The marital status of the user.
        - `height`: (float) The height of the user in centimeters.
        - `birthdate`: (string) The birthdate of the user in 'YYYY-MM-DD' format.
        - `family_history`: (boolean) Whether the user has a family history of diabetes.
        - `profile_picture`: (file, optional) The profile picture of the user.

    Expected Output:
    - On success: JSON response with the user's details (status 201 CREATED).
    - On failure: JSON response with error details (status 400 BAD REQUEST).

    How It Works:
    - The view first converts the incoming request data to a dictionary.
    - If a profile picture is provided, it is saved using `default_storage`, and the path is added to the data.
    - The data is then serialized using `UserSerializer`.
    - If the data is valid, the password is hashed, and the user is saved to the database.
    - If the data is invalid, an error response is returned.
  '''
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
    
    
  #--------------------------------------------------------------------------------- 
'''
 Authenticates a user and returns JWT tokens if the credentials are valid.

    Expected Input:
    - `POST` request with the following JSON data:
        - `email`: (string) The email address of the user.
        - `password`: (string) The password of the user.

    Expected Output:
    - On success: JSON response with JWT tokens and user details (status 200 OK).
    - On failure: JSON response with an error message indicating invalid credentials (status 401 UNAUTHORIZED).

    How It Works:
    - The view retrieves the user from the database using the provided email.
    - If the user is found, the provided password is checked against the stored hashed password using `check_password`.
    - If the password is correct, JWT tokens are generated using `RefreshToken.for_user(user)`.
    - The user's details and tokens are then returned in the response.
    - If the email or password is incorrect, an error response is returned.
'''
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
    
#----------------------------------------------------------------------------------- 
'''
Logs out the user by returning a reset content status.

    Expected Input:
    - `POST` request. No specific input required.

    Expected Output:
    - Response with status 205 RESET CONTENT.

    How It Works:
    - This view simply returns a response with status 205, which can be used by the client to clear tokens or perform other logout-related actions.
'''
@api_view(['POST'])
def logout(request):
    return Response(status=status.HTTP_205_RESET_CONTENT)
#-----------------------------------------------------------------------------------  
'''
 Updates the user's profile information.

    Expected Input:
    - `PUT` request with the following form data:
        - `user_id`: (int) The ID of the user.
        - `current_password`: (string) The current password of the user (required for verification).
        - Optional fields to be updated: `name`, `email`, `password`, `profile_picture`, `marital_status`, `height`.

    Expected Output:
    - On success: JSON response with the updated user details (status 200 OK).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 401 UNAUTHORIZED).

    How It Works:
    - The view first verifies the user's identity by checking the provided current password.
    - It then processes the provided data, saving or removing the profile picture as necessary.
    - Only fields that are provided and valid are updated.
    - The user's password is hashed if it's being changed.
    - The updated user data is saved and returned in the response.
    - If the password verification fails or the data is invalid, an error response is returned.
'''
@api_view(['PUT'])
@parser_classes([MultiPartParser, FormParser])
def update_user_profile(request):
    user_id = request.data.get('user_id')
    current_password = request.data.get('current_password')
    user = get_object_or_404(User, id=user_id)

    if not check_password(current_password, user.password):
        return Response({"error": "Current password is incorrect"}, status=status.HTTP_401_UNAUTHORIZED)

    data = request.data.dict()
    image = request.FILES.get('profile_picture')

    if image:
        image_path = default_storage.save('profile_pictures/' + image.name, ContentFile(image.read()))
        data['profile_picture'] = image_path
    elif 'remove_profile_picture' in request.data and request.data['remove_profile_picture'] == 'true':
        data['profile_picture'] = None
    else:
        data.pop('profile_picture', None) 

    # Remove fields that should not be updated
    fields_to_remove = []
    if 'name' not in data or not data['name']:
        fields_to_remove.append('name')
    if 'email' not in data or not data['email']:
        fields_to_remove.append('email')
    if 'password' not in data or not data['password']:
        fields_to_remove.append('password')
    if 'marital_status' not in data or not data['marital_status']:
        fields_to_remove.append('marital_status')
    if 'height' not in data or not data['height']:
        fields_to_remove.append('height')
    for field in fields_to_remove:
        data.pop(field, None)

    serializer = UserSerializer(user, data=data, partial=True)
    if serializer.is_valid():
        if 'password' in serializer.validated_data:
            serializer.validated_data['password'] = make_password(serializer.validated_data['password'])
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#-----------------------------------------------------------------------------------
"""
    Sends an OTP to the user's email for password reset.

    Expected Input:
    - `POST` request with the following JSON data:
        - `email`: (string) The email address of the user.

    Expected Output:
    - On success: JSON response indicating that the OTP has been sent (status 200 OK).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 404 NOT FOUND or 500 INTERNAL SERVER ERROR).

    How It Works:
    - The view verifies the user's existence based on the provided email.
    - It generates a six-digit OTP and stores it in the user's record along with an expiration timestamp.
    - The OTP is sent to the user's email.
    - If the email is invalid, the user is not found, or email sending fails, an error response is returned.
"""
def generate_otp():
    return str(random.randint(100000, 999999))

@api_view(['POST'])
@permission_classes([AllowAny])
def request_otp(request):
    email = request.data.get('email')
    if not email:
        return Response({'error': 'Email is required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({'error': 'User with this email does not exist'}, status=status.HTTP_404_NOT_FOUND)

    otp = generate_otp()
    user.otp = otp
    user.otp_expiration = timezone.now() + timedelta(minutes=5)  # OTP valid for 5 minutes
    user.save()

    email_subject = 'Password Reset OTP-Diabetes Preventer Application'
    email_body = f"Diabetes Preventer Application, Reset Password Service. \n\n\n Your OTP for password reset is: {otp}\n\n\n\n This message is confidential please don not reply it or share with any third party.\n\n\n\n\n Thank you for using Diabetes Preventer Application.\n\n\n\n Stay healthy.\n\n Users Support Team."
    
    try:
        send_mail(
            email_subject,
            email_body,
            settings.DEFAULT_FROM_EMAIL,
            [email],
            fail_silently=False,
        )
        return Response({'message': 'OTP sent to your email'}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': f'Failed to send OTP: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
#-----------------------------------------------------------------------------------


"""
    Verifies the OTP and resets the user's password if the OTP is valid.

    Expected Input:
    - `POST` request with the following JSON data:
        - `email`: (string) The email address of the user.
        - `otp`: (string) The OTP received by the user.
        - `new_password`: (string) The new password to set.

    Expected Output:
    - On success: JSON response indicating that the password has been reset (status 200 OK).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 404 NOT FOUND).

    How It Works:
    - The view verifies the user's existence and checks if the provided OTP matches the stored OTP and is not expired.
    - If the OTP is valid, the user's password is updated and the OTP is cleared.
    - If the OTP is invalid, expired, or the email is incorrect, an error response is returned.
"""
@api_view(['POST'])
@permission_classes([AllowAny])
def verify_otp(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    new_password = request.data.get('new_password')

    if not email or not otp or not new_password:
        return Response({'error': 'Email, OTP, and new password are required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({'error': 'Invalid email or OTP'}, status=status.HTTP_404_NOT_FOUND)

    if user.otp != otp or timezone.now() > user.otp_expiration:
        return Response({'error': 'Invalid or expired OTP'}, status=status.HTTP_400_BAD_REQUEST)

    user.set_password(new_password)
    user.otp = None
    user.otp_expiration = None
    user.save()

    return Response({'message': 'Password has been reset'}, status=status.HTTP_200_OK)

#-----------------------------------------------------------------------------------





#************************************************************************************
# The end of User Authentication Module
#************************************************************************************


#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





#------------------------------------------------------------------
#  Risk Analysis Module
#------------------------------------------------------------------
"""
Calculates the average diabetes risk for each month over the past six months for the specified user.

Expected Input:
- `GET` request with the user ID provided in the URL.

Expected Output:
- On success: JSON response with the monthly average risk data (status 200 OK).
- On failure: JSON response with error details (status 500 INTERNAL SERVER ERROR).

How It Works:
- The view verifies the user's existence.
- It calculates the monthly average diabetes risk based on the user's health records over the past six months.
- For each month, it retrieves all health records for that user within the month.
- For each record, it prepares the features, uses the model to predict the diabetes risk probability, and calculates the average of these probabilities for the month.
- The average risk data is aggregated and returned in the response.
- If an error occurs during calculation, an error response is returned.

Algorithm:
1. Verify if the user exists using the provided user ID.
2. Initialize an empty list to store monthly risk data.
3. Loop over the last six months:
   a. Calculate the start and end dates for each month.
   b. Retrieve all health records for the user within that month.
   c. If records exist, calculate the average risk based on the model's predicted probabilities.
   d. Append the month and average risk to the list.
4. Return the list as a JSON response.
5. Handle any exceptions and return an error response if needed.
"""
@api_view(['GET'])
def monthly_risk(request, user_id):
    try:
        # Step 1: Verify if the user exists
        user = get_object_or_404(User, pk=user_id)
        end_date = timezone.now().date()
        monthly_risk_data = []

        # Step 2: Loop over the last six months
        for i in range(6):
            # Calculate the start and end dates for each month
            month_start = (end_date.replace(day=2) - timedelta(days=1)).replace(day=1) - timedelta(days=30 * i)
            month_end = month_start + timedelta(days=31)
            month_end = month_end.replace(day=1)

            # Step 3: Retrieve health records for the current month
            health_records = HealthRecord.objects.filter(
                user=user,
                created_at__date__gte=month_start,
                created_at__date__lt=month_end
            )

            if health_records.exists():
                risks = []
                for record in health_records:
                    try:
                        # Step 4: Prepare the features for the model
                        features_dict = {
                            'HighBP': int(is_high_bp(record.blood_pressure)),
                            'HighChol': int(is_high_cholesterol(user)),
                            'BMI': float(record.bmi) if record.bmi else 0.0,
                            'PhysActivity': int(calculate_physical_health(user, month_start)),
                            'Fruits': int(check_fruit_intake(user, month_start)),
                            'Veggies': int(check_veggie_intake(user, month_start)),
                            'GenHlth': int(calculate_general_health(user, month_start)),
                            'MentHlth': int(calculate_mental_health(user, month_start)),
                            'PhysHlth': int(calculate_physical_health(user, month_start)),
                            'Sex': 1 if user.gender.lower() == 'male' else 0,
                            'Age': int(calculate_age(user.birthdate)),
                            'DiabetesPedigreeFunction': float(calculate_diabetes_pedigree_function(user)),
                            'Glucose': float(record.blood_glucose) if record.blood_glucose else 0.0,
                            'FamilyHistory': int(user.family_history),
                        }

                        features_df = pd.DataFrame([features_dict])[FEATURE_ORDER]

                        # Step 5: Predict using the model and collect the risk probability
                        prediction_prob = model.predict_proba(features_df)[0]
                        risks.append(prediction_prob[1])  # class 1 is the "diabetes risk" probability

                    except Exception as e:
                        logger.error(f"Error processing health record: {str(e)}")
                        return Response({'error': f'Error processing health record: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)

                # Step 6: Calculate the average risk for the month
                avg_risk = sum(risks) / len(risks) if risks else 0
            else:
                avg_risk = 0

            # Step 7: Append the monthly data to the result list
            monthly_risk_data.append({
                'month': month_start.strftime('%Y-%m'),
                'risk': avg_risk
            })

            logger.debug(f"Month: {month_start.strftime('%Y-%m')}, Avg Risk: {avg_risk}")

        # Step 8: Return the monthly risk data
        return Response(monthly_risk_data, status=status.HTTP_200_OK)

    except Exception as e:
        # Step 9: Handle any exceptions and return an error response
        logger.error(f"Error calculating monthly risk for user {user_id}: {str(e)}")
        return Response({'error': 'An error occurred while calculating monthly risk.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
   #---------------------------------------------------------------- 
"""
    Tests the machine learning model with provided input features.

    Expected Input:
    - `POST` request with the following JSON data:
        - Required features: `HighBP`, `HighChol`, `BMI`, `PhysActivity`, `Fruits`, 
                             `Veggies`, `GenHlth`, `MentHlth`, `PhysHlth`, `Sex`, 
                             `Age`, `DiabetesPedigreeFunction`, `FamilyHistory`, `Glucose`.

    Expected Output:
    - On success: JSON response with the model's prediction and prediction probabilities (status 200 OK).
    - On failure: JSON response with error details (status 400 BAD REQUEST).

    How It Works:
    - The view checks if all required features are present in the request.
    - The data is converted to a DataFrame and arranged to match the model's expected feature order.
    - The model makes a prediction and returns the predicted class and probabilities.
    - If any required features are missing or the prediction fails, an error response is returned.
"""     
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
    
#************************************************************************************
# The end of Risk Analysis Module 
#************************************************************************************


#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


#------------------------------------------------------------------
#   Meal Records Module
#------------------------------------------------------------------
"""
    Creates a new meal record for the user for today.

    Expected Input:
    - `POST` request with the following JSON data:
        - `user`: (int) The ID of the user.
        - `meal_type`: (string) The type of meal (e.g., breakfast, lunch, dinner).
        - Optional fields: `calories`, `protein`, `fats`, `carbs`, `cholesterol`, etc.

    Expected Output:
    - On success: JSON response with the created meal record (status 201 CREATED).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 404 NOT FOUND).

    How It Works:
    - The view verifies the user's existence.
    - It calculates the meal number based on the number of meals logged by the user today.
    - The meal record is created, saved, and returned in the response.
    - If the user is not found or the data is invalid, an error response is returned.
    """
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
    
    
    
#----------------------------------------------------------------


"""
    Retrieves the total nutritional intake for the current day for the specified user.

    Expected Input:
    - `GET` request with the user ID provided in the URL.

    Expected Output:
    - On success: JSON response with the total daily intake of calories, protein, fats, carbs, cholesterol, and fiber (status 200 OK).
    - On failure: JSON response with error details (status 404 NOT FOUND).

    How It Works:
    - The view verifies the user's existence.
    - It aggregates the nutritional intake from all meals logged by the user today.
    - The aggregated nutritional data is returned in the response.
    - If the user is not found, an error response is returned.
"""
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
        total_cholesterol=Sum('cholesterol'),
        total_fiber=Sum('fiber') # Include cholesterol in the summary
    )
    
    return Response(nutrition_summary, status=status.HTTP_200_OK)


#************************************************************************************
# The end of Meal Records Module 
#************************************************************************************


#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



#------------------------------------------------------------------
#  Dietary Planner and Meal Recommendation Module
#------------------------------------------------------------------

"""
    Updates or creates user customizations for dietary and meal preferences.

    Expected Input:
    - `POST` request with the following JSON data:
        - `user`: (int) The ID of the user.
        - Optional fields: `daily_calories_max`, `max_protein`, `max_fat`, `max_fiber`, 
                           `max_cholesterol`, `max_carbs`, `meals_per_day`, `allergies`, `diets_followed`.

    Expected Output:
    - On success: JSON response with the updated or created customization record (status 200 OK or 201 CREATED).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 404 NOT FOUND).

    How It Works:
    - The view verifies the user's existence.
    - It checks if customizations for today already exist; if so, they are updated; otherwise, a new record is created.
    - The customization record is saved and returned in the response.
    - If the user is not found or the data is invalid, an error response is returned.
"""
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
    max_carbs = data.get('max_carbs')  
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

#----------------------------------------------------------------


"""
    Retrieves the customization settings for a specified user.

    Expected Input:
    - `GET` request with the user ID provided in the URL.

    Expected Output:
    - On success: JSON response with the customization settings (status 200 OK).
    - On failure: JSON response with error details (status 404 NOT FOUND).

    How It Works:
    - The view verifies the user's existence.
    - It retrieves all customization records for the user, ordered by the most recent.
    - The customization settings are returned in the response.
    - If the user or customizations are not found, an error response is returned.
"""
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
#-----------------------------------------------------------------------------

"""
    Provides personalized recommendations for the specified user based on their customizations, health records, and nutritional intake.

    Expected Input:
    - `GET` request with the user ID provided in the URL.

    Expected Output:
    - On success: JSON response with a list of filtered recommendations tailored to the user's needs (status 200 OK).
    - On failure: JSON response with error details (status 404 NOT FOUND or 400 BAD REQUEST).

    How It Works:
    - The view retrieves the user's customizations, meals for the current day, and the latest health record.
    - It filters the recommendations based on the user's dietary preferences, allergies, and nutritional intake.
    - The recommendations are adjusted according to the user's remaining nutritional limits.
    - The filtered recommendations are returned in the response.
    - If the user or related data is not found, an error response is returned.
"""
@api_view(['GET'])
def user_recommendation(request, user_id):
    # Step 1: Retrieve User Data
    user = get_object_or_404(User, id=user_id)
    today = timezone.now().date()
    customizations = Customizations.objects.filter(user=user, created_at__date=today).order_by('-created_at').first()
    meals_today = Meal.objects.filter(user=user, created_at__date=today)
    latest_health_record = HealthRecord.objects.filter(user=user).order_by('-created_at').first()
    
    # Calculate Total Cholesterol from Meals
    total_cholesterol_today = meals_today.aggregate(total_cholesterol=Sum('cholesterol'))['total_cholesterol'] or 0

    # Filter Recommendations Based on Customizations and Health Records
    recommendations = Recommendation.objects.all()
    if customizations:
        if 'low_fat' in customizations.diets_followed:
            recommendations = recommendations.filter(low_fat=True)
        if 'low_carb' in customizations.diets_followed:
            recommendations = recommendations.filter(low_carb=True)
        if 'high_protein' in customizations.diets_followed:
            recommendations = recommendations.filter(high_protein=True)
        if 'no_sugar' in customizations.diets_followed:
            recommendations = recommendations.filter(no_sugar=True)
        if 'wheat_free' in customizations.allergies:
            recommendations = recommendations.filter(wheat_free=True)
        if 'egg_free' in customizations.allergies:
            recommendations = recommendations.filter(egg_free=True)
        if 'soy_free' in customizations.allergies:
            recommendations = recommendations.filter(soy_free=True)
        if customizations.meals_per_day:
            recommendations = recommendations.filter(type__in=customizations.meals_per_day)

    # Consider high blood sugar levels
    if latest_health_record and latest_health_record.blood_glucose > 140:
        recommendations = recommendations.filter(no_sugar=True)

    # Check Nutritional Limits
    nutrition_summary = meals_today.aggregate(
        total_calories=Sum('calories'),
        total_protein=Sum('protein'),
        total_fats=Sum('fats'),
        total_carbs=Sum('carbs'),
        total_fiber=Sum('fiber'),
    )
    
    max_protein = customizations.max_protein if customizations else 100
    max_fat = customizations.max_fat if customizations else 100
    max_fiber = customizations.max_fiber if customizations else 100
    max_cholesterol = customizations.max_cholesterol if customizations else 100
    max_carbs = customizations.max_carbs if customizations else 100

    buffer_factor = 1.1

    remaining_protein = max_protein - (nutrition_summary['total_protein'] or 0)
    remaining_fat = max_fat - (nutrition_summary['total_fats'] or 0)
    remaining_fiber = max_fiber - (nutrition_summary['total_fiber'] or 0)
    remaining_cholesterol = max_cholesterol - total_cholesterol_today
    remaining_carbs = max_carbs - (nutrition_summary['total_carbs'] or 0)

    # Filter recommendations based on remaining nutritional limits with buffer factor
    filtered_recommendations = recommendations.filter(
        protein__lte=remaining_protein * buffer_factor,
        fat__lte=remaining_fat * buffer_factor,
        fiber__lte=remaining_fiber * buffer_factor,
        cholesterol__lte=remaining_cholesterol * buffer_factor,
        carbs__lte=remaining_carbs * buffer_factor
    )

    # Ensure at least two recommendations from each category if filtering is too restrictive
    min_recommendations_per_category = 2
    categories = recommendations.values_list('category', flat=True).distinct()
    final_recommendations = []

    for category in categories:
        category_recommendations = filtered_recommendations.filter(category=category)
        if category_recommendations.count() < min_recommendations_per_category:
            fallback_recommendations = recommendations.filter(category=category)[:min_recommendations_per_category]
            final_recommendations.extend(fallback_recommendations)
        else:
            final_recommendations.extend(category_recommendations[:min_recommendations_per_category])

    # Serialize and Return Recommendations
    serializer = RecommendationSerializer(final_recommendations, many=True, context={'request': request})
    
    return Response(serializer.data, status=status.HTTP_200_OK)



#************************************************************************************
# The end of  Dietary Planner and Meal Recommendation Module 
#************************************************************************************


#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


#------------------------------------------------------------------
#    Lifestyle and Health Analysis  Module
#------------------------------------------------------------------

'''
 Creates or updates a health record for the user for the current day.

    Expected Input:
    - `POST` request with the following JSON data:
        - `user`: (int) The ID of the user.
        - Optional fields: `weight`, `blood_glucose`, `blood_pressure`.

    Expected Output:
    - On success: JSON response with the created or updated health record (status 200 OK or 201 CREATED).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 404 NOT FOUND).

    How It Works:
    - The view first verifies the user's existence.
    - It then checks if any of the optional fields (`weight`, `blood_glucose`, `blood_pressure`) are provided.
    - Various health metrics are calculated, including BMI, age, and diabetes risk using the model.
    - If a health record exists for today, it is updated; otherwise, a new record is created.
    - The health record is saved and returned in the response.
    - If required fields are missing or the user is not found, an error response is returned.
'''
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
    
#------------------------------------------------------------------------------------
    
'''
Retrieves the latest health record for the specified user and calculates additional features.

    Expected Input:
    - `GET` request with the user ID provided in the URL.

    Expected Output:
    - On success: JSON response with the last health record details and calculated features like BMI and diabetes risk (status 200 OK).
    - On failure: JSON response with error details (status 404 NOT FOUND or 500 INTERNAL SERVER ERROR).

    How It Works:
    - The view verifies the user's existence.
    - It retrieves the most recent health record for the user.
    - Various health metrics are calculated, including BMI, age, and diabetes risk using the model.
    - The health record details and calculated metrics are returned in the response.
    - If the user or health record is not found, an error response is returned.
'''
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
            # Extract necessary information from the last health record
            weight = last_health_record.weight
            blood_glucose = last_health_record.blood_glucose
            blood_pressure = last_health_record.blood_pressure

            # Calculate additional features
            bmi = calculate_bmi(weight, user.height)
            age = calculate_age(user.birthdate)
            high_bp = is_high_bp(blood_pressure)
            high_chol = is_high_cholesterol(user)
            start_date = timezone.now().date() - timedelta(days=30)
            ment_hlth = calculate_mental_health(user, start_date)
            phys_hlth = calculate_physical_health(user, start_date)
            gen_hlth = calculate_general_health(user, start_date)
            fruits = check_fruit_intake(user, timezone.now().date())
            veggies = check_veggie_intake(user, timezone.now().date())
            glucose = calculate_average_blood_glucose(user)
            diabetes_pedigree_function = calculate_diabetes_pedigree_function(user)
            family_history = 1 if user.family_history else 0

            # Prepare features for the model
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
                prediction_prob = model.predict_proba(features_df)[0]
                prediction = model.predict(features_df)[0]
            except ValueError as e:
                print("Error during model prediction:", str(e))
                return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

            # Prepare the response data
            response_data = {
                'blood_glucose': last_health_record.blood_glucose,
                'blood_pressure': last_health_record.blood_pressure,
                'weight': last_health_record.weight,
                'bmi': bmi,
                'diabetes_risk_probability_class_0': prediction_prob[0],
                'diabetes_risk_probability_class_1': prediction_prob[1],
                'diabetes_risk_probability_class_2': prediction_prob[2],
            }
            print(f"Retrieved data: {response_data}")
            return Response(response_data)
        else:
            print("No health records found for this user.")
            return Response({'error': 'No health records found for this user.'}, status=404)
    except Exception as e:
        print(f"Error retrieving health records: {e}")
        return Response({'error': 'Error retrieving health records.'}, status=500)
    
    
#------------------------------------------------------------------------------------
'''
    Creates or updates a physical activity record for the user for today.

    Expected Input:
    - `POST` request with the following JSON data:
        - `user_id`: (int) The ID of the user.
        - `duration`: (int) The duration of the physical activity in minutes.
        - `type`: (string) The type of physical activity.
        - `stress_level`: (int, optional) The stress level of the user.

    Expected Output:
    - On success: JSON response with the status and record ID (status 200 OK).
    - On failure: JSON response with error details (status 400 BAD REQUEST or 404 NOT FOUND).

    How It Works:
    - The view verifies the user's existence.
    - It checks if a physical activity record exists for today; if so, it updates the record; otherwise, a new record is created.
    - The physical activity record is saved and returned in the response.
    - If the user is not found or the data is invalid, an error response is returned.
'''

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

#------------------------------------------------------------------------------------
#************************************************************************************
# The end of Lifestyle and Health Analysis  Module
#************************************************************************************


#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


#------------------------------------------------------------------
#    Report  Module
#------------------------------------------------------------------












































   
   
   
   


   
   
   
   

   
   
   
   
  


    
    
    
    
    
    


    
    
    
 #testing    

@api_view(['GET'])
def recommendation_list(request):
    recommendations = Recommendation.objects.all()
    serializer = RecommendationSerializer(recommendations, many=True, context={'request': request})
    return Response(serializer.data)
    
'''    
@api_view(['GET'])
def user_recommendation(request, user_id):
    # Step 1: Retrieve User Data
    user = get_object_or_404(User, id=user_id)
    today = timezone.now().date()
    customizations = Customizations.objects.filter(user=user, created_at__date=today).order_by('-created_at').first()
    meals_today = Meal.objects.filter(user=user, created_at__date=today)
    latest_health_record = HealthRecord.objects.filter(user=user).order_by('-created_at').first()
    
    # Calculate Total Cholesterol from Meals
    total_cholesterol_today = meals_today.aggregate(total_cholesterol=Sum('cholesterol'))['total_cholesterol'] or 0

    # Filter Recommendations Based on Customizations and Health Records
    recommendations = Recommendation.objects.all()
    if customizations:
        if 'low_fat' in customizations.diets_followed:
            recommendations = recommendations.filter(low_fat=True)
        if 'low_carb' in customizations.diets_followed:
            recommendations = recommendations.filter(low_carb=True)
        if 'high_protein' in customizations.diets_followed:
            recommendations = recommendations.filter(high_protein=True)
        if 'no_sugar' in customizations.diets_followed:
            recommendations = recommendations.filter(no_sugar=True)
        if 'wheat_free' in customizations.allergies:
            recommendations = recommendations.filter(wheat_free=True)
        if 'egg_free' in customizations.allergies:
            recommendations = recommendations.filter(egg_free=True)
        if 'soy_free' in customizations.allergies:
            recommendations = recommendations.filter(soy_free=True)
        if customizations.meals_per_day:
            recommendations = recommendations.filter(type__in=customizations.meals_per_day)

    # Consider high blood sugar levels
    if latest_health_record and latest_health_record.blood_glucose > 140:
        recommendations = recommendations.filter(no_sugar=True)

    # Check Nutritional Limits
    nutrition_summary = meals_today.aggregate(
        total_calories=Sum('calories'),
        total_protein=Sum('protein'),
        total_fats=Sum('fats'),
        total_carbs=Sum('carbs'),
        total_fiber=Sum('fiber'),
    )
    
    max_protein = customizations.max_protein if customizations else 100
    max_fat = customizations.max_fat if customizations else 100
    max_fiber = customizations.max_fiber if customizations else 100
    max_cholesterol = customizations.max_cholesterol if customizations else 100
    max_carbs = customizations.max_carbs if customizations else 100

    buffer_factor = 1.1

    remaining_protein = max_protein - (nutrition_summary['total_protein'] or 0)
    remaining_fat = max_fat - (nutrition_summary['total_fats'] or 0)
    remaining_fiber = max_fiber - (nutrition_summary['total_fiber'] or 0)
    remaining_cholesterol = max_cholesterol - total_cholesterol_today
    remaining_carbs = max_carbs - (nutrition_summary['total_carbs'] or 0)

    # Adjust the filtering to be more lenient
    filtered_recommendations = recommendations.filter(
        Q(protein__lte=remaining_protein * buffer_factor) |
        Q(fat__lte=remaining_fat * buffer_factor) |
        Q(fiber__lte=remaining_fiber * buffer_factor) |
        Q(cholesterol__lte=remaining_cholesterol * buffer_factor) |
        Q(carbs__lte=remaining_carbs * buffer_factor)
    )

    # Ensure at least two recommendations from each category if filtering is too restrictive
    min_recommendations_per_category = 2
    categories = recommendations.values_list('category', flat=True).distinct()
    final_recommendations = []

    for category in categories:
        category_recommendations = filtered_recommendations.filter(category=category)
        if category_recommendations.count() < min_recommendations_per_category:
            fallback_recommendations = recommendations.filter(category=category)[:min_recommendations_per_category]
            final_recommendations.extend(fallback_recommendations)
        else:
            final_recommendations.extend(category_recommendations[:min_recommendations_per_category])

    # Serialize and Return Recommendations
    serializer = RecommendationSerializer(final_recommendations, many=True, context={'request': request})
    
    return Response(serializer.data, status=status.HTTP_200_OK)



@api_view(['GET'])
def user_recommendation(request, user_id):
    # Step 1: Retrieve User Data
    user = get_object_or_404(User, id=user_id)
    customizations = Customizations.objects.filter(user=user, created_at__date=today).order_by('-created_at').first()
    meals_today = Meal.objects.filter(user=user, created_at__date=timezone.now().date())
    latest_health_record = HealthRecord.objects.filter(user=user).order_by('-created_at').first()
    
    # Debug Statements
    print(f"User: {user}")
    print(f"Customizations: {customizations}")
    print(f"Meals Today: {meals_today}")
    print(f"Latest Health Record: {latest_health_record}")

    # Step 2: Calculate Total Cholesterol from Meals
    total_cholesterol_today = meals_today.aggregate(total_cholesterol=Sum('cholesterol'))['total_cholesterol'] or 0
    print(f"Total Cholesterol Today: {total_cholesterol_today}")

    # Step 3: Filter Recommendations Based on Customizations and Health Records
    recommendations = Recommendation.objects.all()
    if customizations:
        if 'low_fat' in customizations.diets_followed:
            recommendations = recommendations.filter(low_fat=True)
        if 'low_carb' in customizations.diets_followed:
            recommendations = recommendations.filter(low_carb=True)
        if 'high_protein' in customizations.diets_followed:
            recommendations = recommendations.filter(high_protein=True)
        if 'no_sugar' in customizations.diets_followed:
            recommendations = recommendations.filter(no_sugar=True)
        if 'wheat_free' in customizations.allergies:
            recommendations = recommendations.filter(wheat_free=True)
        if 'egg_free' in customizations.allergies:
            recommendations = recommendations.filter(egg_free=True)
        if 'soy_free' in customizations.allergies:
            recommendations = recommendations.filter(soy_free=True)
        if customizations.meals_per_day:
            recommendations = recommendations.filter(type__in=customizations.meals_per_day)

    # Consider high blood sugar levels
    if latest_health_record and latest_health_record.blood_glucose > 140:  # Example threshold for high blood sugar
        recommendations = recommendations.filter(no_sugar=True)
    
    # Debug Statement
    print(f"Filtered Recommendations after Customizations and Health Records: {recommendations}")

    # Step 4: Check Nutritional Limits
    nutrition_summary = meals_today.aggregate(
        total_calories=Sum('calories'),
        total_protein=Sum('protein'),
        total_fats=Sum('fats'),
        total_carbs=Sum('carbs'),
        total_fiber=Sum('fiber'),
    )
    print(f"Nutrition Summary: {nutrition_summary}")
    
    max_protein = customizations.max_protein if customizations else 100
    max_fat = customizations.max_fat if customizations else 100
    max_fiber = customizations.max_fiber if customizations else 100
    max_cholesterol = customizations.max_cholesterol if customizations else 100
    max_carbs = customizations.max_carbs if customizations else 100

    # Allow a small buffer (e.g., 10%) for nutritional limits
    buffer_factor = 5.1

    remaining_protein = max_protein - (nutrition_summary['total_protein'] or 0)
    remaining_fat = max_fat - (nutrition_summary['total_fats'] or 0)
    remaining_fiber = max_fiber - (nutrition_summary['total_fiber'] or 0)
    remaining_cholesterol = max_cholesterol - total_cholesterol_today
    remaining_carbs = max_carbs - (nutrition_summary['total_carbs'] or 0)

    recommendations = recommendations.filter(
        Q(protein__lte=remaining_protein * buffer_factor) |
        Q(fat__lte=remaining_fat * buffer_factor) |
        Q(fiber__lte=remaining_fiber * buffer_factor) |
        Q(cholesterol__lte=remaining_cholesterol * buffer_factor) |
        Q(carbs__lte=remaining_carbs * buffer_factor)
    )

    # Debug Statement
    print(f"Final Filtered Recommendations: {recommendations}")

    # Step 5: Serialize and Return Recommendations
    serializer = RecommendationSerializer(recommendations, many=True, context={'request': request})
    print(f"Serialized Recommendations: {serializer.data}")
    
    return Response(serializer.data, status=status.HTTP_200_OK)

'''
'''
@api_view(['GET'])
def user_recommendation(request, user_id):
    # Step 1: Retrieve User Data
    user = get_object_or_404(User, id=user_id)
    today = timezone.now().date()
    customizations = Customizations.objects.filter(user=user, created_at__date=today).order_by('-created_at').first()
    meals_today = Meal.objects.filter(user=user, created_at__date=today)
    latest_health_record = HealthRecord.objects.filter(user=user).order_by('-created_at').first()
    
    # Debug Statements
    print(f"User: {user}")
    print(f"Customizations: {customizations}")
    print(f"Meals Today: {meals_today}")
    print(f"Latest Health Record: {latest_health_record}")

    # Step 2: Calculate Total Cholesterol from Meals
    total_cholesterol_today = meals_today.aggregate(total_cholesterol=Sum('cholesterol'))['total_cholesterol'] or 0
    print(f"Total Cholesterol Today: {total_cholesterol_today}")

    # Step 3: Filter Recommendations Based on Customizations and Health Records
    recommendations = Recommendation.objects.all()
    if customizations:
        if 'low_fat' in customizations.diets_followed:
            recommendations = recommendations.filter(low_fat=True)
        if 'low_carb' in customizations.diets_followed:
            recommendations = recommendations.filter(low_carb=True)
        if 'high_protein' in customizations.diets_followed:
            recommendations = recommendations.filter(high_protein=True)
        if 'no_sugar' in customizations.diets_followed:
            recommendations = recommendations.filter(no_sugar=True)
        if 'wheat_free' in customizations.allergies:
            recommendations = recommendations.filter(wheat_free=True)
        if 'egg_free' in customizations.allergies:
            recommendations = recommendations.filter(egg_free=True)
        if 'soy_free' in customizations.allergies:
            recommendations = recommendations.filter(soy_free=True)
        if customizations.meals_per_day:
            recommendations = recommendations.filter(type__in=customizations.meals_per_day)

    # Consider high blood sugar levels
    if latest_health_record and latest_health_record.blood_glucose > 140:  # Example threshold for high blood sugar
        recommendations = recommendations.filter(no_sugar=True)
    
    # Debug Statement
    print(f"Filtered Recommendations after Customizations and Health Records: {recommendations}")

    # Step 4: Check Nutritional Limits
    nutrition_summary = meals_today.aggregate(
        total_calories=Sum('calories'),
        total_protein=Sum('protein'),
        total_fats=Sum('fats'),
        total_carbs=Sum('carbs'),
        total_fiber=Sum('fiber'),
    )
    print(f"Nutrition Summary: {nutrition_summary}")
    
    max_protein = customizations.max_protein if customizations else 100
    max_fat = customizations.max_fat if customizations else 100
    max_fiber = customizations.max_fiber if customizations else 100
    max_cholesterol = customizations.max_cholesterol if customizations else 100
    max_carbs = customizations.max_carbs if customizations else 100

    # Allow a small buffer (e.g., 10%) for nutritional limits
    buffer_factor = 1.1

    remaining_protein = max_protein - (nutrition_summary['total_protein'] or 0)
    remaining_fat = max_fat - (nutrition_summary['total_fats'] or 0)
    remaining_fiber = max_fiber - (nutrition_summary['total_fiber'] or 0)
    remaining_cholesterol = max_cholesterol - total_cholesterol_today
    remaining_carbs = max_carbs - (nutrition_summary['total_carbs'] or 0)

    recommendations = recommendations.filter(
        Q(protein__lte=remaining_protein * buffer_factor) &
        Q(fat__lte=remaining_fat * buffer_factor) &
        Q(fiber__lte=remaining_fiber * buffer_factor) &
        Q(cholesterol__lte=remaining_cholesterol * buffer_factor) &
        Q(carbs__lte=remaining_carbs * buffer_factor)
    )

    # Debug Statement
    print(f"Final Filtered Recommendations: {recommendations}")

    # Step 5: Serialize and Return Recommendations
    serializer = RecommendationSerializer(recommendations, many=True, context={'request': request})
    print(f"Serialized Recommendations: {serializer.data}")
    
    return Response(serializer.data, status=status.HTTP_200_OK)

'''