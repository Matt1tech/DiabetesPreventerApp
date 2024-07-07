from django.http import JsonResponse
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
