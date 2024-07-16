from rest_framework import serializers
from .models import Preferences, HealthRecords, PhysicalActivity, PhysicalRecords, Meal, DailyRecord, MonthlyRecord, MealRecommendation, User

class PreferencesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Preferences
        fields = '__all__'

class HealthRecordsSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthRecords
        fields = '__all__'

class PhysicalActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = PhysicalActivity
        fields = '__all__'

class PhysicalRecordsSerializer(serializers.ModelSerializer):
    physical_activity = PhysicalActivitySerializer()

    class Meta:
        model = PhysicalRecords
        fields = '__all__'

class MealSerializer(serializers.ModelSerializer):
    class Meta:
        model = Meal
        fields = '__all__'

class DailyRecordSerializer(serializers.ModelSerializer):
    health_record = HealthRecordsSerializer()
    physical_record = PhysicalRecordsSerializer()
    meals = MealSerializer(many=True)

    class Meta:
        model = DailyRecord
        fields = '__all__'

class MonthlyRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = MonthlyRecord
        fields = '__all__'

class MealRecommendationSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealRecommendation
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    preferences = PreferencesSerializer()
    health_records = HealthRecordsSerializer(many=True)
    physical_records = PhysicalRecordsSerializer(many=True)
    meal_recommendation = MealRecommendationSerializer()
    daily_records = DailyRecordSerializer(many=True)
    monthly_records = MonthlyRecordSerializer(many=True)

    class Meta:
        model = User
        fields = '__all__'





        """
        extra_kwargs = {'password': {'write_only': True}}
        def create(self, validated_data):
            user = User.objects.create(**validated_data)
            user.set_password(validated_data['password'])
            user.save()
            return user

class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'name', 'email', 'preferences', 'monthly_records', 'meal_recommendations')
        extra_kwargs = {'password': {'required': False}}
        def update(self, instance, validated_data):
            instance.name = validated_data.get('name', instance.name)
            instance.email = validated_data.get('email', instance.email)
            if 'password' in validated_data:
                instance.set_password(validated_data['password'])
            instance.preferences = validated_data.get('preferences', instance.preferences)
            instance.monthly_records = validated_data.get('monthly_records', instance.monthly_records)
            instance.meal_recommendations = validated_data.get('meal_recommendations', instance.meal_recommendations)
            instance.save()
            return instance
            """
        

            