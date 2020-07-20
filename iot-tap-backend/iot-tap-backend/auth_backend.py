from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.models import User
from backend import models as m
from django.conf import settings
from django.utils import timezone

import requests
from datetime import datetime, timedelta

class IoTCoreAuthBackend(ModelBackend):
    def authenticate(self, request, username, password):
        try:
            if settings.DEBUG:
                user = User.objects.get(username=username)
                return user
            else:
                url = settings.IOTCORE_URL + "o/token/"
                data = {
                    "grant_type": "password",
                    "username": username,
                    "password": password
                }
                resp = requests.post(url, data=data, auth=(settings.CLIENT_ID, settings.CLIENT_SECRET)).json()
                if "access_token" in resp:
                    user = User.objects.get(username=username)
                    user_profile = user.userprofile
                    user_profile.access_token = resp.get("access_token", None)
                    user_profile.access_token_expired_at = self._get_now() + timedelta(seconds=resp.get("expires_in", 0))
                    user_profile.refresh_token = resp.get("refresh_token", None)
                    user_profile.save()
                    return user
                else:
                    return None
        except User.DoesNotExist:
            # the user should be 
            user = User(username=username)
            user.save()
            user_profile = m.UserProfile(
                user = user,
                access_token = resp.get("access_token", None),
                access_token_expired_at = self._get_now() + timedelta(seconds=resp.get("expires_in", 0)),
                refresh_token = resp.get("refresh_token", None)
            )
            user_profile.save()
            return user
        except Exception as e:
            raise
            # return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None
    
    def _get_now(self):
        if settings.USE_TZ:
            return timezone.now()
        else:
            return datetime.now()