#!/bin/sh

until psql -c '\q'; do
  >&2 echo "DB unavailable - sleeping"
  sleep 1
done

psql --command "CREATE USER $(cat /run/secrets/db_username) WITH SUPERUSER PASSWORD '$(cat /run/secrets/db_password)';"
createdb -O $(cat /run/secrets/db_username) ifttt
psql ifttt -U postgres < /home/postgres/backup5.sql
createdb -O $(cat /run/secrets/db_username) iotcore
psql iotcore -U postgres < /home/postgres/iotcore.sql
