# model_utils.py
from functools import lru_cache

from django.conf import settings
from django.core.exceptions import ImproperlyConfigured
import joblib


@lru_cache(maxsize=1)
def get_model():
    """Load the private model lazily so documentation and API setup still run without it."""
    model_path = settings.DIABETES_MODEL_PATH
    if not model_path.is_file():
        raise ImproperlyConfigured(
            'The diabetes model is unavailable. Set DIABETES_MODEL_PATH to a private model file.'
        )
    return joblib.load(model_path)
