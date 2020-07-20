# IoT Core Framework

This is a project to provide key APIs to interact with real smart devices.

## Installation

1. The project is based on Python3. Make sure that you set up the virtual environment correctly.

```
virtualenv -p python3 venv
```

Whenever you are working on the project, please ensure you have your virtualenv activated.

For Linux/Mac:
```
source venv/bin/activate
```
For Windows:
```
source venv/Scripts/activate
```

2. Install the requirements.

```
pip install -r requirements.txt
```

3. Set up your database.

We use postgresql for the database. The database name is `iotcore`, which has to be set up by yourself (instructions at https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-django-application-on-ubuntu-14-04 under "Create a Database and Database User"). This must be done before doing anything with `python manage.py ...`, so that your database username and password are set up. You can specify your database username and password in the `secrets.py.template` file under `iot_core` folder, and then remove the `.template` part.


4. Apply migrations.

```
python manage.py migrate
```

5. Populate everything (automatically) but the capabilities.

```
python manage.py loaddata st_things.json
```

6. Start the server.

```
python manage.py runserver
```
If there are no errors, everything should be running at http://localhost:8000/


7. Populate your database.

Go to http://localhost:8000/st/capabilities/update and wait for a few seconds, the website will populate the database (the capabilities) by itself. If an error says "database is locked", try to refresh the page. This issue will be fixed later.

If you see the success message, then go to http://localhost:8000/st/capabilities/, where you should be able to see all the capabilities that Samsung SmartThings provides.

(8. Output your database data into a file, for prosperity's sake.)

The following outputs data related to all smartthings models except for capabilities:
```
./manage.py dumpdata smartthings --exclude=smartthings.capability --indent=4 > smartthings/fixtures/st_things.json
```

(Repeat step 5 to populate your database with this data.)