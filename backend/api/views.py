from django.http import JsonResponse
from django.contrib.auth.hashers import check_password, make_password
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .serializers import UserSerializer
from .models import User
from rest_framework.permissions import AllowAny
from .models import User, Preferences, HealthRecord
from .serializers import UserSerializer, PreferencesSerializer, HealthRecordsSerializer
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.decorators import parser_classes
from django.contrib.auth import authenticate
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.token_blacklist.models import BlacklistedToken
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
@permission_classes([IsAuthenticated])
def logout(request):
    try:
        # For debugging purposes, print the user info and request data
        print(f"Logging out user: {request.user}")
        print(f"Request data: {request.data}")

        # Simply respond with success
        return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)
    except Exception as e:
        print(f"Error during logout: {str(e)}")
        return Response({"error": "An error occurred during logout"}, status=status.HTTP_400_BAD_REQUEST)







    """
    
    
@api_view(['GET'])
def getUser(request, pk):
    try:
        user = User.objects.get(userId=pk)
        if not user:
            return Response({'error': 'User not found'}, status=404)

        # Fetch all health records related to the user
        health_records = user.health_records.all()

        # Debugging output
        print("User:", user)
        print("User Health Records:", health_records)

        if health_records:
            latest_health_record = health_records.order_by('-id').first()
            print("Latest health record:", latest_health_record)
        else:
            latest_health_record = None

        user_data = {
            'profile_picture': user.profile_picture,
            'blood_glucose': latest_health_record.blood_glucose if latest_health_record else None,
            'blood_pressure': latest_health_record.blood_pressure if latest_health_record else None,
            'bmi': latest_health_record.bmi if latest_health_record else None
        }

        return Response(user_data)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)
    


@api_view(['GET'])
def getUserEmail(request, pk):
    try:
        user = User.objects.get(userId=pk)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    
    return Response({'email': user.email})

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @api_view(['DELETE'])
def deleteUserProfilePicture(request, pk):
    try:
        user_data = User.objects.get(userId=pk)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)

    # Set profile_picture field to None or an empty string to remove it
    user_data.profile_picture = None  # or "" if your field does not accept None
    
    user_data.save()
    return Response('Profile Picture Successfully Deleted')
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @api_view(['POST'])
def createUserData(request):
    try:
        # Extract user data from the request
        user_data = request.data

        # Create or get the Preferences object
        preferences_data = user_data.pop('preferences', None)
        if preferences_data:
            preferences, created = Preferences.objects.get_or_create(**preferences_data)

        # Create the User object
        user = User.objects.create(**user_data)
        if preferences_data:
            user.preferences = preferences
            user.save()

        # Handle health records
        health_records_data = user_data.pop('health_records', [])
        for record_data in health_records_data:
            HealthRecord.objects.create(user=user, **record_data)

        # Serialize and return the created user
        serializer = UserSerializer(user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @api_view(['GET'])
def getUsers(request):
    user_data = User.objects.all()
    serializer = UserSerializer(user_data, many=True)
    return Response(serializer.data)


#@api_view(['GET'])
#def getUser(request, pk):
 #   user_data = User.objects.get(userId=pk)
  #  serializer = UserSerializer(user_data, many=False)
   # return Response(serializer.data)
    
    
    
    
    
    
    
    
    
    
    
    @api_view(['GET'])
def getRoutes(request):
    routes = [
            {
                'Endpoint': '/notes/',
                'method': 'GET',
                'body': None,
                'description': 'Returns an array of notes'
            },
            {
                'Endpoint': '/notes/id/',
                'method': 'GET',
                'body': None,
                'description': 'Returns a single note object'
            },
            {
                'Endpoint': '/notes/create/',
                'method': 'POST',
                'body': {'body': ""},
                'description': 'Creates a new note'
            },
            {
                'Endpoint': '/notes/update/id/',
                'method': 'PUT',
                'body': {'body': ""},
                'description': 'Updates an existing note'
            },
            {
                'Endpoint': '/notes/delete/id/',
                'method': 'DELETE',
                'body': None,
                'description': 'Deletes a note'
            }
        ] 
    return Response(routes)


    """




# from django.http import JsonResponse
# from rest_framework.decorators import api_view
# from rest_framework.response import Response
# from django.views.decorators.csrf import csrf_exempt
# from django.contrib.auth.hashers import check_password, make_password
# from django.core.files.storage import default_storage
# from django.core.files.base import ContentFile
# from .models import User
# from rest_framework_simplejwt.tokens import RefreshToken
# from rest_framework_simplejwt.views import TokenObtainPairView
# from .utils import MyTokenObtainPairSerializer
# import json
# import logging
# from .serializers import MyTokenObtainPairSerializer

# # Custom TokenObtainPairView class using a custom serializer
# class MyTokenObtainPairView(TokenObtainPairView):
#     serializer_class = MyTokenObtainPairSerializer

# logger = logging.getLogger(__name__)

# @csrf_exempt
# def register(request):
#     """
#     Handle user registration.

