from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class UserMetadata(models.Model):
  user = models.OneToOneField(User, on_delete=models.CASCADE)
  # other metadata?
  # user already contains user name, email, first name, last name
