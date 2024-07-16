import 'package:flutter/material.dart';
import 'register_page.dart';
import '../widgets/custom_header.dart';
import '../utils/utilities.dart';

class FamilyHistoryPage extends StatefulWidget {
  const FamilyHistoryPage({super.key});

  @override
  _FamilyHistoryPageState createState() => _FamilyHistoryPageState();
}

class _FamilyHistoryPageState extends State<FamilyHistoryPage> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 141, 87, 255),
      appBar: CustomHeader(
        imagePath: 'assets/images/diabetesLogo.png',
        welcomeMessage: 'Select Carefully!',
        showWelcomeMessage: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyFamilyHistory(),
          ),
          //footer(),
        ],
      ),
    );
  }

  Widget bodyFamilyHistory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/diabetesLogo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.white),
                children: <TextSpan>[
                  TextSpan(text: 'Do you have '),
                  TextSpan(
                    text: 'Family History',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' with '),
                  TextSpan(
                    text: 'Diabetes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' ?'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CustomToggleButtons(
              options: const ['Yes', 'No'],
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    isSelected[buttonIndex] = buttonIndex == index;
                  }
                });
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    foregroundColor: Colors.white,
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white.withOpacity(0.2);
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    foregroundColor: Colors.white,
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white.withOpacity(0.2);
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                  onPressed: () {
                    bool familyHistory = isSelected[0];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          familyHistory: familyHistory,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



/*from mongoengine import Document, EmbeddedDocument, EmbeddedDocumentListField, StringField, BooleanField, EmbeddedDocumentField, FloatField, DateTimeField, DictField, IntField
import datetime
class Preferences(EmbeddedDocument):
    # Define fields for preferences
    preferences = DictField(required=True)  # Store user preferences in Dict format

class HealthRecords(EmbeddedDocument):
    blood_glucose = FloatField(required=True)
    blood_pressure = StringField(required=True)  # Format: '120/80'
    bmi = FloatField(required=True)
    weight = FloatField(required=True)
class PhysicalActivity(EmbeddedDocument):
    duration = StringField(required=True)  # Format: '30 minutes'
    type = StringField(required=True)   # Format: 'Gym'

class PhysicalRecords(EmbeddedDocument):
    physical_activity = EmbeddedDocument(PhysicalActivity) # Description of 
    stress_level = IntField(required=True)  # Assuming a scale of 1-10

class Meal(EmbeddedDocument):
    number = IntField(required=True)
    name = StringField(required=True)
    quantity = FloatField(required=True)  # Assuming grams or other unit
    nutrients = DictField(required=True)  # Store detailed nutrients info in Dict format

class DailyRecord(EmbeddedDocument):
    date = DateTimeField(default=lambda: datetime.datetime.now())
    health_record = EmbeddedDocumentField(HealthRecords, required=True)
    physical_record = EmbeddedDocumentField(PhysicalRecords, required=True)
    meals = EmbeddedDocumentListField(Meal)
    diabetes_risk = FloatField(required=True)  # Assuming risk is a percentage

class MonthlyRecord(EmbeddedDocument):
    month = DateTimeField(required=True)
    avg_blood_glucose = FloatField(required=True)
    avg_blood_pressure = StringField(required=True)  # Format: '120/80'
    avg_calories = FloatField(required=True)
    avg_bmi = FloatField(required=True)
    weight_increase = FloatField(required=True)
    monthly_risk = FloatField(required=True)
    overall_health_status = StringField(required=True)

class MealRecommendation(EmbeddedDocument):
    recommendations = DictField(required=True)  # Store recommendations in Dict format

class User(Document):
    name = StringField(required=True)
    email = StringField(required=True, unique=True)
    password = StringField(required=True)
    gender = StringField(required=True)
    marital_status = StringField(required=True)
    height = StringField(required=True)
    birthdate = StringField(required=True)
    family_history = BooleanField(required=True)
    profile_picture = StringField()  # Store the path to the profile picture
    preferences = EmbeddedDocumentField(Preferences)
    health_records = EmbeddedDocumentListField(HealthRecords)
    physical_records = EmbeddedDocumentListField(PhysicalRecords)
    meal_recommendation = EmbeddedDocumentField(MealRecommendation)
    daily_records = EmbeddedDocumentListField(DailyRecord)
    monthly_records = EmbeddedDocumentListField(MonthlyRecord)
    user_notification = StringField()  # Define user notification field as needed

////////////////////////////////////////

    from mongoengine import Document, EmbeddedDocument, EmbeddedDocumentListField, StringField, BooleanField, EmbeddedDocumentField, FileField

class Preferences(EmbeddedDocument):
    # Define fields for preferences
    example_field = StringField()  # Example field, replace with actual fields

class HealthRecords(EmbeddedDocument):
    # Define fields for health records
    record_type = StringField()
    value = StringField()

class PhysicalRecords(EmbeddedDocument):
    # Define fields for physical records
    activity_type = StringField()
    duration = StringField()

class MealRecommendation(EmbeddedDocument):
    # Define fields for meal recommendation
    meal_type = StringField()
    description = StringField()

class User(Document):
    name = StringField(required=True)
    email = StringField(required=True, unique=True)
    password = StringField(required=True)
    gender = StringField(required=True)
    marital_status = StringField(required=True)
    height = StringField(required=True)
    birthdate = StringField(required=True)
    family_history = BooleanField(required=True)
    profile_picture = StringField()  # Store the path to the profile picture
    preferences = EmbeddedDocumentField(Preferences)
    health_records = EmbeddedDocumentListField(HealthRecords)
    physical_records = EmbeddedDocumentListField(PhysicalRecords)
    meal_recommendation = EmbeddedDocumentField(MealRecommendation)
    user_notification = StringField()  # Define user notification field as needed









    ////////////
    ///#serialize
#from rest_framework_mongoengine import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
#from .models import User
from rest_framework import serializers  # Import serializers from Django REST framework
from .models import User, Preferences, HealthRecords, PhysicalActivity, PhysicalRecords, Meal, DailyRecord, MonthlyRecord, MealRecommendation


class PreferencesSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for Preferences embedded document.

    This serializer handles the serialization and deserialization of Preferences instances.
    """
    class Meta:
        model = Preferences
        fields = '__all__'

class HealthRecordsSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for HealthRecords embedded document.

    This serializer handles the serialization and deserialization of HealthRecords instances.
    """
    class Meta:
        model = HealthRecords
        fields = '__all__'

class PhysicalActivitySerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for PhysicalActivity embedded document.

    This serializer handles the serialization and deserialization of PhysicalActivity instances.
    """
    class Meta:
        model = PhysicalActivity
        fields = '__all__'

class PhysicalRecordsSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for PhysicalRecords embedded document.

    This serializer handles the serialization and deserialization of PhysicalRecords instances.
    It includes a nested serializer for PhysicalActivity.
    """
    physical_activity = PhysicalActivitySerializer()

    class Meta:
        model = PhysicalRecords
        fields = '__all__'

class MealSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for Meal embedded document.

    This serializer handles the serialization and deserialization of Meal instances.
    """
    class Meta:
        model = Meal
        fields = '__all__'

class DailyRecordSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for DailyRecord embedded document.

    This serializer handles the serialization and deserialization of DailyRecord instances.
    It includes nested serializers for HealthRecords, PhysicalRecords, and Meal.
    """
    health_record = HealthRecordsSerializer()
    physical_record = PhysicalRecordsSerializer()
    meals = MealSerializer(many=True)

    class Meta:
        model = DailyRecord
        fields = '__all__'

class MonthlyRecordSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for MonthlyRecord embedded document.

    This serializer handles the serialization and deserialization of MonthlyRecord instances.
    """
    class Meta:
        model = MonthlyRecord
        fields = '__all__'

class MealRecommendationSerializer(serializers.EmbeddedDocumentSerializer):
    """
    Serializer for MealRecommendation embedded document.

    This serializer handles the serialization and deserialization of MealRecommendation instances.
    """
    class Meta:
        model = MealRecommendation
        fields = '__all__'

class UserSerializer(serializers.DocumentSerializer):
    """
    Serializer for User model.

    This serializer handles the serialization and deserialization of User model instances.
    It converts complex User model instances into native Python datatypes that can be
    easily rendered into JSON, XML, or other content types. Additionally, it can validate
    data when updating or creating User instances.

    Attributes:
        Meta (class): Meta options for the UserSerializer.
            model (User): The model class that is being serialized.
            fields (str): A special field name '__all__' indicates that all fields in the model
                          should be included in the serialization.
    """
    preferences = PreferencesSerializer()
    health_records = HealthRecordsSerializer(many=True)
    physical_records = PhysicalRecordsSerializer(many=True)
    meal_recommendation = MealRecommendationSerializer()
    daily_records = DailyRecordSerializer(many=True)
    monthly_records = MonthlyRecordSerializer(many=True)

    class Meta:
        model = User
        fields = '__all__'

    def create(self, validated_data):
        """
        Create and return a new User instance, given the validated data.

        This method extracts nested data for embedded documents, creates instances
        of these embedded documents, and associates them with the newly created User instance.
        """
        preferences_data = validated_data.pop('preferences')
        health_records_data = validated_data.pop('health_records')
        physical_records_data = validated_data.pop('physical_records')
        meal_recommendation_data = validated_data.pop('meal_recommendation')
        daily_records_data = validated_data.pop('daily_records')
        monthly_records_data = validated_data.pop('monthly_records')

        preferences = Preferences.objects.create(**preferences_data)
        user = User.objects.create(preferences=preferences, **validated_data)

        for health_record_data in health_records_data:
            HealthRecords.objects.create(user=user, **health_record_data)
        
        for physical_record_data in physical_records_data:
            PhysicalRecords.objects.create(user=user, **physical_record_data)

        MealRecommendation.objects.create(user=user, **meal_recommendation_data)

        for daily_record_data in daily_records_data:
            DailyRecord.objects.create(user=user, **daily_record_data)

        for monthly_record_data in monthly_records_data:
            MonthlyRecord.objects.create(user=user, **monthly_record_data)

        return user

    def update(self, instance, validated_data):
        """
        Update and return an existing User instance, given the validated data.

        This method extracts nested data for embedded documents, updates instances
        of these embedded documents, and associates them with the User instance.
        Existing nested documents are deleted and recreated to simplify the update process.
        """
        preferences_data = validated_data.pop('preferences', None)
        health_records_data = validated_data.pop('health_records', None)
        physical_records_data = validated_data.pop('physical_records', None)
        meal_recommendation_data = validated_data.pop('meal_recommendation', None)
        daily_records_data = validated_data.pop('daily_records', None)
        monthly_records_data = validated_data.pop('monthly_records', None)

        if preferences_data:
            for attr, value in preferences_data.items():
                setattr(instance.preferences, attr, value)
            instance.preferences.save()

        if health_records_data:
            instance.health_records.all().delete()
            for health_record_data in health_records_data:
                HealthRecords.objects.create(user=instance, **health_record_data)

        if physical_records_data:
            instance.physical_records.all().delete()
            for physical_record_data in physical_records_data:
                PhysicalRecords.objects.create(user=instance, **physical_record_data)

        if meal_recommendation_data:
            for attr, value in meal_recommendation_data.items():
                setattr(instance.meal_recommendation, attr, value)
            instance.meal_recommendation.save()

        if daily_records_data:
            instance.daily_records.all().delete()
            for daily_record_data in daily_records_data:
                DailyRecord.objects.create(user=instance, **daily_record_data)

        if monthly_records_data:
            instance.monthly_records.all().delete()
            for monthly_record_data in monthly_records_data:
                MonthlyRecord.objects.create(user=instance, **monthly_record_data)

        for attr, value in validated_data.items():
            setattr(instance, attr, value)

        instance.save()
        return instance



class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Custom TokenObtainPairSerializer.

    This serializer extends the TokenObtainPairSerializer to include additional claims
    in the JWT token and user details in the response data.

    Methods:
        get_token(user): Adds custom claims to the JWT token.
        validate(attrs): Adds user details to the validated response data.
    """

    @classmethod
    def get_token(cls, user):
        """
        Add custom claims to the JWT token.

        This method adds custom user attributes (name, email, gender, etc.) to the token payload.

        Args:
            user (User): The user instance for which the token is generated.

        Returns:
            token (RefreshToken): The token instance with added custom claims.
        """
        token = super().get_token(user)

        # Add custom claims
        token['name'] = user.name
        token['email'] = user.email
        token['gender'] = user.gender
        token['marital_status'] = user.marital_status
        token['height'] = user.height
        token['birthdate'] = user.birthdate
        token['family_history'] = user.family_history
        token['profile_picture'] = user.profile_picture

        return token

    def validate(self, attrs):
        """
        Add user details to the validated response data.

        This method extends the default validation to include user details in the response.

        Args:
            attrs (dict): The input data containing the user's credentials.

        Returns:
            data (dict): The validated response data including the JWT token and user details.
        """
        data = super().validate(attrs)

        # Add user details to the response data
        data.update({
            'user': {
                'name': self.user.name,
                'email': self.user.email,
                'gender': self.user.gender,
                'marital_status': self.user.marital_status,
                'height': self.user.height,
                'birthdate': self.user.birthdate,
                'family_history': self.user.family_history,
                'profile_picture': self.user.profile_picture
                
            }
        })

        return data



/////////////////////
///view
///from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import check_password, make_password
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from .models import User
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from .utils import MyTokenObtainPairSerializer
import json
import logging
from .serializers import MyTokenObtainPairSerializer

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

logger = logging.getLogger(__name__)

@csrf_exempt
def register(request):
    """
    Handle user registration.

    This view handles the registration of a new user by processing a POST request with multipart form data. 
    The expected fields are name, email, password, gender, marital_status, height, birthdate, family_history,
    and an optional file upload for a profile_picture.

    The function performs the following steps:
    1. Verify that the request method is POST.
    2. Check if a user with the given email already exists in the database to prevent duplicate entries.
    3. Hash the provided password for secure storage using Django's make_password function.
    4. Optionally save the uploaded profile picture in a designated directory and record its path.
    5. Create a new User instance with all provided and processed data.
    6. Save the new User instance to the database.
    7. Return a JSON response indicating successful registration or provide an error message with appropriate HTTP status codes.

    Args:
        request (HttpRequest): The HTTP request object that carries all HTTP headers, the multipart form data, and files.

    Returns:
        JsonResponse: A JSON response that contains a success message or an error message. On success, it returns status code 201,
                      and on various failures, it returns status code 400 (bad request) or 405 (method not allowed).
    """
    if request.method == 'POST':
        try:
            # Parse the form data from the request body
            data = request.POST

            # Check if a user with the given email already exists
            if User.objects(email=data['email']).first():
                logger.error(f"Email {data['email']} already exists.")
                return JsonResponse({'error': 'Email already exists.'}, status=400)
            
            # Hash the provided password
            hashed_password = make_password(data['password'])
            logger.debug(f"Hashed password for {data['email']}")

            # Handle the profile picture
            profile_picture_path = None
            if 'profile_picture' in request.FILES:
                profile_picture = request.FILES['profile_picture']
                file_name = default_storage.save(f'profile_pictures/{profile_picture.name}', ContentFile(profile_picture.read()))
                profile_picture_path = default_storage.url(file_name)
                logger.debug(f"Profile picture saved at {profile_picture_path}")

            # Create a new User object with the provided data and hashed password
            user = User(
                name=data['name'],
                email=data['email'],
                password=hashed_password,
                gender=data['gender'],
                marital_status=data['marital_status'],
                height=data['height'],
                birthdate=data['birthdate'],
                family_history=data['family_history'],
                profile_picture=profile_picture_path
            )
            
            # Save the new User object to the database
            user.save()
            logger.info(f"User {data['email']} registered successfully")
            
            # Return a success response
            return JsonResponse({'message': 'Registration successful'}, status=201)
        
        except Exception as e:
            logger.error(f"Exception during registration: {str(e)}")
            return JsonResponse({'error': str(e)}, status=400)
    
    # Return an error response if the request method is not POST
    logger.error("Invalid method")
    return JsonResponse({'error': 'Invalid method'}, status=405)


@csrf_exempt
def login(request):
    """
    Handle user login.

    This view handles the login of a user by processing a POST request with JSON data.
    The expected fields are email and password.

    The function performs the following steps:
    1. Verify that the request method is POST.
    2. Parse the JSON data from the request body.
    3. Check if a user with the given email exists in the database.
    4. Verify the provided password against the stored hashed password.
    5. Generate a JWT token for the authenticated user.
    6. Return a JSON response with the token and user details on success.

    Args:
        request (HttpRequest): The HTTP request object that carries all HTTP headers and JSON data.

    Returns:
        JsonResponse: A JSON response that contains a success message with user details and a JWT token on success,
                      and an error message on failure. On success, it returns status code 200,
                      and on failure, it returns status code 400 (bad request) or 405 (method not allowed).
    """
    if request.method == 'POST':
        try:
            # Parse the JSON data from the request body
            data = json.loads(request.body)

            # Check if a user with the given email exists
            user = User.objects(email=data['email']).first()
            if not user:
                return JsonResponse({'error': 'Invalid email or password.'}, status=400)

            # Verify the provided password
            if not check_password(data['password'], user.password):
                return JsonResponse({'error': 'Invalid email or password.'}, status=400)

            # Generate JWT token
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)

            # Prepare user data for the response
            user_data = {
                'name': user.name,
                'email': user.email,
                'gender': user.gender,
                'marital_status': user.marital_status,
                'height': user.height,
                'birthdate': user.birthdate,
                'family_history': user.family_history,
                'profile_picture': user.profile_picture
                
            }

            # Print the user data and token to debug
            print("User Data:", user_data)
            print("Access Token:", access_token)

            # Return a success response with user details and token
            return JsonResponse({'message': 'Login successful', 'token': access_token, 'user': user_data}, status=200)
        
        except Exception as e:
            logger.error(f"Exception during login: {str(e)}")
            return JsonResponse({'error': str(e)}, status=400)

    # Return an error response if the request method is not POST
    logger.error("Invalid method")
    return JsonResponse({'error': 'Invalid method'}, status=405)




url///////////////////
# In your urls.py
from django.urls import path
from .views import register, MyTokenObtainPairView

from django.urls import path
from .views import register, login

urlpatterns = [
    path('register/', register, name='register'),
    path('login/', login, name='login'),
    path('api/token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
]


*/