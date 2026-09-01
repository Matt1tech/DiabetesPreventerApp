from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import AuthenticationFailed

from .models import User


class CustomJWTAuthentication(JWTAuthentication):
    """Resolve JWT identities against the project's existing custom user table."""

    def get_user(self, validated_token):
        try:
            user_id = validated_token['user_id']
        except KeyError as exc:
            raise AuthenticationFailed(
                'Token contained no recognizable user identification'
            ) from exc

        try:
            user = User.objects.get(pk=user_id)
        except User.DoesNotExist as exc:
            raise AuthenticationFailed('User not found') from exc

        if validated_token.get('token_version') != user.token_version:
            raise AuthenticationFailed('Token has been revoked')
        return user
