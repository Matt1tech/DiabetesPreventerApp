from rest_framework.throttling import AnonRateThrottle, UserRateThrottle


class RegistrationThrottle(AnonRateThrottle):
    scope = 'registration'


class LoginThrottle(AnonRateThrottle):
    scope = 'login'


class PasswordResetRequestThrottle(AnonRateThrottle):
    scope = 'password_reset_request'


class PasswordResetVerifyThrottle(AnonRateThrottle):
    scope = 'password_reset_verify'


class FoodAnalysisThrottle(UserRateThrottle):
    scope = 'food_analysis'
