from datetime import date

from django.core.files.uploadedfile import SimpleUploadedFile
from django.core.exceptions import ValidationError
from django.test import TestCase, override_settings
from rest_framework.test import APIClient
from rest_framework_simplejwt.tokens import RefreshToken

from .models import User
from .serializers import UserSerializer
from .uploads import validate_image_upload


def create_test_user(email):
    user = User(
        name='Example User',
        email=email,
        gender='other',
        marital_status='single',
        height=170,
        birthdate=date(1990, 1, 1),
        family_history=False,
    )
    user.set_password('Only-for-tests-2026!')
    user.save()
    return user


class SecurityRegressionTests(TestCase):
    def setUp(self):
        self.owner = create_test_user('owner@example.test')
        self.other = create_test_user('other@example.test')
        self.client = APIClient()
        self.client.force_authenticate(user=self.owner)

    def test_user_serializer_never_exposes_authentication_secrets(self):
        data = UserSerializer(self.owner).data
        self.assertNotIn('password', data)
        self.assertNotIn('otp', data)
        self.assertNotIn('otp_expiration', data)

    def test_user_cannot_read_another_users_nutrition(self):
        response = self.client.get(
            f'/total_daily_nutrition/{self.other.pk}/', secure=True
        )
        self.assertEqual(response.status_code, 403)

    def test_protected_endpoint_rejects_anonymous_requests(self):
        self.client.force_authenticate(user=None)
        response = self.client.get(
            f'/total_daily_nutrition/{self.owner.pk}/', secure=True
        )
        self.assertEqual(response.status_code, 401)

    def test_logout_revokes_existing_access_token(self):
        refresh = RefreshToken.for_user(self.owner)
        refresh['token_version'] = self.owner.token_version
        access = str(refresh.access_token)

        client = APIClient()
        client.credentials(HTTP_AUTHORIZATION=f'Bearer {access}')
        self.assertEqual(client.post('/logout/', secure=True).status_code, 205)
        response = client.get(
            f'/total_daily_nutrition/{self.owner.pk}/', secure=True
        )
        self.assertEqual(response.status_code, 401)

    @override_settings(MAX_IMAGE_UPLOAD_BYTES=1024)
    def test_invalid_image_is_rejected(self):
        upload = SimpleUploadedFile(
            'not-an-image.jpg', b'not an image', content_type='image/jpeg'
        )
        with self.assertRaises(ValidationError):
            validate_image_upload(upload)
