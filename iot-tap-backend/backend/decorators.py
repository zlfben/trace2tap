from django.core.exceptions import PermissionDenied
from backend.models import Device
from django.contrib.auth.models import User
from django.http import JsonResponse
import json

def device_user_required(function):
    def wrapper(request, *args, **kwargs):
        params = json.loads(request.body.decode('utf-8'))
        device = Device.objects.get(id=params['deviceid'])
        if request.user in device.users.all():
            return function(request, *args, **kwargs)
        else:
            return JsonResponse({"msg": "Permission denied!"}, status = 403)

    return wrapper

