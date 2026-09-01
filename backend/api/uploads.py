from pathlib import Path
from uuid import uuid4
import warnings

from django.conf import settings
from django.core.exceptions import ValidationError
from django.core.files.storage import default_storage
from PIL import Image, UnidentifiedImageError


ALLOWED_IMAGE_TYPES = {
    'image/jpeg': '.jpg',
    'image/png': '.png',
    'image/webp': '.webp',
}


def validate_image_upload(upload):
    if upload.size > settings.MAX_IMAGE_UPLOAD_BYTES:
        raise ValidationError('Image exceeds the configured upload limit.')

    extension = ALLOWED_IMAGE_TYPES.get(upload.content_type)
    if not extension:
        raise ValidationError('Only JPEG, PNG, and WebP images are allowed.')

    try:
        upload.seek(0)
        with warnings.catch_warnings():
            warnings.simplefilter('error', Image.DecompressionBombWarning)
            with Image.open(upload) as image:
                image.verify()
    except (
        UnidentifiedImageError,
        Image.DecompressionBombError,
        Image.DecompressionBombWarning,
        OSError,
        ValueError,
    ) as exc:
        raise ValidationError('The uploaded file is not a valid image.') from exc
    finally:
        upload.seek(0)

    return extension


def save_profile_picture(upload):
    extension = validate_image_upload(upload)
    safe_name = f'{uuid4().hex}{extension}'
    return default_storage.save(str(Path('profile_pictures') / safe_name), upload)


def delete_profile_picture(stored_path):
    """Delete only files inside the managed profile-picture namespace."""
    if not stored_path:
        return
    normalized = str(stored_path).replace('\\', '/').lstrip('/')
    parts = Path(normalized).parts
    if not parts or parts[0] != 'profile_pictures' or '..' in parts:
        return
    default_storage.delete(normalized)
