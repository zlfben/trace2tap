#!/bin/sh

host="postgres"
dbuser="iftttuser"
dbpassword="password"

until PGPASSWORD=$dbpassword psql -h $host -U $dbuser -c '\q' iotcore; do
  >&2 echo "DB-iotcore unavailable - sleeping"
  sleep 1
done

# setup db for iot_core
echo "db_user = \"$dbuser\"\ndb_password = \"$dbpassword\"" > ./iot_core/secrets.py

>&2 echo "DB-iotcore up - execute"

python3 manage.py initadmin --settings=iot_core.settings.local
python3 manage.py makemigrations --settings=iot_core.settings.local --no-input
python3 manage.py migrate --settings=iot_core.settings.local --no-input
echo "iotcore is ready to be up - setting=local"
python3 manage.py runserver --settings=iot_core.settings.local 0.0.0.0:8001
