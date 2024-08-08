import base64

from django.conf import settings
from rest_framework import serializers
from .models import *
import os 
class CustomizationsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customizations
        fields = '__all__'

class HealthRecordsSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthRecord
        fields = '__all__'


class PhysicalRecordsSerializer(serializers.ModelSerializer):
    class Meta:
        model = PhysicalRecord
        fields = '__all__'

class MealSerializer(serializers.ModelSerializer):
    class Meta:
        model = Meal
        fields = '__all__'



class RecommendationSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = Recommendation
        fields = '__all__'

    def get_image_url(self, obj):
        request = self.context.get('request')
        if request and obj.image:
            return request.build_absolute_uri(settings.MEDIA_URL +  'recommendations_images/' + str(obj.image))
        return None


    
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
    def get_image_url(self, obj):
        request = self.context.get('request')
        if request and obj.image:
            return request.build_absolute_uri(settings.MEDIA_URL +  'profile_pictures/' + str(obj.image))
        return None        
    









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
        

            