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
