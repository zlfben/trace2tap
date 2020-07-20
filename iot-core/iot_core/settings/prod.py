from .base import *
from ..secrets_custom import *

ADMINS = [('weijia', 'ericahexxx@gmail.com'), ('Lefan Zhang', 'zlfben17@gmail.com')]
EMAIL_HOST = "smtp.gmail.com"

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = django_secret

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ALLOWED_HOSTS = [
    'iotcore',
    'localhost'
]

# CORS settings
# https://github.com/ottoyiu/django-cors-headers
# CORS whitelist
CORS_ORIGIN_WHITELIST = (
    'iotcore',
    'localhost'
)
