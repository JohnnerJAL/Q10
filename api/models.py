from django.db import connection
from django.db import models

# Create your models here.

class User(models.Model):
    alias = models.CharField(max_length=200, unique=True)
    key = models.CharField(max_length=200)
    birthday = models.CharField(max_length=200)

    class Meta:
        db_table = 'Users'

class Test(models.Model):
    name = models.CharField(max_length=200)
    description = models.CharField(max_length=200)
    createdOn = models.CharField(max_length=200)
    Categories_id = models.CharField(max_length=200)

    class Meta:
        db_table = 'Tests'

class Game(models.Model):
    Levels_id = models.CharField(max_length=200)
    Users_id = models.CharField(max_length=200)
    Tests_id = models.CharField(max_length=200)

    class Meta:
        db_table = 'Games'