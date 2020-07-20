from .base import *

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'secret'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
    'iotcore',
    'localhost',
    '127.0.0.1'
]

# CORS settings
# https://github.com/ottoyiu/django-cors-headers
# CORS whitelist
CORS_ORIGIN_WHITELIST = (
    'localhost:4200',
    '127.0.0.1:4200',
    'localhost:8000',
    '127.0.0.1:8000'
)