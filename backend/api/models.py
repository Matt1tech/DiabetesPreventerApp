from mongoengine import Document, StringField, IntField

class User(Document):
    name = StringField(required=True)
    phone_number = StringField(required=True)
    age = IntField(required=True)
