#!/bin/sh

dbusername=$1
dbpassword=$2

host="postgres"

until PGPASSWORD=$dbpassword psql -h $host -U $dbusername -c '\q' ifttt; do
  >&2 echo "DB unavailable - sleeping"
  sleep 1
done

echo "db_username=\"$dbusername\"\ndb_password=\"$dbpassword\"" > /home/iftttuser/backend/iot-tap-backend/secrets.py
chmod 0600 /home/iftttuser/backend/iot-tap-backend/secrets.py

>&2 echo "DB up - execute"

python3 manage.py initadmin
python3 manage.py makemigrations backend --no-input
python3 manage.py migrate --no-input

exec python3 manage.py runserver 0.0.0.0:8000 --settings=iot-tap-backend.settings.prod
