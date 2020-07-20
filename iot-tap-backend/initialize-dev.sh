#!/bin/sh

host="postgres"

until PGPASSWORD="password" psql -h $host -U "iftttuser" -c '\q' ifttt; do
  >&2 echo "DB unavailable - sleeping"
  sleep 1
done

>&2 echo "DB up - execute"

>&2 echo "Django Dev Setting"

python3 manage.py initadmin --settings=iot-tap-backend.settings.local
python3 manage.py makemigrations backend --settings=iot-tap-backend.settings.local --no-input
python3 manage.py makemigrations currentweather --settings=iot-tap-backend.settings.local --no-input
python3 manage.py migrate --settings=iot-tap-backend.settings.local --no-input
python3 manage.py runserver --settings=iot-tap-backend.settings.local 0.0.0.0:8000