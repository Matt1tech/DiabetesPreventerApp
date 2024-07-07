from rest_framework_mongoengine import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import User

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
    class Meta:
        model = User
        fields = '__all__'


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
