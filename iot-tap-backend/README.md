# IOT TAP BACKEND

This is a branch of modified code for local testing. Please do not use the file "backend/settings.py" in production.

# DATABASE UPDATE

Please manuanlly include a migration file in the `backend/migrations` folder. The code is as follows.

```
from django.db import migrations, models

class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0001_initial'), # your last migration file name
    ]

    operations = [
        migrations.RenameModel('User', 'User_ICSE19'),
    ]

```