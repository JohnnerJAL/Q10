from rest_framework import serializers
from api.models import Game, User, Test

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'alias', 'key', 'birthday')

class TestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Test
        fields = ('id', 'name', 'description', 'createdOn', 'Categories_id')

class GameSerializer(serializers.ModelSerializer):
    class Meta:
        model = Game
        fields = ('Levels_id', 'Users_id', 'Tests_id')