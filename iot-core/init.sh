#!/bin/sh

host="postgres"
dbuser=$1
dbpassword=$2

until PGPASSWORD=$dbpassword psql -h $host -U $dbuser -c '\q' iotcore; do
  >&2 echo "DB-iotcore unavailable - sleeping"
  sleep 1
done

# setup db for iot_core
echo "db_user = \"$dbuser\"\ndb_password = \"$dbpassword\"" > ./iot_core/secrets.py
chmod 0600 ./iot_core/secrets.py

>&2 echo "DB-iotcore up - execute"

python3 manage.py initadmin
python3 manage.py makemigrations --no-input
python3 manage.py migrate --no-input
python3 manage.py collectstatic --no-input

chmod -R 0755 /home/iotcore/iot_core/static

echo "iotcore is ready to be up"
gunicorn -b :8001 iot_core.wsgi
