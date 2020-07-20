from django.db import models

class STApp(models.Model):
	st_installed_app_id = models.CharField(max_length = 40, null = False)
	refresh_token = models.CharField(max_length = 40, null = False)

class Device(models.Model):
    """
    Info about a device
    """
    device_id = models.CharField(max_length = 40)
    device_name = models.CharField(max_length = 80)
    device_label = models.CharField(max_length = 80)