#     This view handles the registration of a new user by processing a POST request with multipart form data. 
#     The expected fields are name, email, password, gender, marital_status, height, birthdate, family_history,
#     and an optional file upload for a profile_picture.

#     The function performs the following steps:
#     1. Verify that the request method is POST.
#     2. Check if a user with the given email already exists in the database to prevent duplicate entries.
#     3. Hash the provided password for secure storage using Django's make_password function.
#     4. Optionally save the uploaded profile picture in a designated directory and record its path.
#     5. Create a new User instance with all provided and processed data.
#     6. Save the new User instance to the database.
#     7. Return a JSON response indicating successful registration or provide an error message with appropriate HTTP status codes.

#     Args:
#         request (HttpRequest): The HTTP request object that carries all HTTP headers, the multipart form data, and files.

#     Returns:
#         JsonResponse: A JSON response that contains a success message or an error message. On success, it returns status code 201,
#                       and on various failures, it returns status code 400 (bad request) or 405 (method not allowed).
#     """
#     if request.method == 'POST':
#         try:
#             # Parse the form data from the request body
#             data = request.POST

#             # Check if a user with the given email already exists
#             if User.objects(email=data['email']).first():
#                 logger.error(f"Email {data['email']} already exists.")
#                 return JsonResponse({'error': 'Email already exists.'}, status=400)
            
#             # Hash the provided password
#             hashed_password = make_password(data['password'])
#             logger.debug(f"Hashed password for {data['email']}")

#             # Handle the profile picture
#             profile_picture_path = None
#             if 'profile_picture' in request.FILES:
#                 profile_picture = request.FILES['profile_picture']
#                 file_name = default_storage.save(f'profile_pictures/{profile_picture.name}', ContentFile(profile_picture.read()))
#                 profile_picture_path = default_storage.url(file_name)
#                 logger.debug(f"Profile picture saved at {profile_picture_path}")

#             # Create a new User object with the provided data and hashed password
#             user = User(
#                 name=data['name'],
#                 email=data['email'],
#                 password=hashed_password,
#                 gender=data['gender'],
#                 marital_status=data['marital_status'],
#                 height=data['height'],
#                 birthdate=data['birthdate'],
#                 family_history=data['family_history'],
#                 profile_picture=profile_picture_path
#             )
            
#             # Save the new User object to the database
#             user.save()
#             logger.info(f"User {data['email']} registered successfully")
            
#             # Return a success response
#             return JsonResponse({'message': 'Registration successful'}, status=201)
        
#         except Exception as e:
#             logger.error(f"Exception during registration: {str(e)}")
#             return JsonResponse({'error': str(e)}, status=400)
    
#     # Return an error response if the request method is not POST
#     logger.error("Invalid method")
#     return JsonResponse({'error': 'Invalid method'}, status=405)


# @csrf_exempt
# def login(request):
#     """
#     Handle user login.

#     This view handles the login of a user by processing a POST request with JSON data.
#     The expected fields are email and password.

#     The function performs the following steps:
#     1. Verify that the request method is POST.
#     2. Parse the JSON data from the request body.
#     3. Check if a user with the given email exists in the database.
#     4. Verify the provided password against the stored hashed password.
#     5. Generate a JWT token for the authenticated user.
#     6. Return a JSON response with the token and user details on success.

#     Args:
#         request (HttpRequest): The HTTP request object that carries all HTTP headers and JSON data.

#     Returns:
#         JsonResponse: A JSON response that contains a success message with user details and a JWT token on success,
#                       and an error message on failure. On success, it returns status code 200,
#                       and on failure, it returns status code 400 (bad request) or 405 (method not allowed).
#     """
#     if request.method == 'POST':
#         try:
#             # Parse the JSON data from the request body
#             data = json.loads(request.body)

#             # Check if a user with the given email exists
#             user = User.objects(email=data['email']).first()
#             if not user:
#                 return JsonResponse({'error': 'Invalid email or password.'}, status=400)

#             # Verify the provided password
#             if not check_password(data['password'], user.password):
#                 return JsonResponse({'error': 'Invalid email or password.'}, status=400)

#             # Generate JWT token
#             refresh = RefreshToken.for_user(user)
#             access_token = str(refresh.access_token)

#             # Prepare user data for the response
#             user_data = {
#                 'name': user.name,
#                 'email': user.email,
#                 'gender': user.gender,
#                 'marital_status': user.marital_status,
#                 'height': user.height,
#                 'birthdate': user.birthdate,
#                 'family_history': user.family_history,
#                 'profile_picture': user.profile_picture
#             }

#             # Print the user data and token to debug
#             print("User Data:", user_data)
#             print("Access Token:", access_token)

#             # Return a success response with user details and token
#             return JsonResponse({'message': 'Login successful', 'token': access_token, 'user': user_data}, status=200)
        
#         except Exception as e:
#             logger.error(f"Exception during login: {str(e)}")
#             return JsonResponse({'error': str(e)}, status=400)

#     # Return an error response if the request method is not POST
#     logger.error("Invalid method")
#     return JsonResponse({'error': 'Invalid method'}, status=405)
