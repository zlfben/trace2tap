#!/bin/sh

host="postgres"

until PGPASSWORD=$(cat /run/secrets/db_password) psql -h $host -U $(cat /run/secrets/db_username) -c '\q' ifttt; do
  >&2 echo "DB unavailable - sleeping"
  sleep 1
done

>&2 echo "DB up - execute"

sleep 15
if test "$DEBUG" = "false"; then
  DJANGO_SETTINGS_MODULE='iot-tap-backend.settings.prod' celery -A iot-tap-backend beat -l info --scheduler django_celery_beat.schedulers:DatabaseScheduler --pidfile=
else
  DJANGO_SETTINGS_MODULE='iot-tap-backend.settings.local' celery -A iot-tap-backend beat -l info --scheduler django_celery_beat.schedulers:DatabaseScheduler --pidfile=
fi