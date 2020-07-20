from django.db import models

# Create your models here.
class ErrorLog(models.Model):
    '''
    Logging the exceptions
        err : the error message
    '''
    err = models.TextField(default="", blank=True, null=True)