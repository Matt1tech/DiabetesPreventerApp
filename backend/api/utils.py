from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
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
        data = super().validate(attrs)

        # Include additional response data
        data.update({'user': {
            'name': self.user.name,
            'email': self.user.email,
            'gender': self.user.gender,
            'marital_status': self.user.marital_status,
            'height': self.user.height,
            'birthdate': self.user.birthdate,
            'family_history': self.user.family_history,
            'profile_picture': self.user.profile_picture,
        }})

        return data
