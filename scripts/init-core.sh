#!/bin/sh

host="postgres"

until PGPASSWORD=$(cat /run/secrets/db_password) psql -h $host -U $(cat /run/secrets/db_username) -c '\q' iotcore; do
  >&2 echo "DB-iotcore unavailable - sleeping"
  sleep 1
done

# setup db for iot_core
echo "db_user = \"$(cat /run/secrets/db_username)\"\ndb_password = \"$(cat /run/secrets/db_password)\"" > ./iot_core/secrets.py
echo "django_secret = \"$(cat /run/secrets/iotcore_django_secret)\"\n" > ./iot_core/secrets_custom.py
chmod 0600 ./iot_core/secrets.py
chmod 0600 ./iot_core/secrets_custom.py

>&2 echo "DB-iotcore up - execute"

if test "$MIGRATION" = "true"; then
  python3 manage.py makemigrations --no-input
  python3 manage.py migrate --no-input
  python3 manage.py initadmin
  python3 manage.py initapp
  python3 manage.py initcaps
fi

python3 manage.py collectstatic --no-input
chmod -R 0755 /home/iotcore/iot_core/static

if test "$DEBUG" = "false"; then
  echo "iotcore is ready to be up in prod mode"
  exec python3 manage.py runserver 0.0.0.0:8001 --settings=iot_core.settings.prod
else
  echo "iotcore is ready to be up in debug mode"
  exec python3 manage.py runserver 0.0.0.0:8001 --settings=iot_core.settings.local
fi
