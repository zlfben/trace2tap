from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Rule(models.Model):
    rule_name = models.CharField(max_length=200, null=False)

class Device(models.Model):
    device_name = models.CharField(max_length=200, null=False)
    users = models.ManyToManyField(User)

class AbstractCharecteristic(models.Model):
    characteristic_name = models.CharField(max_length=200, null=False)

class DeviceCharecteristic(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    abstract_charecteristic = models.ForeignKey(AbstractCharecteristic,
                                                on_delete=models.CASCADE)
    affected_rules = models.ManyToManyField(Rule)
