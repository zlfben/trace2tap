
from celery.schedules import crontab


# Celery application definition
# http://docs.celeryproject.org/en/v4.3.0/userguide/configuration.html#time-and-date-settings

CELERY_BROKER_URL = 'redis://redis:6379/0'
CELERY_RESULT_BACKEND = 'redis://redis:6379/0'
CELERY_ACCEPT_CONTENT = ['application/json']
CELERY_RESULT_SERIALIZER = 'json'
CELERY_TASK_SERIALIZER = 'json'
#CELERY_TIMEZONE = 'Chicago/US'

CELERY_BEAT_SCHEDULE = {
    'record_check_timer':{
        'task': 'celery_workers.tasks.check_current_timer',
        'schedule': crontab(minute='*', hour='*')
    },
    'record_current_weather' : {
        'task': 'currentweather.tasks.record_current_weather',
        'schedule': crontab(minute='*/5', hour='*'),
        # 'args': ('Chicago',)
        }
    }
