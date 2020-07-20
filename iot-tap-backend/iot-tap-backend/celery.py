from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from . import celeryconfig


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'iot-tap-backend.settings.local')

app = Celery('iot-tap-backend')

app.config_from_object(celeryconfig, namespace='CELERY')

# app.config_from_object('django.conf:settings', namespace='CELERY') # OPTION: use celeryconfig now.

app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print('Request: {0!r}'.format(self.request))
