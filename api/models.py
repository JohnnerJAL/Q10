from django.db import connection
from django.db import models

# Create your models here.

class User(models.Model):
    alias = models.CharField(max_length=200, unique=True)
    key = models.CharField(max_length=200)
    birthday = models.CharField(max_length=200)

    class Meta:
        db_table = 'Users'