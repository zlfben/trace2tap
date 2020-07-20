#!/bin/bash

insertdata=false
filename=./data/backup5.sql
filenamecore=./data/iotcore.sql
migration=false

while [ "$1" != "" ]; do
    case $1 in
        --data)         shift
                        filename=$1
                        shift
                        filenamecore=$1
                        insertdata=true
                        ;;
        --init)         insertdata=true
                        migration=true
                        ;;
        --migrate)      migration=true
                        ;;
    esac
    shift
done

# admin secret for iot_core
mkdir secrets
echo "$(python3 json_parser.py -f settings.json iotcore_admin_name)" > secrets/iotcore_admin_name
echo "$(python3 json_parser.py -f settings.json iotcore_admin_email)" > secrets/iotcore_admin_email
echo "$(python3 json_parser.py -f settings.json iotcore_admin_password)" > secrets/iotcore_admin_password
echo "$(python3 json_parser.py -f settings.json backend_admin_name)" > secrets/backend_admin_name
echo "$(python3 json_parser.py -f settings.json backend_admin_email)" > secrets/backend_admin_email
echo "$(python3 json_parser.py -f settings.json backend_admin_password)" > secrets/backend_admin_password
echo "$(python3 json_parser.py -f settings.json db_username)" > secrets/db_username
echo "$(python3 json_parser.py -f settings.json db_password)" > secrets/db_password
echo "$(python3 json_parser.py -f settings.json iotcore_django_secret)" > secrets/iotcore_django_secret
echo "$(python3 json_parser.py -f settings.json backend_django_secret)" > secrets/backend_django_secret
echo "$(python3 json_parser.py -f settings.json client_id)" > secrets/client_id
echo "$(python3 json_parser.py -f settings.json client_secret)" > secrets/client_secret

# put host domain into production settings
sed -e "s/\$domain/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/local.py.iotcore > ./iot-core/iot_core/settings/local.py
sed -e "s/\$domain/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/local.py.backend > ./iot-tap-backend/iot-tap-backend/settings/local.py
sed -e "s/\$domain/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/environment.ts.template > ./ifttt-frontend/rule-creation/RMI/src/environments/environment.ts
sed -e "s/\$domain/$(python3 json_parser.py -f settings.json host_domain)/" ./templates/nginx.conf.template.dev > ./nginx/nginx.conf

FILENAME=$filename FILENAMECORE=$filenamecore docker-compose -f docker-compose.dev.yml build

if [ "$insertdata" == true ]; then
    docker-compose -f docker-compose.dev.yml down -v
    docker-compose -f docker-compose.dev.yml up -d postgres
    docker-compose -f docker-compose.dev.yml exec postgres sh /home/postgres/init-db.sh
fi

MIGRATION=$migration docker-compose -f docker-compose.dev.yml up
