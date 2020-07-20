from .base import *
from ..secrets import *
from ..secrets_custom import *

ADMINS = [('Weijia He', 'ericahexxx@gmail.com'), ('Lefan Zhang', 'zlfben17@gmail.com')]

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = django_secret

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# enable csrf protection or not
CSRF_ENABLE = True

ALLOWED_HOSTS = [
    'backend',
    'localhost',
    'localhost'
]


# Database
# https://docs.djangoproject.com/en/2.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'ifttt',
        'USER': db_username,
        'PASSWORD': db_password,
        'HOST': 'postgres'
        }
}

# CORS settings
# https://github.com/ottoyiu/django-cors-headers
# CORS whitelist
CORS_ORIGIN_WHITELIST = (
    'backend',
    'localhost',
    'localhost'
)

IOTCORE_URL = 'http://iotcore:8001/iotcore/'
IOTCORE_VD_URL = 'http://iotcore:8001/vd/'

CLIENT_ID = client_id
CLIENT_SECRET = client_secret

OAUTH2_PROVIDER = {
    'RESOURCE_SERVER_INTROSPECTION_URL': IOTCORE_URL + 'o/introspect/',
    'RESOURCE_SERVER_INTROSPECTION_CREDENTIALS': (client_id, client_secret)
}
